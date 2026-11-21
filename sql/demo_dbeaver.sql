-- =====================================================================
-- DEMONSTRAÇÃO NO DBEAVER (Luiz) — mesma ordem dos slides
-- Coloque o cursor dentro de uma consulta e aperte Cmd+Enter.
-- Para ver as mensagens "Recusado" (passo 4): Cmd+Shift+O (saída do servidor).
-- =====================================================================


-- ===================== PASSO 1 — O BANCO (slide 2) ====================

-- 1a. Clientes (4 linhas)
SELECT * FROM clientes ORDER BY id;

-- 1b. Pedidos (6 linhas)
SELECT * FROM pedidos ORDER BY id;

-- 1c. Produtos (5 linhas)
SELECT * FROM produtos ORDER BY id;

-- 1d. Itens_Pedido (10 linhas)
SELECT * FROM itens_pedido ORDER BY id_pedido, id_produto;


-- ============ PASSO 2 — CONJUNTOS E PRODUTO CARTESIANO (slides 3 e 4) ============

-- 2a. Cardinalidade de cada conjunto → esperado: 4, 6, 5
SELECT 'clientes' AS conjunto, COUNT(*) AS cardinalidade FROM clientes
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'produtos', COUNT(*) FROM produtos;

-- 2b. Pedidos × Produtos (CROSS JOIN) → esperado: 30
SELECT COUNT(*) AS total_de_pares
FROM pedidos CROSS JOIN produtos;

-- 2c. Pares que existem em Itens_Pedido → esperado: 10
SELECT COUNT(*) AS pares_em_itens_pedido FROM itens_pedido;

-- 2d. Pares de Itens_Pedido FORA do produto cartesiano → esperado: 0 linhas
SELECT id_pedido, id_produto FROM itens_pedido
EXCEPT
SELECT p.id, q.id FROM pedidos p CROSS JOIN produtos q;


-- ============ PASSO 3 — OPERAÇÕES ENTRE CONJUNTOS (slide 5) ============
-- A = clientes de São Paulo = {1, 4}   B = clientes com pedido = {1, 2, 3}

-- 3a. A ∪ B (UNION) → esperado: 1, 2, 3, 4
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
UNION
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 3b. A ∩ B (INTERSECT) → esperado: 1 Ana
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
INTERSECT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 3c. A − B (EXCEPT) → esperado: 4 Diego
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
EXCEPT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;

-- 3d. B − A (EXCEPT) → esperado: 2 Bruno, 3 Carla
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
EXCEPT
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
ORDER BY id;


-- ============ PASSO 4 — RELAÇÕES E FUNÇÕES (slides 6, 7 e 8) ============

-- 4a. Pedidos → Clientes é FUNÇÃO → esperado: todos os pedidos com 1
SELECT p.id AS pedido, COUNT(c.id) AS qtd_clientes
FROM pedidos p
LEFT JOIN clientes c ON c.id = p.id_cliente
GROUP BY p.id
ORDER BY p.id;

-- 4b. Pedidos → Produtos NÃO é função → esperado: pedidos 1, 3, 4, 6 com 2 produtos
SELECT id_pedido AS pedido, COUNT(*) AS qtd_produtos
FROM itens_pedido
GROUP BY id_pedido
HAVING COUNT(*) > 1
ORDER BY id_pedido;

-- 4c. Itens_Pedido → Pedidos (g) e → Produtos (h) → esperado: tudo 1
SELECT i.id_pedido, i.id_produto,
       COUNT(p.id) AS qtd_pedidos_g,
       COUNT(q.id) AS qtd_produtos_h
FROM itens_pedido i
LEFT JOIN pedidos  p ON p.id = i.id_pedido
LEFT JOIN produtos q ON q.id = i.id_produto
GROUP BY i.id_pedido, i.id_produto
ORDER BY i.id_pedido, i.id_produto;

-- 4d. Chave primária recusa id repetido → saída: "Recusado: id 1 já existe"
DO $$
BEGIN
    INSERT INTO clientes (id, nome, cidade) VALUES (1, 'Repetido', 'Teste');
EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'Recusado: id 1 já existe em clientes (chave primária).';
END $$;

-- 4e. Chave estrangeira recusa cliente inexistente → saída: "Recusado: cliente 50 não existe"
DO $$
BEGIN
    INSERT INTO pedidos (id, data, id_cliente) VALUES (99, '2026-03-20', 50);
EXCEPTION WHEN foreign_key_violation THEN
    RAISE NOTICE 'Recusado: cliente 50 não existe (chave estrangeira).';
END $$;

-- 4f. NOT NULL recusa pedido sem cliente → saída: "Recusado: pedido sem cliente"
DO $$
BEGIN
    INSERT INTO pedidos (id, data, id_cliente) VALUES (99, '2026-03-20', NULL);
EXCEPTION WHEN not_null_violation THEN
    RAISE NOTICE 'Recusado: pedido sem cliente (NOT NULL).';
END $$;
