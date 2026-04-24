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
