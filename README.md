# Análise de Performance de Vendas e Comportamento de Compra (Superstore)

## Visão Geral do Projeto
Este projeto analisa o histórico de transações de uma loja de departamentos para apoiar a tomada de decisões da diretoria. O foco está na identificação de padrões sazonais de faturamento, mapeamento dos produtos líderes em receita e segmentação de clientes fiéis para otimização de estratégias de marketing e retenção.

## Modelo de Dados
Os dados estruturados no banco de dados consolidam métricas de logística, perfis demográficos de clientes e categorias de produtos com as seguintes dimensões principais:
* **Métricas do Pedido:** Código identificador, datas de compra e envio, além do modo de transporte utilizado.
* **Perfil do Cliente:** Identificação única, segmento de mercado (Consumidor, Corporativo ou Home Office) e localização geográfica detalhada (Cidade, Estado e Região).
* **Catálogo de Produtos:** Código do produto, categoria principal (Móveis, Tecnologia ou Suprimentos de Escritório), subcategoria e nome comercial do item.
* **Métrica Financeira:** Valor monetário total faturado por item de linha.

## Resultados e Insights de Negócio

### 1. Produtos Líderes em Geração de Receita (Top 10)
**Contexto:** Mapeamento dos itens de maior impacto financeiro no catálogo para direcionar o foco estratégico de vendas e contratos com fornecedores.
* **Resultado Encontrado:** A análise isolou os 10 produtos que somaram o maior volume monetário em vendas. O topo do ranking é predominantemente ocupado por bens de alto valor agregado(Como o Riverside Palais Royal Lawyers Bookcase, que teve uma receita de 3083,43) das categorias de Móveis corporativos e Tecnologia, como cadeiras ergonômicas de alta qualidade e mesas de conferência de grande porte, demonstrando quais itens sustentam a maior fatia do faturamento da empresa.

```sql
SELECT 
    `Product Name`, 
    SUM(Sales) AS receita_total
FROM train
GROUP BY `Product Name`
ORDER BY receita_total DESC
LIMIT 10;
```

### 2. Tendência de Vendas Mensais no Último Ano (2018)
**Contexto:** Identificação da flutuação da receita ao longo dos meses para entender a sazonalidade e planejar a cadeia de suprimentos.
* **Resultado Encontrado:** O faturamento apresentou variações expressivas ao longo dos meses de 2018, indicando períodos específicos de pico de consumo (Como em novembro onde teve um faturamento de aprox. 909,87) e meses de baixa demanda(Como em abril onde teve um faturamento de aprox. 15,55). Os dados consolidados permitem prever necessidades de estoque e direcionar o orçamento de marketing de forma eficiente para os períodos mais lucrativos.


```sql
SELECT 
    YEAR(`Order Date`) AS ano,
    MONTH(`Order Date`) AS mes,
    SUM(Sales) AS receita_mensal
FROM train
WHERE YEAR(`Order Date`) = 2018
GROUP BY ano, mes
ORDER BY mes ASC;
```

### 3. Identificação de Clientes Fiéis e Ticket Médio por Compra
**Contexto:** Segmentação de clientes recorrentes com mais de 1 pedido distinto e cálculo do valor médio real gasto por carrinho fechado.
* **Resultado Encontrado:** A base revelou um grupo pequeno de 3 clientes recorrentes. Ao isolar o cálculo do ticket médio por transação fechada (evitando a distorção causada pela contagem de múltiplos itens em uma mesma compra) temos 812,76, a diretoria consegue visualizar de forma realista o poder de compra de cada cliente fidelizado, abrindo espaço para a criação de programas de pontos e campanhas personalizadas de retenção.


```sql
SELECT 
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS total_pedidos,
    ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS ticket_medio
FROM train
GROUP BY `Customer ID`, `Customer Name`
HAVING total_pedidos > 1
ORDER BY ticket_medio DESC;
```