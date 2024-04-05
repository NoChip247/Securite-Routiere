-- PRIMARY KEY

SELECT
  Num_Acc, 
  COUNT(*) AS nb 
FROM
  `avian-slice-411310.securite_routiere.lieux_2022`
GROUP BY
  Num_Acc 
HAVING
  nb > 2
ORDER BY
  nb desc 
