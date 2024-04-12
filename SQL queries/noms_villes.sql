-- Récupération d'un fichier csv de l'INSEE avec les codes communes et noms des villes : https://www.insee.fr/fr/information/6800675

-- Suppression des sous-communes rattachées à des communes
SELECT
*
FROM `avian-slice-411310.securite_routiere.noms_villes`
WHERE REG IS NOT NULL
