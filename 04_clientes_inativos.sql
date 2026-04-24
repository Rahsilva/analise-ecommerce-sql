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
