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
