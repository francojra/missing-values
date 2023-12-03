# Missing values -----------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco -----------------------------------------------------------------------------------------
# Data: 02/12/23 -----------------------------------------------------------------------------------------------------------
# Fonte: https://r4ds.hadley.nz/missing-values -----------------------------------------------------------------------------

# Introdução ---------------------------------------------------------------------------------------------------------------

## Você já tem aprendido o básico sobre valores perdidos (missing values) 
## anteriormente neste livro.
## Primeiro você viu sobre no capítulo 1 em que eles resultam em um aviso quando
## ao fazer um gráfico, bem como na seção 3.5.2 onde interferiram nos cálculos das
## estatísticas resumidas, e você aprendeu sobre sua natureza infecciosa e como
## verificar sua presença na seção 12.2.2. Agora nós vamos voltar ao
## tema em mais profundidade, para que você aprenda mais detalhes.

## Nós começaremos discutindo algumas ferramentas gerais para trabalhar com valores
## perdidos gravados como NAs. Nós então exploraremos a ideia de valores implicitamente
## ausentes, valores que são simplesmente ausentes nos seus dados, e mostrar algumas
## ferramentas que você pode usar para tornar esses valores explícitos. Terminaremos 
## com uma discussão relacionada sobre grupos vazios, causados por níveis de fatores 
## que não aparecem nos dados.

# Pré-requisitos ---------------------------------------------------------------------------------------------------------------------------

## As funções para trabalhar com dados ausentes vem principalmente do dplyr e tidyr,
## que são membros principais do tidyverse.

library(tidyverse)

