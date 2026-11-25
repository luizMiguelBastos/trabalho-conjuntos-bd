-- DEMONSTRAÇÃO NO DBEAVER (Luiz): cursor dentro da consulta → Cmd+Enter

-- 1. Tema: cardinalidade, produto cartesiano (CROSS JOIN) e subconjunto
SELECT
    (SELECT COUNT(*) FROM pedidos)                     AS pedidos,
    (SELECT COUNT(*) FROM produtos)                    AS produtos,
    (SELECT COUNT(*) FROM pedidos CROSS JOIN produtos) AS produto_cartesiano,
    (SELECT COUNT(*) FROM itens_pedido)                AS itens_pedido;

-- 2. Tema: união A ∪ B (UNION) · A = clientes de São Paulo, B = clientes com pedido
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
UNION
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 3. Tema: interseção A ∩ B (INTERSECT)
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
INTERSECT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 4. Tema: diferença A − B (EXCEPT)
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
EXCEPT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 5. Tema: função × relação, chave estrangeira e muitos-para-muitos
SELECT p.id                  AS pedido,
       COUNT(DISTINCT c.id)  AS qtd_clientes,
       COUNT(i.id_produto)   AS qtd_produtos
FROM pedidos p
JOIN clientes c     ON c.id = p.id_cliente
JOIN itens_pedido i ON i.id_pedido = p.id
GROUP BY p.id
ORDER BY p.id;
