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
