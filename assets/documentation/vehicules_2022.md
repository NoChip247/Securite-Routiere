# CLEANING

La colonne `id_vehicule` a des espaces vides qui sont en fait des espaces insécables, et qui empêchent de `CAST` les `STRING` en `INT64`. Il faut d’abord enlever les espaces insécables, puis passer en `INT64` la colonne `id_vehicule` qui est une `STRING`.

```sql
SELECT
  Num_Acc,
  CAST(TRIM(REPLACE(id_vehicule, '\u00A0', '')) AS INT64) AS id_vehicule,
  num_veh,
  senc,
  catv,
  obs,
  obsm,
  choc,
  manv,
  motor,
  occutc
FROM
  `avian-slice-411310.securite_routiere.vehicules_2022`
```

# VERIFICATION DE LA PRIMARY KEY

```sql
SELECT
  Num_Acc,
  COUNT(*) AS nb
FROM
  `avian-slice-411310.securite_routiere.vehicules_clean`
GROUP BY
  Num_Acc
HAVING
  nb > 2
ORDER BY
  nb desc
```

# ENRICHISSEMENT

Import de la légende pour une meilleure lisibilité

```sql
SELECT
  Num_Acc,
  id_vehicule,
  num_veh,
  senc,
  CASE
    WHEN catv = 00 THEN 'Indéterminable'
    WHEN catv = 01 THEN 'Bicyclette'
    WHEN catv = 02 THEN 'Cyclomoteur <50cm3'
    WHEN catv = 03 THEN 'Voiturette (Quadricycle à moteur carrossé) (anciennement "voiturette ou tricycle à moteur")'
    WHEN catv = 04 THEN 'Référence inutilisée depuis 2006 (scooter immatriculé)'
    WHEN catv = 05 THEN 'Référence inutilisée depuis 2006 (motocyclette)'
    WHEN catv = 06 THEN 'Référence inutilisée depuis 2006 (side-car)'
    WHEN catv = 07 THEN 'VL seul'
    WHEN catv = 08 THEN 'Référence inutilisée depuis 2006 (VL + caravane)'
    WHEN catv = 09 THEN 'Référence inutilisée depuis 2006 (VL + remorque)'
    WHEN catv = 10 THEN 'VU seul 1,5T <= PTAC <= 3,5T avec ou sans remorque (anciennement VU seul 1,5T <= PTAC <= 3,5T)'
    WHEN catv = 11 THEN 'Référence inutilisée depuis 2006 (VU (10) + caravane)'
    WHEN catv = 12 THEN 'Référence inutilisée depuis 2006 (VU (10) + remorque)'
    WHEN catv = 13 THEN 'PL seul 3,5T <PTCA <= 7,5T'
    WHEN catv = 14 THEN 'PL seul > 7,5T'
    WHEN catv = 15 THEN 'PL > 3,5T + remorque'
    WHEN catv = 16 THEN 'Tracteur routier seul'
    WHEN catv = 17 THEN 'Tracteur routier + semi-remorque'
    WHEN catv = 18 THEN 'Référence inutilisée depuis 2006 (transport en commun)'
    WHEN catv = 19 THEN 'Référence inutilisée depuis 2006 (tramway)'
    WHEN catv = 20 THEN 'Engin spécial'
    WHEN catv = 21 THEN 'Tracteur agricole'
    WHEN catv = 30 THEN 'Scooter < 50 cm3'
    WHEN catv = 31 THEN 'Motocyclette > 50 cm3 et <= 125 cm3'
    WHEN catv = 32 THEN 'Scooter > 50 cm3 et <= 125 cm3'
    WHEN catv = 33 THEN 'Motocyclette > 125 cm3'
    WHEN catv = 34 THEN 'Scooter > 125 cm3'
    WHEN catv = 35 THEN 'Quad léger <= 50 cm3 (Quadricycle à moteur non carrossé)'
    WHEN catv = 36 THEN 'Quad lourd > 50 cm3 (Quadricycle à moteur non carrossé)'
    WHEN catv = 37 THEN 'Autobus'
    WHEN catv = 38 THEN 'Autocar'
    WHEN catv = 39 THEN 'Train'
    WHEN catv = 40 THEN 'Tramway'
    WHEN catv = 41 THEN '3RM <= 50 cm3'
    WHEN catv = 42 THEN '3RM > 50 cm3 <= 125 cm3'
    WHEN catv = 43 THEN '3RM > 125 cm3'
    WHEN catv = 50 THEN 'EDP à moteur'
    WHEN catv = 60 THEN 'EDP sans moteur' 
    WHEN catv = 80 THEN 'VAE'
    WHEN catv = 99 THEN 'Autre véhicule'
  END AS categorie_vehicule,
  CASE
    WHEN obs = -1 THEN 'Non renseigné'
    WHEN obs = 0 THEN 'Sans objet'
    WHEN obs = 1 THEN 'Véhicule en stationnement'
    WHEN obs = 2 THEN 'Arbre'
    WHEN obs = 3 THEN 'Glissière métallique'
    WHEN obs = 4 THEN 'Glissière béton'
    WHEN obs = 5 THEN 'Autre glissière'
    WHEN obs = 6 THEN 'Bâtiment, mur, pile de pont'
    WHEN obs = 7 THEN 'Support de signalisation verticale ou poste d’appel d’urgence'
    WHEN obs = 8 THEN 'Poteau'
    WHEN obs = 9 THEN 'Mobilier urbain'
    WHEN obs = 10 THEN 'Parapet'
    WHEN obs = 11 THEN 'Ilot, refuge, borne haute'
    WHEN obs = 12 THEN 'Bordure de trottoir'
    WHEN obs = 13 THEN 'Fossé, talus, paroi rocheuse'
    WHEN obs = 14 THEN 'Autre obstacle fixe sur chaussée'
    WHEN obs = 15 THEN 'Autre obstacle fixe sur trottoir ou accotement'
    WHEN obs = 16 THEN 'Sortie de chaussée sans obstacle'
    WHEN obs = 17 THEN 'Buse ou tête d'aqueduc'
  END AS obstacle_fixe_heurte,
  CASE
    WHEN obsm = -1 THEN 'Non renseigné'
    WHEN obsm = 0 THEN 'Aucun'
    WHEN obsm = 1 THEN 'Piéton'
    WHEN obsm = 2 THEN 'Véhicule'
    WHEN obsm = 4 THEN 'Véhicule sur rail'
    WHEN obsm = 5 THEN 'Animal domestique'
    WHEN obsm = 6 THEN 'Animal sauvage'
    WHEN obsm = 9 THEN 'Autre'
  END AS obstacle_mobile_heurte,
  CASE
    WHEN choc = -1 THEN 'Non renseigné'
    WHEN choc = 0 THEN 'Aucun'
    WHEN choc = 1 THEN 'Avant'
    WHEN choc = 2 THEN 'Avant droit'
    WHEN choc = 3 THEN 'Avant gauche'
    WHEN choc = 4 THEN 'Arrière'
    WHEN choc = 5 THEN 'Arrière droit'
    WHEN choc = 6 THEN 'Arrière gauche'
    WHEN choc = 7 THEN 'Côté droit'
    WHEN choc = 8 THEN 'Côté gauche'
    WHEN choc = 9 THEN 'Chocs multiples (tonneaux)'
  END AS point_choc_initial,
  manv,
  motor,
  occutc
FROM
  `avian-slice-411310.securite_routiere.vehicules_clean`
```
