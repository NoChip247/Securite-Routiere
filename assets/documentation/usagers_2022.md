# CLEANING

La colonne `id_usager` et `id_vehicule` ont des espaces vides qui sont en fait des espaces insécables, et qui empêchent de `CAST` les `STRING` en `INT64`. Il faut d’abord enlever les espaces insécables, puis passer en `INT64` les colonnes `id_usager` et `id_vehicule` qui sont en `STRING`.

```sql
SELECT
  Num_Acc,
  CAST(TRIM(REPLACE(id_usager, '\u00A0', '')) AS INT64) AS id_usager,
  CAST(TRIM(REPLACE(id_vehicule, '\u00A0', '')) AS INT64) AS id_vehicule,
  num_veh,
  place,
  catu,
  grav,
  sexe,
  an_nais,
  trajet,
  secu1,
  secu2,
  secu3,
  locp,
  actp,
  etatp
FROM
  `avian-slice-411310.securite_routiere.usagers_2022`
```

# VERIFICATION DE LA PRIMARY KEY

```sql
SELECT
  Num_Acc,
  COUNT(*) AS nb
FROM
  `avian-slice-411310.securite_routiere.usagers_2022_clean`
GROUP BY
  Num_Acc
HAVING
  nb > 2
ORDER BY
  nb DESC
```

# ENRICHISSEMENT

Import de la légende pour une meilleure lisibilité

```sql
SELECT
  Num_Acc,
  id_usager,
  id_vehicule,
  num_veh,
  place AS place_dans_le_vehicule,
  CASE
    WHEN catu = 1 THEN 'Conducteur'
    WHEN catu = 2 THEN 'Passager'
    WHEN catu = 3 THEN 'Piéton'
  END AS categorie_usager,
  CASE
    WHEN grav = 1 THEN 'Indemne'
    WHEN grav = 2 THEN 'Tué'
    WHEN grav = 3 THEN 'Blessé hospitalisé'
    WHEN grav = 4 THEN 'Blessé léger'
  END AS gravite,
  CASE
    WHEN sexe = 1 THEN 'Masculin'
    WHEN sexe = 2 THEN 'Féminin'
  END AS sexe,
  an_nais AS annee_naissance,
  trajet,
  secu1,
  secu2,
  secu3,
  locp,
  actp,
  etatp
FROM
  `avian-slice-411310.securite_routiere.usagers_2022_clean`
```
