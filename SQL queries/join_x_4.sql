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





-- On CONCAT les colonnes "an", "mois", "jour", puis on CAST cette nouvelle STRING en DATE, et enfin on formate la date en jour de la semaine
WITH
  sub1 AS (
    SELECT
      Accident_Id,
      CONCAT(an, '-', mois, '-', jour) AS full_date
    FROM
      `avian-slice-411310.securite_routiere.join_x_4`
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


SELECT *
FROM sub3;
