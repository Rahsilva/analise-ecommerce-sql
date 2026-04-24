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
