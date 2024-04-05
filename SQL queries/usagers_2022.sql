-- CLEANING

-- La colonne id_usager et id_vehicule ont des espaces vides qui sont en fait des espaces insécables, et qui empêchent de CAST les STRING en INT64. Il faut d’abord enlever les espaces insécables, puis passer en INT64 les colonnes id_usager et id_vehicule qui sont en STRING
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

-- PRIMARY KEY

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
