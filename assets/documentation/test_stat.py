# On execute un Z-test pour obtenir la p_value et répondre à la question : y a-t-il plus d'accident lorsqu'il pleut ? 
# Hypothèse 0​ : Il n'y a pas de différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.
# Hypothèse 1​ : Il y a une différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.

import numpy as np
from statsmodels.stats.weightstats import ztest

# On créé un dataframe avec le nb total d'accidents par condition atmosphérique.
df_atm_acc = df.groupby('atm')['Accident_Id'].nunique().reset_index()
df_atm_acc

# On lance le Z-test.
z_score, p_value = ztest(df_atm_acc['atm'], df_atm_acc['Accident_Id'])
print(f'p-value : {p_value}')

# Résulat : p-value : 0.21328924662078408.
# Nous acceptons l'Hypothèse 0​ : Il n'y a pas de différence significative du nombre d'accidents sur la route entre les jours de pluie et les jours sans pluie.
# Une p-value faible (inférieure au niveau de risque de 5% ou 0,05) indique que les données fournissent des preuves suffisantes pour rejeter l'hypothèse nulle, tandis qu'une p-value élevée (supérieure inférieure au niveau de risque de 5% ou 0,05) indique qu'il n'y a pas suffisamment de preuves pour rejeter l'hypothèse nulle.
