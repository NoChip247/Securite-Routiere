## Test Statistique : Z-test sur les Accidents et Conditions Atmosphériques

### Exécution du Z-test pour obtenir la p-value et répondre à la question : y a-t-il plus d'accidents lorsqu'il pleut ?

**Hypothèses :**
- Hypothèse 0 : Il n'y a pas de différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.
- Hypothèse 1 : Il y a une différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.

### Code Python

Import de la librairie Numpy :
```python
import numpy as np
from statsmodels.stats.weightstats import ztest
```

Création d'un dataframe avec le nombre total d'accidents par condition atmosphérique :
```python
df_atm_acc = df.groupby('atm')['Accident_Id'].nunique().reset_index()
df_atm_acc
```

Exécution du Z-test :
```python
z_score, p_value = ztest(df_atm_acc['atm'], df_atm_acc['Accident_Id'])
print(f'p-value : {p_value}')
```

### Résultat
La p-value obtenue est **0.21328924662078408**.

Nous acceptons l'**Hypothèse 0** : Il n'y a pas de différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.

Une p-value faible (inférieure à 0,05) indique des preuves suffisantes pour rejeter l'hypothèse nulle. Une p-value élevée (supérieure à 0,05) signifie qu'il n'y a pas assez de preuves pour rejeter l'hypothèse nulle.
