-- =====================================================================
-- 02_dados.sql — Dados do exemplo: 4 clientes, 6 pedidos, 5 produtos
-- =====================================================================

INSERT INTO clientes (id, nome, cidade) VALUES
    (1, 'Ana',   'São Paulo'),
    (2, 'Bruno', 'Campinas'),
    (3, 'Carla', 'Santos'),
    (4, 'Diego', 'São Paulo');

INSERT INTO produtos (id, nome, preco) VALUES
    (1, 'Caderno',      25.90),
    (2, 'Caneta',        4.50),
    (3, 'Mochila',     149.90),
    (4, 'Calculadora',  89.00),
    (5, 'Estojo',       19.90);

INSERT INTO pedidos (id, data, id_cliente) VALUES
    (1, '2026-03-02', 1),
    (2, '2026-03-05', 2),
    (3, '2026-03-07', 1),
    (4, '2026-03-10', 3),
    (5, '2026-03-12', 2),
    (6, '2026-03-15', 1);

INSERT INTO itens_pedido (id_pedido, id_produto) VALUES
    (1, 1), (1, 2),
    (2, 3),
    (3, 2), (3, 4),
    (4, 1), (4, 5),
    (5, 2),
    (6, 3), (6, 5);
