# Lors de l’import initial du .csv dans BigQuery, les latitudes et longitudes du .csv était des integers FR avec des virgules (ex : 1,5485699), mais BigQuery étant ENG, a supprimé les virgules, ainsi les latitudes et longitudes n’était alors plus utilisables (ex : 15485699).
# Il a fallu réimporter le .csv en modifiant manuellement le schéma de la table pour indiquer à BigQuery que les colonnes lat et long était des STRING afin de pouvoir conserver les virgules.

# CLEANING

# Transformer la colonne hrmn de string > time
SELECT
    Accident_Id,
  jour,
  mois,
  an,
  PARSE_TIME('%H:%M', hrmn) AS heures_minutes,
  EXTRACT(HOUR FROM PARSE_TIME('%H:%M', hrmn)) AS heures,
  EXTRACT(MINUTE FROM PARSE_TIME('%H:%M', hrmn)) AS minutes,
  lum,
  dep,
  com,
  agg,
  int,
  atm,
  col,
  adr,
  lat,
  long
FROM
  `avian-slice-411310.securite_routiere.caracteristiques_2022_lat_long`
# PARSE_TIME('%H:%M', hrmn) AS heures_minutes : on transforme la string de hrmn en format heures:minutes
# EXTRACT(HOUR FROM PARSE_TIME('%H:%M', hrmn)) AS heures : on extrait l’heure
# EXTRACT(MINUTE FROM PARSE_TIME('%H:%M', hrmn)) AS minutes : on extrait les minutes
