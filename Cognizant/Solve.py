import pandas as pd
from pandas import DataFrame
import re

l_word, l_num = [], []
data = pd.read_fwf('resultado_part-00000.txt')
df = DataFrame(data)

for i in df["Dados"]:
    p = re.findall(r'\w+', i)
    # Condicional para armazenar valores naõ nulos
    if len(p) == 2 and p[1].isnumeric():
        l_word.append(p[0])
        l_num.append(int(p[1]))
    # Condicional para armazenar valores nulos
    elif p[0].isnumeric():
        l_word.append('blank')
        l_num.append(int(p[0]))
# Dicionário que armazena os valores
dict = {'Word': l_word, 'Number': l_num}
# Criando novo dataframe
dados = DataFrame(dict, columns=['Word', 'Number'])
# Ordenando dataframe de forma decrescente
dados['Number'].sort_values(ascending=False)
# Imprimindo os 10 maiores
print(dados.head(10))
