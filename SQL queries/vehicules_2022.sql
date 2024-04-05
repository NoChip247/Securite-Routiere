# CLEANING

# La colonne id_vehicule a des espaces vides qui sont en fait des espaces insécables, et qui empêchent de CAST les STRING en INT64. Il faut d’abord enlever les espaces insécables, puis passer en INT64 la colonnes id_vehicule qui est une STRING.
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
