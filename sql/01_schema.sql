-- =====================================================================
-- 01_schema.sql — Estrutura do banco da loja virtual
-- Cada tabela é um CONJUNTO de linhas.
-- Cada linha é um elemento do PRODUTO CARTESIANO dos domínios dos atributos.
-- =====================================================================

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

-- Clientes ⊆ ID × Nome × Cidade
CREATE TABLE clientes (
    id      INTEGER      PRIMARY KEY,   -- chave primária: função id -> linha
    nome    VARCHAR(50)  NOT NULL,
    cidade  VARCHAR(50)  NOT NULL
);

-- Produtos ⊆ ID × Nome × Preço
CREATE TABLE produtos (
    id      INTEGER        PRIMARY KEY,
    nome    VARCHAR(50)    NOT NULL,
    preco   NUMERIC(10, 2) NOT NULL
);

-- Pedidos ⊆ ID × Data × ID_Cliente
-- id_cliente é chave estrangeira: f: Pedidos -> Clientes
-- NOT NULL garante que TODO pedido tem imagem;
-- REFERENCES garante que essa imagem EXISTE em Clientes.
CREATE TABLE pedidos (
    id          INTEGER  PRIMARY KEY,
    data        DATE     NOT NULL,
    id_cliente  INTEGER  NOT NULL REFERENCES clientes (id)
);

-- Itens_Pedido ⊆ Pedidos.id × Produtos.id
-- Transforma a relação muitos-para-muitos Pedidos–Produtos em duas funções:
--   g: Itens_Pedido -> Pedidos   (via id_pedido)
--   h: Itens_Pedido -> Produtos  (via id_produto)
-- A chave primária composta impede o mesmo par (pedido, produto) duas vezes,
-- como num conjunto (sem elementos repetidos).
CREATE TABLE itens_pedido (
    id_pedido   INTEGER  NOT NULL REFERENCES pedidos (id),
    id_produto  INTEGER  NOT NULL REFERENCES produtos (id),
    PRIMARY KEY (id_pedido, id_produto)
);
