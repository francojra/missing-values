# Valores Faltantes (Missing Values) ---------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco -----------------------------------------------------------------------------------------
# Data: 02/12/23 -----------------------------------------------------------------------------------------------------------
# Fonte: https://r4ds.hadley.nz/missing-values -----------------------------------------------------------------------------

# Introdução ---------------------------------------------------------------------------------------------------------------

## Você já tem aprendido o básico sobre valores faltantes (missing values) 
## anteriormente neste livro.
## Primeiro você viu sobre no capítulo 1 em que eles resultam em um aviso quando
## ao fazer um gráfico, bem como na seção 3.5.2 onde interferiram nos cálculos das
## estatísticas resumidas, e você aprendeu sobre sua natureza infecciosa e como
## verificar sua presença na seção 12.2.2. Agora nós vamos voltar ao
## tema em mais profundidade, para que você aprenda mais detalhes.

## Nós começaremos discutindo algumas ferramentas gerais para trabalhar com valores
## faltantes gravados como NAs. Nós então exploraremos a ideia de valores implicitamente
## faltantes, valores que são simplesmente ausentes nos seus dados, e mostrar algumas
## ferramentas que você pode usar para tornar esses valores explícitos. Terminaremos 
## com uma discussão relacionada sobre grupos vazios, causados por níveis de fatores 
## que não aparecem nos dados.

# Pré-requisitos -----------------------------------------------------------------------------------------------------------

## As funções para trabalhar com dados ausentes vem principalmente do dplyr e tidyr,
## que são membros principais do tidyverse.

library(tidyverse)

# Valores faltantes explícitos ---------------------------------------------------------------------------------------------

## Para começar, vamos explorar algumas ferramentas úteis para criar ou eliminar 
## valores faltantes explícitos, ou seja, células onde você ver um NA.

## Última observação levada adiante

## Um uso comum para valores faltantes é por conveniência da entrada de dados.Quando 
## os dados são inseridos manualmente, os valores ausentes às vezes indicam que o 
## valor da linha anterior foi repetido (ou passado adiante):

treatment <- tribble(
  ~person,           ~treatment, ~response,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         NA,
  "Katherine Burke",  1,         4
)

## Você pode preencher esses valores faltantes com tidyr::fill(). Ele funciona como um
## select() pegando um conjunto de colunas:

treatment |>
  fill(everything())

## Esse tratamento algumas vezes é chamado de "Última observação adiante", ou
## ou locf (last observation carried forward) para abreviar. Você pode usar o
## argumento .direction para preencher valores faltantes que tem sido gerados
## de maneiras mais exóticas.

## Vaores fixos

## Algumas vezes valores faltantes algum valor fixo ou conhecido, mais comumente
## o valor 0. Você pode usar dplyr::coalesce() para substituir esses valores.

x <- c(1, 4, 5, 7, NA)
coalesce(x, 0)

## Às vezes você encontrará o problema oposto, onde algum valor concreto representa,
## na verdade, um valor ausente. Isso é típico quando oa dados são gerados por
## softwares mais antigos que não tem uma maneira certa de representar os valores
## faltantes, então esses softwares usam algum valor especial do tipo 99 ou -999.

## Se possível, modifique isso ao ler os dados usando o argumento 'na' para 
## readr::read_csv(), por exemplo, read_csv(path, na = "99"). Se você descobrir
## o problema depois, ou a fonte dos seus dados não permitir uma forma de lidar
## com isso na leitura, você pode usar dplyr::na_if():

x <- c(1, 4, 5, 7, -99)
na_if(x, -99)

## NaN

## Antes de continuarmos, existe um especial tipo de valor faltante que você pode
## encontrar de vez em quando: um NaN (pronunciado "nan"), ou not a number (não é
## um número). Não é tão importante saber porque geralmente se comporta exatamente 
## como NA:

x <- c(NA, NaN)
x * 10

x == 1

is.na(x)

## Nos raros casos em que você precisa distinguir um NA de um NaN, você pode usar
## is.nan(x)

## Geralmente você encontrará um NaN quando você realizar uma operação matemática
## que tem um resultado indeterminado.

0 / 0 

0 * Inf

Inf - Inf

sqrt(-1)







