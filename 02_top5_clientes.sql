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
