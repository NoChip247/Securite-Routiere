# Nettoyage et Enrichissement des Données BigQuery

## Import du fichier

Lors de l’import initial du fichier `.csv` dans BigQuery, les latitudes et longitudes du fichier étaient des nombres entiers au format français avec des virgules (ex : `1,5485699`). BigQuery étant configuré en anglais, il a supprimé les virgules, rendant ainsi ces données inutilisables (ex : `15485699`).

Il a donc été nécessaire de réimporter le fichier `.csv` en modifiant manuellement le schéma de la table afin d’indiquer à BigQuery que les colonnes `lat` et `long` étaient des `STRING`, permettant ainsi de conserver les virgules.

---

## Cleaning

### Transformer la colonne `hrmn` de `STRING` à `TIME`

```sql
SELECT
    Accident_Id,
    jour,
    mois,
    an,
    PARSE_TIME('%H:%M', hrmn) AS heures_minutes,
    EXTRACT(HOUR FROM PARSE_TIME('%H:%M', hrmn)) AS heures,
    EXTRACT(MINUTE FROM PARSE_TIME('%H:%M', hrmn)) AS minutes,
    lum,
    dep,
    com,
    agg,
    int,
    atm,
    col,
    adr,
    lat,
    long
FROM
    `avian-slice-411310.securite_routiere.caracteristiques_2022_lat_long`
```

- `PARSE_TIME('%H:%M', hrmn) AS heures_minutes` : transformation de la colonne `hrmn` en format `heures:minutes`.
- `EXTRACT(HOUR FROM PARSE_TIME('%H:%M', hrmn)) AS heures` : extraction de l’heure.
- `EXTRACT(MINUTE FROM PARSE_TIME('%H:%M', hrmn)) AS minutes` : extraction des minutes.

---

## Vérification de la Primary Key

```sql
SELECT
    Accident_Id,
    COUNT(*) AS nb
FROM
    `avian-slice-411310.securite_routiere.caracteristiques_clean`
GROUP BY
    Accident_Id
HAVING
    nb > 2
ORDER BY
    nb DESC;
```

---

## Enrichissement

### Génération de la colonne `jour_de_la_semaine`

On concatène les colonnes `an`, `mois`, `jour`, puis on cast cette nouvelle `STRING` en `DATE`, et enfin on formate la date en jour de la semaine.

```sql
WITH sub1 AS (
    SELECT
        Accident_Id,
        CONCAT(an, '-', mois, '-', jour) AS full_date
    FROM
        `avian-slice-411310.securite_routiere.caracteristiques_clean`
),  
sub2 AS (
    SELECT
        Accident_Id,
        CAST(sub1.full_date AS DATE) AS date_ok
    FROM
        sub1
),
sub3 AS (
    SELECT  
        Accident_Id,
        FORMAT_DATE('%A', date_ok) AS jour_de_la_semaine  
    FROM
        sub2
)
SELECT * FROM sub3;
```

---

### Importation des noms de départements

```sql
SELECT
    car.*,
    dpt.*
FROM `avian-slice-411310.securite_routiere.caracteristiques_clean` AS car
LEFT JOIN `avian-slice-411310.securite_routiere.dpt_fr` AS dpt
ON car.dep = dpt.code_departement;
```

---

### Ajout du préfixe `FR-` aux départements

```sql
SELECT
    *,
    CONCAT('FR-', CAST(dep AS STRING)) AS fr_dep
FROM
    `avian-slice-411310.securite_routiere.caracteristiques_dpt`;
```

---

### Ajout des légendes pour une meilleure lisibilité

```sql
WITH sub1 AS (
    SELECT
        Accident_Id,
        jour,
        mois,
        an,
        heures_minutes,
        heures,
        minutes,
        CASE
            WHEN lum = 1 THEN 'Plein jour'
            WHEN lum = 2 THEN 'Crépuscule ou aube'
            WHEN lum = 3 THEN 'Nuit sans éclairage public'
            WHEN lum = 4 THEN 'Nuit avec éclairage public non allumé'
            WHEN lum = 5 THEN 'Nuit avec éclairage public allumé'
        END AS lumiere,
        CONCAT('FR-', CAST(dep AS STRING)) AS fr_dep,
        com,
        CASE
            WHEN agg = 1 THEN 'Hors agglomération'
            WHEN agg = 2 THEN 'En agglomération'
        END AS agglomeration,
        CASE
            WHEN int = 1 THEN 'Hors intersection'
            WHEN int = 2 THEN 'Intersection en X'
            WHEN int = 3 THEN 'Intersection en T'
            WHEN int = 4 THEN 'Intersection en Y'
            WHEN int = 5 THEN 'Intersection à plus de 4 branches'
            WHEN int = 6 THEN 'Giratoire'
            WHEN int = 7 THEN 'Place'
            WHEN int = 8 THEN 'Passage à niveau'
            WHEN int = 9 THEN 'Autre intersection'
        END AS intersection,
        CASE
            WHEN atm = -1 THEN 'Non renseigné'
            WHEN atm = 1 THEN 'Normale'
            WHEN atm = 2 THEN 'Pluie légère'
            WHEN atm = 3 THEN 'Pluie forte'
            WHEN atm = 4 THEN 'Neige - grêle'
            WHEN atm = 5 THEN 'Brouillard - fumée'
            WHEN atm = 6 THEN 'Vent fort - tempête'
            WHEN atm = 7 THEN 'Temps éblouissant'
            WHEN atm = 8 THEN 'Temps couvert'
            WHEN atm = 9 THEN 'Autre'
        END AS conditions_atmospheriques,
        CASE
            WHEN col = -1 THEN 'Non renseigné'
            WHEN col = 1 THEN 'Deux véhicules - frontale'
            WHEN col = 2 THEN 'Deux véhicules - par l’arrière'
            WHEN col = 3 THEN 'Deux véhicules - par le côté'
            WHEN col = 4 THEN 'Trois véhicules et plus - en chaîne'
            WHEN col = 5 THEN 'Trois véhicules et plus - collisions multiples'
            WHEN col = 6 THEN 'Autre collision'
            WHEN col = 7 THEN 'Sans collision'
        END AS type_de_collision,
        adr AS adresse_postale,
        REPLACE(lat, ',', '.') AS latitude,
        REPLACE(long, ',', '.') AS longitude
    FROM
        `avian-slice-411310.securite_routiere.caracteristiques_clean`
),
sub2 AS (
    SELECT
        car.*,
        vil.NCC AS ville
    FROM sub1 AS car
    LEFT JOIN `avian-slice-411310.securite_routiere.noms_villes_not_null` AS vil
    ON car.com = vil.COM
)
SELECT * FROM sub2;
```

