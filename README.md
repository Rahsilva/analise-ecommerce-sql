# 📊 Análise de E-commerce com SQL

Projeto de análise de dados de uma empresa de e-commerce fictícia, desenvolvido como parte da minha jornada na área de dados.

O objetivo foi responder **6 perguntas de negócio reais** usando SQL puro — desde agregações básicas até CTEs encadeadas e Window Functions.

---

## 🗂️ Estrutura do Banco de Dados

O banco é composto por 3 tabelas relacionadas:

```
clientes         pedidos              produtos
-----------      ----------------     -----------
id_cliente (PK)  id_pedido (PK)       id_produto (PK)
nome             id_cliente (FK)      nome_produto
email            id_produto (FK)      categoria
cidade           valor                preco
data_cadastro    status
                 data_pedido
```

**Status possíveis dos pedidos:** `entregue`, `cancelado`, `em_transito`, `pendente`

---

## 📁 Queries do Projeto

| Arquivo | Pergunta de negócio | Conceitos usados |
|---|---|---|
| `01_receita_mensal.sql` | Qual a receita e volume de pedidos por mês? | EXTRACT, GROUP BY, AVG |
| `02_top5_clientes.sql` | Quais são os 5 clientes que mais geraram receita? | JOIN, RANK(), Window Function |
| `03_taxa_cancelamento.sql` | Qual a taxa de cancelamento por categoria? | 3 JOINs, COUNT com CASE WHEN, ROUND |
| `04_clientes_inativos.sql` | Quais clientes não compraram nos últimos 90 dias? | LEFT JOIN, MAX, HAVING, INTERVAL |
| `05_ranking_cidades.sql` | Quais cidades têm o maior ticket médio? | Subquery, AVG, RANK(), Window Function |
| `06_relatorio_executivo.sql` | Relatório completo de performance por cliente | 3 CTEs encadeadas, UPPER, COALESCE, CASE WHEN |

---

## 🔍 Análises e Insights

### 1. Receita Mensal
```sql
SELECT
  EXTRACT(YEAR  FROM data_pedido) AS ano,
  EXTRACT(MONTH FROM data_pedido) AS mes,
  COUNT(*)      AS qtd_pedidos,
  SUM(valor)    AS receita,
  AVG(valor)    AS ticket_medio
FROM pedidos
WHERE status = 'entregue'
GROUP BY ano, mes
ORDER BY ano, mes;
```
> **Insight:** Permite identificar sazonalidade nas vendas e meses de pico para planejamento de estoque e marketing.

---

### 2. Top 5 Clientes por Receita
```sql
SELECT * FROM (
  SELECT
    c.nome,
    c.cidade,
    COUNT(*)       AS qtd_pedidos,
    SUM(p.valor)   AS receita,
    RANK() OVER (ORDER BY SUM(p.valor) DESC) AS posicao
  FROM clientes c
  JOIN pedidos p ON c.id_cliente = p.id_cliente
  WHERE p.status = 'entregue'
  GROUP BY c.nome, c.cidade
) t
WHERE posicao <= 5;
```
> **Insight:** Os top 5 clientes geralmente representam 20-30% da receita total — base para programa de fidelização VIP.

---

### 3. Taxa de Cancelamento por Categoria
```sql
SELECT
  pr.categoria,
  COUNT(*) AS total_pedidos,
  COUNT(CASE WHEN pe.status = 'cancelado' THEN 1 END) AS cancelados,
  ROUND(
    COUNT(CASE WHEN pe.status = 'cancelado' THEN 1 END) * 100.0 / COUNT(*), 2
  ) AS taxa_cancelamento
FROM pedidos pe
JOIN produtos pr ON pe.id_produto = pr.id_produto
GROUP BY pr.categoria
ORDER BY taxa_cancelamento DESC;
```
> **Insight:** Categorias com taxa de cancelamento acima de 15% merecem investigação de causa raiz (logística, qualidade, prazo de entrega).

---

### 4. Clientes Inativos (últimos 90 dias)
```sql
SELECT
  c.nome,
  COALESCE(c.email, 'sem email') AS email,
  c.cidade,
  MAX(p.data_pedido) AS ultimo_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.nome, c.email, c.cidade
HAVING MAX(p.data_pedido) < CURRENT_DATE - INTERVAL '90 days'
ORDER BY ultimo_pedido ASC;
```
> **Insight:** Lista pronta para campanha de e-mail de reativação com cupom de desconto.

---

### 5. Ranking de Cidades por Ticket Médio
```sql
SELECT cidade, ticket_cidade,
  AVG(ticket_cidade) OVER () AS media_geral,
  RANK() OVER (ORDER BY ticket_cidade DESC) AS posicao
FROM (
  SELECT c.cidade, AVG(p.valor) AS ticket_cidade
  FROM clientes c
  JOIN pedidos p ON c.id_cliente = p.id_cliente
  WHERE p.status = 'entregue'
  GROUP BY c.cidade
) sub
ORDER BY posicao;
```
> **Insight:** Cidades com ticket acima da média geral são candidatas para expansão e campanhas de produtos premium.

---

### 6. Relatório Executivo Completo (3 CTEs)
```sql
WITH pedidos_entregues AS (
  SELECT * FROM pedidos WHERE status = 'entregue'
),
resumo_cliente AS (
  SELECT
    UPPER(c.nome)                          AS nome,
    COALESCE(c.cidade, 'Não informado')    AS cidade,
    COUNT(*)                               AS qtd_pedidos,
    SUM(pe.valor)                          AS receita_total,
    AVG(pe.valor)                          AS ticket_medio
  FROM clientes c
  JOIN pedidos_entregues pe ON c.id_cliente = pe.id_cliente
  GROUP BY c.nome, c.cidade
),
classificado AS (
  SELECT *,
    CASE
      WHEN receita_total >= 3000 THEN 'VIP'
      WHEN receita_total >= 1000 THEN 'Premium'
      ELSE 'Regular'
    END AS perfil
  FROM resumo_cliente
)
SELECT * FROM classificado
ORDER BY receita_total DESC;
```
> **Insight:** Relatório executivo completo com segmentação automática de clientes por valor gerado.

---

## 🛠️ Tecnologias e Conceitos

- **SQL** (compatível com PostgreSQL e BigQuery)
- SELECT, WHERE, GROUP BY, ORDER BY, LIMIT
- JOIN (INNER, LEFT), subqueries
- Funções de agregação: COUNT, SUM, AVG, MAX, MIN
- Funções de data: EXTRACT, CURRENT_DATE, INTERVAL
- Funções de texto: UPPER, COALESCE
- CASE WHEN para segmentação
- Window Functions: RANK(), ROW_NUMBER(), AVG() OVER()
- CTEs com WITH encadeado
- Boas práticas de performance e otimização

---

## 👤 Autor

Feito por Rayssa Silva Coelho como parte da jornada como analista de dados.

🔗 [LinkedIn](https://www.linkedin.com/in/rayssa-coelho2005/) | 📧 rayssa.silva.coelho2005@gmail.com
