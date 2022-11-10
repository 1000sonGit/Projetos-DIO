# -*- coding: utf-8 -*-
"""Transferência de Aprendizado e Fine Tuning.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1OHcXSKMYGynYr4u5G9bWEnrHtp5gfagI

![alt text](https://live.staticflickr.com/4544/38228876666_3782386ca7_b.jpg)

## Etapa 1: Instalação das dependências
"""


"""### Fazendo o download da base de dados de gatos e cachorros"""

#!wget --no-check-certificate \
#    https://storage.googleapis.com/mledu-datasets/cats_and_dogs_filtered.zip \
#    -O ./cats_and_dogs_filtered.zip

"""## Etapa 2: Pré-processamento

### Importação das bibliotecas
"""

# Commented out IPython magic to ensure Python compatibility.
import os

os.environ["KERAS_BACKEND"] = "plaidml.keras.backend"

#import tensorflow as tf
import keras
import zipfile
import numpy as np
#import tensorflow as tf
import matplotlib.pyplot as plt

from tqdm import tqdm_notebook
#from tensorflow.keras.preprocessing.image import ImageDataGenerator


# %matplotlib inline
#print(tf.__version__)

"""### Descompactando a base de dados de gatos e cachorros"""

dataset_path = "F:/OneDrive/Cursos Python/PycharmProjects/python_teste/Udemy/TensorFlow 2.0/cats_and_dogs_filtered.zip"

zip_object = zipfile.ZipFile(file=dataset_path, mode="r")

zip_object.extractall("./")

zip_object.close()

"""### Configurando os caminhos (paths)"""

dataset_path_new = "F:/OneDrive/Cursos Python/PycharmProjects/python_teste/Udemy/TensorFlow 2.0/cats_and_dogs_filtered"

train_dir = os.path.join(dataset_path_new, "train")
validation_dir = os.path.join(dataset_path_new, "validation")

"""## Construindo o modelo

### Carregando o modelo pré-treinado (MobileNetV2)
"""
# Configurando o formato das imagens(128x128) e 3 canais(imagens coloridas). Na documentação do MobileNet tem os tamanhos pré-configurados.
img_shape = (128, 128, 3)

# include_top:False (permite definir/personalizar o cabeçalho usando só uma parte da rede neural)
# weights: pesos (no caso usou os pesos da base de dados imagenet)
base_model = keras.applications.MobileNetV2(input_shape=img_shape, include_top=False, weights="imagenet")#MobileNetV2 não roda!

base_model.summary()

"""### Congelando o modelo base"""

base_model.trainable = False

"""### Definindo o cabeçalho personalizado da rede neural"""

print(base_model.output)

# Método para diminuir a dimensionalidade, fazendo a média de cada camada para tornar mais fácil o treinamento da Rede Neural (Artigo a respeito foi citado na aula!!!)
global_average_layer = keras.layers.GlobalAveragePooling2D()(base_model.output)

print(global_average_layer)

# Camada de saída. units:qnt de neurônios. (global_average_layer): liga a camada de saída a camada de dimensão menor
prediction_layer = keras.layers.Dense(units=1, activation="sigmoid")(global_average_layer)

"""### Definindo o modelo: Unir o modelo básico ao modelo personalizado"""

# Model: Método que utiliza as camadas de entrada e saída feitas anteriormente
model = keras.models.Model(inputs=base_model.input, outputs=prediction_layer)

model.summary()

"""### Compilando o modelo"""
#lr(learning rate): taxa de aprendizagem
model.compile(optimizer=keras.optimizers.RMSprop(lr=0.0001),
              loss="binary_crossentropy", metrics=["accuracy"])

"""### Criando geradores de dados (Data Generators)

Redimensionando as imagens

    Grandes arquiteturas treinadas suportam somente alguns tamanhos pré-definidos.

Por exemplo: MobileNet (que estamos usando) suporta: (96, 96), (128, 128), (160, 160), (192, 192), (224, 224).
"""
# data_gen_train:gerador de dados de treinamento
data_gen_train = keras.preprocessing.image.ImageDataGenerator(rescale=1/255.)
data_gen_valid = keras.preprocessing.image.ImageDataGenerator(rescale=1/255.)

# Criando o gerador, que vai buscar os dados no diretório
train_generator = data_gen_train.flow_from_directory(train_dir, target_size=(128, 128), batch_size=128, class_mode="binary")
valid_generator = data_gen_train.flow_from_directory(validation_dir, target_size=(128, 128), batch_size=128, class_mode="binary")

"""### Treinando o modelo"""

model.fit_generator(train_generator, epochs=5, validation_data=valid_generator)

"""### Avaliação do modelo de transferência de aprendizagem"""

valid_loss, valid_accuracy = model.evaluate_generator(valid_generator)

print(valid_accuracy)

"""## Fine tuning


Duas questões principais:

- NÃO USE Fine Tuning em toda a rede neural, pois somente em algumas camadas já é suficiente(Descongela somente algumas camadas do topo(ponta direita do diagrama), pois já estão próximas da camada de saída).
 A ideia é adotar parte específica da rede neural para nosso problema específico
- Inicie o Fine Tuning DEPOIS que você finalizou a transferência de aprendizagem. Se você tentar o Fine Tuning imediatamente, os gradientes serão muito diferentes entre o cabeçalho personalizado e algumas camadas descongeladas do modelo base

### Descongelando algumas camadas do topo do modelo base
"""
# Fazendo o treinamento da rede neural
base_model.trainable = True
print(len(base_model.layers))

# Definindo a partir de qual camada fazer os ajustes dos pesos(descongelamento)
fine_tuning_at = 100

# Efetuando o congelamento nas camadas de 0 até 99.
for layer in base_model.layers[:fine_tuning_at]:
  layer.trainable = False

"""### Compilando o modelo para fine tuning"""

model.compile(optimizer=keras.optimizers.RMSprop(lr=0.0001), loss="binary_crossentropy", metrics=["accuracy"])

"""### Fine tuning"""
# Efetuando o treinamento das camadas com a configuração criada utilizando o Fine tuning
model.fit_generator(train_generator, epochs=5, validation_data=valid_generator)

"""### Avaliação do modelo com fine tuning"""

valid_loss, valid_accuracy = model.evaluate_generator(valid_generator)

print(valid_accuracy)
