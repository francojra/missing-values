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

# Valores faltantes implícitos -------------------------------------------------------------------------------------------------------------

## Até agora falamos sobre valores faltantes que são explicitamente faltantes,
## por exemplo, você pode ver um NA em seus dados. Mas os valores faltantes também
## podem ser implicitamente faltantes, como toda uma linha dos dados simplesmente
## sem nenhum dado (célula vazia). Vamos ilustrar a diferença com um simples conjunto
## de dados que registra o preço de algumas ações a cada trimestre.

stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
) 

## Esse conjunto de dados tem duas informações faltantes

## - O preço do 4º trimestre de 2020 é explicitamente faltante, porque o valor
## está marcado com NA.
## - As informações do 1º trimestre de 2021 está implicitamente faltando, ou seja,
## simplemente não aparecem no conjunto de dados.

## Uma forma para pensar nessa diferença é com o Zen-like Koan:

## - Um valor faltante explícito é a presença de uma ausência.
## - Um valor faltante implícito é a ausência de uma presença.

## Algumas vezes você quer tornar valores faltantes implícitos explícitos para
## ter algo físico em seu trabalho. Em outros casos, os valores faltantes explícitos
## fazem parte da estrutura dos dados e você deseja se livrar desses valores. A
## seção seguinte discute algumas ferramentas para alternar entre valores faltantes
## explícitos e implícitos.

## Pivoting (Girando os dados)

## Você já tem visto uma ferramenta que torna valores faltantes implícitos em
## explícitos e vice-versa: pivoting. Tornar os dados wider (mais amplo) torna
## os valores faltantes implícitos em explícitos porque cada combinação de linhas
## e novas colunas deve ter algum valor, Por exemplo, se nós girarmos a tabela
## stocks para colocar os trimestres em colunas, ambos valores faltantes implícitos
## se tornam explícitos:

stocks |>
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )

## Por padrão, o formato longer (mais longo) dos dados preserva os valores
## faltantes explícitos, mas se houver valores estruturalmente ausentes que 
## só existem porque os dados não estão organizados, você pode descartá-los 
## (torná-los implícitos) usando values_drop_na = TRUE. Veja os exemplos na
## seção 5.2 para mais detalhes.

stocks1 <- stocks |>
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )

stocks2 <- stocks1 |>
  pivot_longer(
    cols = c("1", "2", "3", "4"),
    names_to = "Trimestre",
    values_to = "Preços",
    values_drop_na = TRUE) |>
view()

## Complete (Completo)

## tidyr::complete() permite a você gerar valores faltantes explícitos por promover
## um conjunto de variáveis que define a combinação de linhas que deveriam existir.
## Por exemplo, nós sabemos que todas as combinações do ano e do trimestre deveriam
## existir nos dados de ações (stocks):

stocks |>
  complete(year, qtr)

## Basicamente, você irá chamar a função complete() com os nomes das variáveis que
## existem nos seus dados, preenchendo as combinações que faltam. No entanto, às vezes
## as variáveis individuais estão incompletas, então você pode fornecer seus próprios 
## dados. Por exemplo, você pode saber que o conjunto de dados stocks deve funcionar
## de 2019 a 2021, então você poderia explicitamente fornecer esses valores para 
## ano: 

stocks |>
  complete(year = 2019:2021, qtr) |>
  view()

## Se o intervalo de uma variável estiver correto, mas nem todos os valores estiverem
## presentes, você poderá usar full_seq(x, 1) para gerar todos os valores para gerar 
## todos os valores de min(x) a max(x) espaçados por 1.

x <- c(7, 5, 6, 2)

full_seq(x, 1)

## Em alguns casos, o conjunto completo de observações não pode ser gerado por uma
## simples combinação de variáveis. Neste caso, você pode fazer manualmente o que
## o complete faz para você: cria um data frame que contem todas as linhas que deveriam
## existir (usando qualquer combinação de técnicas que você precisar),então combine esse
## data frame com seu original conjunto de dados usando dplyr::full_join().

meus_dados <- tibble(
  year  = c(2022, 2022, 2022, 2023, 2023, 2023),
  qtr   = c(   1,    2,    3,    4,    2,    3),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17)
) 

stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
) 

conjunto <- dplyr::full_join(meus_dados, stocks)
view(conjunto)

## Joins (Juntar)

## Isso nos traz uma outra importante forma de revelar valores faltantes implícitos:
## joins. Você irá aprender mais sobre joins no capítulo 19, mas nós queremos rapidamente
## mencionar sobre joins aqui, já que muitas vezes você só pode saber que valores
## estão faltante em um conjunto de dados quando você o compara com outro:

## dplyr::anti_join(x, y) é uma ferramenta útil aqui porque ele seleciona apenas
## as linhas em x que não tem match em y. Por exemplo, nós podemos usar dois
## anti_join()s para revelar que nós estamos perdendo informações para quatro
## aeroportos e 722 aviões mencionados nos dados flights:

library(nycflights13)

flights |> 
  distinct(faa = dest) |> 
  anti_join(airports)


flights |> 
  distinct(tailnum) |> 
  anti_join(planes)

# Fatores e grupos vazios ------------------------------------------------------------------------------------------------------------------

## Um último tipo de falta de dados é o grupo vazio, um grupo que não contem qualquer
## observação, que pode surgir ao trabalhar com fatores. Por exemplo, imagine que temos
## um conjunto de dados que contem algumas informações sobre a saúde das pessoas:

health <- tibble(
  name   = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
  smoker = factor(c("no", "no", "no", "no", "no"), levels = c("yes", "no")),
  age    = c(34, 88, 75, 47, 56),
)

## E nós queremos contar o número de fumantes com dplyr::count():

health |> count(smoker)

## Esse conjunto de dados contem apenas não-fumantes, mas nós sabemos que existem 
## fumantes; o grupo de não-fumantes está vazio. Nós podemos usar count() para manter 
## todos os grupos, mesmo aqueles que não vemos nos dados usando .drop = FALSE:

health |> count(smoker, .drop = FALSE)

## O mesmo princípio se aplica aos eixos discretos do ggplot2, que irá também pular
## os níveis que não apresentam nenhum valor. Você pode forçar o ggplot2 a exibir
## fornecendo drop = FALSE para os apropriados eixos discretos:

ggplot(health, aes(x = smoker)) +
  geom_bar() +
  scale_x_discrete()

ggplot(health, aes(x = smoker)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

## O mesmo problema surge de forma mais geral com dplyr::group_by(). E novamente você
## pode usar .drop = FALSE para manter todos os níveis dos fatores:

health |> 
  group_by(smoker, .drop = FALSE) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  ) |>
  view()

## Nós obtemos alguns resultados interessantes aqui porque quando você resume os dados
## de um grupo vazio, as funções de resumo (summary) são aplicadas a vetores de 
## comprimento zero. Existe uma importante distinção entre vetores vazios com comprimento
## zero e valores faltantes, que tem cada um deles tem comprimento 1.

# A vector containing two missing values
x1 <- c(NA, NA)
length(x1)


# A vector containing nothing
x2 <- numeric()
length(x2)
