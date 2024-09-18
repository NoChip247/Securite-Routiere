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



-- ENRICHISSEMENT

-- Import de la légende dans la table pour une meilleure lisibilité
  
SELECT
Num_Acc,
CASE
  WHEN catr = 1 THEN 'Autoroute'
  WHEN catr = 2 THEN 'Route nationale'
  WHEN catr = 3 THEN 'Route Départementale'
  WHEN catr = 4 THEN 'Voie Communales'
  WHEN catr = 5 THEN 'Hors réseau public'
  WHEN catr = 6 THEN 'Parc de stationnement ouvert à la circulation publique'
  WHEN catr = 7 THEN 'Routes de métropole urbaine'
  WHEN catr = 9 THEN 'Autre'
  END AS categorie_de_route,
voie,	
v1,
v2,
CASE
  WHEN circ = -1 THEN 'Non renseigné'
  WHEN circ = 1 THEN 'A sens unique'
  WHEN circ = 2 THEN 'Bidirectionnelle'
  WHEN circ = 3 THEN 'A chaussées séparées'
  WHEN circ = 4 THEN 'Avec voies daffectation variable'
  END AS sens_de_circulation,
nbv AS Nb_de_voies_de_circulation,
CASE
  WHEN vosp = -1 THEN 'Non renseigné'
  WHEN vosp = 0 THEN 'Sans objet'
  WHEN vosp = 1 THEN 'Piste cyclable'
  WHEN vosp = 2 THEN 'Bande cyclable'
  WHEN vosp = 3 THEN 'Voie réservée'
  END AS presence_voie_reservee,
CASE
  WHEN prof = -1 THEN 'Non renseigné'
  WHEN prof = 1 THEN 'Plat'
  WHEN prof = 2 THEN 'Pente'
  WHEN prof = 3 THEN 'Sommet de côte'
  WHEN prof = 4 THEN 'Bas de côte'
  END AS profil_1,	
pr,
pr1,
CASE
  WHEN plan = -1 THEN 'Non renseigné'
  WHEN plan = 1 THEN 'Partie rectiligne'
  WHEN plan = 2 THEN 'En courbe à gauche'
  WHEN plan = 3 THEN 'En courbe à droite'
  WHEN plan = 4 THEN 'En S'
  END AS profil_2,
lartpc,
larrout,
CASE
  WHEN surf = -1 THEN 'Non renseigné'
  WHEN surf = 1 THEN 'Normale'
  WHEN surf = 2 THEN 'Mouillée'
  WHEN surf = 3 THEN 'Flaques'
  WHEN surf = 4 THEN 'Inondée'
  WHEN surf = 5 THEN 'Enneigée'
  WHEN surf = 6 THEN 'Boue'
  WHEN surf = 7 THEN 'Verglacée'
  WHEN surf = 8 THEN 'Corps gras - huile'
  WHEN surf = 9 THEN 'Autre'
  END AS surface_route,
infra,
situ,
vma AS vitesse_maximale_autorisee,
FROM
  `avian-slice-411310.securite_routiere.lieux_2022`
