# 📈 Cyclistic Bike-Share: Análise Preditiva de Conversão de Clientes

## 🚀 Visão Geral do Projeto (Destaque para Recrutadores)

Este projeto demonstra a aplicação completa da metodologia de análise de dados (Ask, Prepare, Process, Analyze, Share, Act) para resolver um desafio de negócio com foco em **crescimento de receita** e **segmentação de clientes**.

**Desafio de Negócio:** Maximizar a lucratividade da Cyclistic através da conversão de usuários casuais (menos lucrativos) em membros anuais (mais lucrativos).

**Solução Analítica:** Utilizar dados históricos para **segmentar** e **entender as diferenças comportamentais** entre usuários casuais e membros anuais, criando uma estratégia de marketing altamente direcionada.

* **Habilidades Técnicas:** Análise Comportamental, Manipulação de Dados em R (Tidyverse, Lubridate), SQL Concepts (Union, Aggregation), e Visualização de Dados (ggplot2).
* **Valor para o Negócio:** Fornecer **três recomendações acionáveis e baseadas em dados** para otimizar o investimento em marketing e impulsionar a aquisição de membros.

---

## 1. Ask (Perguntar) ❓

### **Tarefa de Negócio**

Analisar os dados históricos de viagens de bicicleta da Cyclistic para entender **como os membros anuais e os usuários casuais usam as bicicletas de forma diferente**. Este insight orientará a criação de uma nova estratégia de marketing focada na **conversão de usuários casuais em membros anuais**.

---

## 2. Prepare (Preparar) 💾

### **Descrição da Fonte de Dados**

Os dados utilizados são os **dados históricos de viagens de bicicleta** da Cyclistic (nome fictício para dados Divvy), abrangendo o **Primeiro Trimestre de 2019 e 2020 (Q1)**, conforme a recomendação para análise em R.

* **Restrições:** A análise é restrita pela **privacidade de dados**, o que proíbe o uso de informações de identificação pessoal (PII) e impede a ligação de compras de passes a cartões de crédito.

---

## 3. Process (Processar) ⚙️

### **Documentação de Limpeza e Manipulação**

O processamento foi realizado em **RStudio** (código detalhado em `cyclistic_analysis.R`) e incluiu:

* **Harmonização de Estrutura:** Renomear e padronizar colunas (`usertype` para `member_casual`, etc.).
* **Conversão Crítica de Tipo:** A coluna `ride_id` foi explicitamente convertida para `character` para permitir a unificação correta dos *datasets*.
* **Unificação de Dados:** Os *dataframes* Q1 2019 e Q1 2020 foram combinados usando `bind_rows()`.
* **Engenharia de Features:** Criação das colunas `ride_length` (duração em minutos) e `day_of_week`.
* **Limpeza de Integridade:** Remoção de viagens com duração $\le 1$ minuto e linhas com valores nulos.

---

## 4. Analyze (Analisar) 📊

### **Resumo da Análise**

A análise agregada por tipo de usuário e dia da semana identificou os seguintes **padrões comportamentais distintos**:

#### 🎯 Insight 1: Duração da Viagem (Lazer vs. Frequência)
* A **Média da Duração da Viagem** para **Usuários Casuais** é consistentemente **3-4 vezes maior** que para Membros Anuais.
    * **Conclusão:** Casuais utilizam o serviço para **passeios longos de lazer ou turismo**, enquanto Membros utilizam para **viagens curtas e funcionais**.

#### 🎯 Insight 2: Padrões de Uso Semanal
* O **volume de viagens** dos **Membros Anuais** atinge o pico nos **dias úteis** (Segunda a Sexta).
* O **volume de viagens** dos **Usuários Casuais** atinge o pico nos **fins de semana** (Sábado e Domingo).
    * **Conclusão:** O **Casual valoriza o tempo de lazer**, enquanto o **Membro valoriza a conveniência e a frequência**.

---

## 5. Share (Compartilhar) 📣

### **Visualizações de Apoio**

As visualizações (criadas com `ggplot2` no R) comunicam os *insights* de segmentação à equipe executiva.

#### Gráfico 1: Comparação da Duração Média da Viagem
(Comprova o Insight 1: A diferença na duração do uso.)

![Gráfico de Barras comparando a Duração Média da Viagem entre Usuários Casuais (Casual) e Membros Anuais (Member). O Casual tem uma média de duração significativamente maior.](Comparação%20da%20Duração%20Média.png)

#### Gráfico 2: Volume de Viagens por Dia da Semana
(Comprova o Insight 2: Os padrões de pico opostos.)

![Gráfico de Linhas mostrando a Contagem de Viagens por Dia da Semana. A linha 'Member' atinge o pico nos dias úteis, enquanto a linha 'Casual' atinge o pico no fim de semana.](Volume%20de%20Viagens%20por%20Dia%20da%20Semana.png)

---

## 6. Act (Agir) ✅

### **Top Três Recomendações Baseadas na Análise**

As recomendações são direcionadas para o valor motivacional de cada segmento, visando a conversão de Casuais.

1.  **Estratégia: Pacote de Valor para o Lazer (Fins de Semana)**
    * **Foco:** Capitalizar o uso de **viagens longas** dos casuais.
    * **Ação:** Criar campanhas digitais que destaquem a **economia** da associação anual ao cobrir os **passeios longos**. A mensagem deve ser: "Dois longos passeios de fim de semana pagam a sua associação!"

2.  **Estratégia: Incentivo de Conversão Pós-Frequência**
    * **Foco:** Abordar Casuais que já mostram o hábito de **uso em dias úteis**.
    * **Ação:** Implementar automação de marketing que envie um desconto ou teste gratuito a Casuais que registrarem **3 ou mais viagens em dias úteis**. A mensagem deve focar na **conveniência** e no custo-benefício da frequência.

3.  **Estratégia: Benefícios de Lazer Exclusivos (Parcerias)**
    * **Foco:** Adicionar valor ao estilo de vida de **lazer/turismo** que atrai o Casual.
    * **Ação:** Firmar parcerias com atrações locais (museus, cafés) em áreas de alto volume casual para oferecer **descontos exclusivos** ao apresentar o status de Membro Anual, transformando a associação em um "passe de estilo de vida".