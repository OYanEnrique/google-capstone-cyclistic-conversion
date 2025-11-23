# ==============================================================================
# ESTUDO DE CASO CYCLISTIC: ANÁLISE DE COMPARTILHAMENTO DE BICICLETAS
# PROJETO CAPSTONE - CERTIFICADO PROFISSIONAL DE ANÁLISE DE DADOS DO GOOGLE
#
# Objetivo: Identificar diferenças no uso entre membros e casuais para projetar 
#           uma estratégia de conversão.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SETUP E CARREGAMENTO DE BIBLIOTECAS (PROCESS)
# ------------------------------------------------------------------------------

# Pacotes essenciais para manipulação, limpeza e visualização de dados
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)

# Configurar o R para exibir números sem notação científica
options(scipen=999)

# ------------------------------------------------------------------------------
# 2. PROCESS: IMPORTAÇÃO, HARMONIZAÇÃO E LIMPEZA
# ------------------------------------------------------------------------------

# Importação dos datasets (assumindo que os arquivos CSV estão na pasta do projeto)
df_2019_q1 <- read_csv("Divvy_Trips_2019_Q1 - Divvy_Trips_2019_Q1.csv")
df_2020_q1 <- read_csv("Divvy_Trips_2020_Q1 - Divvy_Trips_2020_Q1.csv")

# A. HARMONIZAÇÃO, CONVERSÃO E SELEÇÃO PARA 2019
# Renomear e converter tipos de dados (solução para o erro de 'bind_rows')
df_2019_limpo <- df_2019_q1 %>%
  # Renomeia colunas inconsistentes
  rename(ride_id = trip_id, 
         started_at = start_time, 
         ended_at = end_time, 
         member_casual = usertype) %>%
  
  # Converte tipos de dados CHAVE para 'character' (Correção do erro de tipo)
  mutate(ride_id = as.character(ride_id)) %>%
  
  # Harmoniza os valores de 'usertype' (Subscriber/Customer) para 'member/casual'
  mutate(member_casual = recode(member_casual,
                                "Subscriber" = "member",
                                "Customer" = "casual")) %>%
  
  # Seleciona apenas as colunas essenciais
  select(ride_id, started_at, ended_at, member_casual)


# B. HARMONIZAÇÃO, CONVERSÃO E SELEÇÃO PARA 2020
df_2020_limpo <- df_2020_q1 %>%
  # Converte tipos de dados CHAVE para 'character'
  mutate(ride_id = as.character(ride_id)) %>%
  
  # Seleciona apenas as colunas essenciais
  select(ride_id, started_at, ended_at, member_casual)

# C. UNIFICAÇÃO DOS DADOS (PROCESS: Merge/Union)
dados_unificados <- bind_rows(df_2019_limpo, df_2020_limpo)


# D. CRIAÇÃO DE NOVAS COLUNAS E LIMPEZA DE ANOMALIAS (PROCESS)
dados_tratados <- dados_unificados %>%
  # 1. Calcula a duração da viagem ('ride_length') em minutos
  mutate(ride_length = difftime(ended_at, started_at, units = "mins")) %>%
  
  # 2. Calcula o dia da semana ('day_of_week') (1=Dom, 7=Sáb)
  mutate(day_of_week = wday(started_at, label = TRUE, week_start = 1)) %>%
  
  # 3. Limpeza: Remove anomalias (viagens <= 1 minuto) e NAs
  filter(ride_length > 1) %>% 
  drop_na()

# ------------------------------------------------------------------------------
# 3. ANALYZE: CÁLCULOS E ESTATÍSTICAS DESCRITIVAS
# ------------------------------------------------------------------------------

# 3.1. Estatísticas descritivas comparativas (Média, Mediana, Máximo)
estatisticas_comparativas <- dados_tratados %>%
  group_by(member_casual) %>%
  summarise(
    contagem_total = n(),
    media_duracao_min = mean(ride_length),
    mediana_duracao_min = median(ride_length),
    max_duracao_min = max(ride_length)
  )

# Output no Terminal para fins de documentação (como solicitado no PDF)
print("Estatísticas Comparativas:")
print(estatisticas_comparativas)


# 3.2. Agregação por Dia da Semana e Tipo de Usuário (Contagem e Média de Duração)
uso_semanal <- dados_tratados %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    contagem_viagens = n(),
    media_duracao_min = mean(ride_length),
  ) %>%
  ungroup()

# Output no Terminal para fins de documentação (como solicitado no PDF)
print("Uso Semanal Agregado (Contagem e Média):")
print(uso_semanal)


# ------------------------------------------------------------------------------
# 4. SHARE: CRIAÇÃO DAS VISUALIZAÇÕES (GGPLOT2)
# ------------------------------------------------------------------------------

# 4.1. Gráfico 1: Comparação da Duração Média da Viagem

grafico_duracao_media <- ggplot(estatisticas_comparativas, aes(x = member_casual, y = media_duracao_min, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(
    title = "Comparação da Duração Média da Viagem",
    subtitle = "Casuais usam a bicicleta por mais tempo (Lazer) do que Membros (Deslocamento)",
    x = "Tipo de Usuário",
    y = "Duração Média (Minutos)",
    fill = "Tipo de Usuário"
  ) +
  scale_y_continuous(labels = scales::number_format(accuracy = 1)) +
  scale_fill_manual(values = c("casual" = "#00BFC4", "member" = "#F8766D")) +
  theme_minimal()

# Salvar o Gráfico 1 para o GitHub
ggsave("Comparação da Duração Média.png", plot = grafico_duracao_media, width = 8, height = 5)


# 4.2. Gráfico 2: Volume de Viagens por Dia da Semana

grafico_volume_semanal <- ggplot(uso_semanal, aes(x = day_of_week, y = contagem_viagens, group = member_casual, color = member_casual)) +
  geom_line(linewidth = 1.5) +
  geom_point(size = 3) +
  labs(
    title = "Volume de Viagens por Dia da Semana",
    subtitle = "Membros focam em dias úteis; Casuais focam em fins de semana",
    x = "Dia da Semana",
    y = "Contagem de Viagens",
    color = "Tipo de Usuário"
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("casual" = "#00BFC4", "member" = "#F8766D")) +
  theme_minimal()

# Salvar o Gráfico 2 para o GitHub
ggsave("Volume de Viagens por Dia da Semana.png", plot = grafico_volume_semanal, width = 10, height = 6)