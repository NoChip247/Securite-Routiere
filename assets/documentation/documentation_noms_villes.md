## Récupération des Données INSEE

### Récupération d'un fichier CSV de l'INSEE contenant les codes communes et noms des villes

Source : [INSEE - Codes Communes](https://www.insee.fr/fr/information/6800675)

### Suppression des sous-communes rattachées à des communes

```sql
SELECT
    *
FROM
    `avian-slice-411310.securite_routiere.noms_villes`
WHERE
    REG IS NOT NULL;
```

