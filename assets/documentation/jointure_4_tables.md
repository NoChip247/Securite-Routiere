Les 4 tables sont rassemblées pour rapprocher tous les éléments.
```sql
SELECT
  ca.*,
  li.* EXCEPT(Num_Acc),
  us.* EXCEPT(Num_Acc),
  ve.* EXCEPT(Num_Acc)
FROM
  `avian-slice-411310.securite_routiere.caracteristiques_clean` AS ca
INNER JOIN
  `avian-slice-411310.securite_routiere.lieux_2022` AS li
ON
  ca.Accident_Id = li.Num_Acc
INNER JOIN
  `avian-slice-411310.securite_routiere.usagers_2022_clean` AS us
ON
  ca.Accident_Id = us.Num_Acc
INNER JOIN
  `avian-slice-411310.securite_routiere.vehicules_clean` AS ve
ON
  us.id_vehicule = ve.id_vehicule
```

ATTENTION : on fait le `JOIN` entre la table `USAGERS` et la table `VEHICULES` car il peut y avoir plusieurs usagers par véhicules (à l'inverse des autres `JOIN` où il y a forcément 1 accident = 1 lieu = 1 ou plusieurs usagers).
