# On execute un Z-test pour obtenir la p_value et déterminer si notre hypothèse "il y a plus d'accident lorsqu'il pleut" est vrai ou non.

import numpy as np
from statsmodels.stats.weightstats import ztest

# On créé un dataframe avec le nb total d'accidents par condition atmosphérique.
df_atm_acc = df.groupby('atm')['Accident_Id'].nunique().reset_index()
df_atm_acc

# On lance le Z-test.
z_score, p_value = ztest(df_atm_acc['atm'], df_atm_acc['Accident_Id'])
print(f'p-value : {p_value}')
# Résulat : p-value : 0.21328924662078408. On a un p_value supérieur à 5 % (ici 21 %) donc on rejète notre hypothèse "il y a plus d'accident lorsqu'il pleut" car on a 21 % de chance de se tromper (on accèpte 5 %).
