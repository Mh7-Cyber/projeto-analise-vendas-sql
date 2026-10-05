-- =========================================================================
-- PROJETO DE ANÁLISE DE DADOS - DATASET SUPERSTORE (KAGGLE)
-- Autor: Mh7-Cyber
-- Descrição: Consultas SQL desenvolvidas para extrair insights de vendas.
-- =========================================================================

-- 1. OS 10 PRODUTOS MAIS RENTÁVEIS
-- Identifica os campeões de faturamento da loja para foco estratégico.
SELECT 
    `Product Name` AS nome_produto, 
    SUM(Sales) AS receita_total
FROM vendas
GROUP BY nome_produto
ORDER BY receita_total DESC
LIMIT 10;

-- 2. TENDÊNCIA DE VENDAS MENSAIS NO ÚLTIMO ANO DO BANCO (2018)
-- Mostra o faturamento mês a mês para identificar padrões de sazonalidade.
SELECT 
    YEAR(`Order Date`) AS ano,
    MONTH(`Order Date`) AS mes,
    SUM(Sales) AS receita_mensal
FROM vendas
WHERE YEAR(`Order Date`) = 2018
GROUP BY ano, mes
ORDER BY mes ASC;

-- 3. ANÁLISE DE CLIENTES FIÉIS E TICKET MÉDIO (POR COMPRA)
-- Filtra clientes com mais de 1 compra distinta e calcula o gasto médio real por carrinho.
SELECT 
    `Customer ID` AS cliente_id,
    `Customer Name` AS nome_cliente,
    COUNT(DISTINCT `Order ID`) AS total_pedidos,
    ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS ticket_medio
FROM vendas
GROUP BY cliente_id, nome_cliente
HAVING total_pedidos > 1
ORDER BY ticket_medio DESC;
