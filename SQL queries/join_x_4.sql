-- On JOIN l'ensemble des tables pour rassemble tous les éléments
SELECT
ca.*,
li.* except(Num_Acc),
us.* except(Num_Acc),
ve.* except(Num_Acc)
FROM
  avian-slice-411310.securite_routiere.caracteristiques_clean AS ca
INNER JOIN
  avian-slice-411310.securite_routiere.lieux_2022 AS li
ON
  ca.Accident_Id=li.Num_Acc
INNER JOIN
  avian-slice-411310.securite_routiere.usagers_2022_clean AS us
ON
  ca.Accident_Id=us.Num_Acc
INNER JOIN
  avian-slice-411310.securite_routiere.vehicules_clean AS ve
ON
  us.id_vehicule=ve.id_vehicule -- ATTENTION, petite subtilité ici : on fait le JOIN entre la table USAGERS et la table VEHICULES car il peut y avoir plusieurs usagers par véhicules (à l'invers des autres JOIN où il y a forcément 1 accident = 1 lieux = 1 ou plusieurs usagers)
