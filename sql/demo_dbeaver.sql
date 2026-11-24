-- =====================================================================
-- DEMONSTRAÇÃO NO DBEAVER (Luiz) — 5 consultas, na ordem dos slides
-- =====================================================================
-- COMO RODAR: cursor dentro da consulta → Cmd+Enter (Ctrl+Enter no Windows).
--             Rode UMA por vez. O resultado aparece na grade embaixo.
--
-- LEGENDA DO ROTEIRO
--   [ANTES]     o que falar antes de apertar Cmd+Enter
--   [RODAR]     apertar Cmd+Enter
--   [RESULTADO] o que falar apontando para a grade
--   [PONTE]     frase para passar para a próxima consulta
--
-- Conjuntos usados nas consultas 2, 3 e 4:
--   A = clientes de São Paulo       = {1 Ana, 4 Diego}
--   B = clientes que fizeram pedido = {1 Ana, 2 Bruno, 3 Carla}
-- =====================================================================


-- =====================================================================
-- ABERTURA DA DEMONSTRAÇÃO (slide 9 → DBeaver)
-- =====================================================================
-- [NO SLIDE 9] "Agora eu vou mostrar no banco de dados tudo o que o Matheus e o
--   Pedro explicaram. A ideia é provar que a conta que a gente fez à mão é
--   exatamente o que o banco devolve."
--
-- [TROCAR PARA O DBEAVER e abrir o diagrama ER da conexão loja]
-- "Esse é o nosso banco no PostgreSQL. Cada caixa é uma tabela, e cada tabela é
--   um conjunto: cada linha é um elemento. As setas são as chaves estrangeiras:
--   o pedido aponta para o cliente, e a Itens_Pedido aponta para o pedido e para
--   o produto. Vou rodar cinco consultas, na mesma ordem dos slides."
-- =====================================================================


-- =====================================================================
-- CONSULTA 1 — PRODUTO CARTESIANO (slides 3 e 4 · Matheus)
-- =====================================================================
-- CONCEITO
--   CARDINALIDADE |A| = quantos elementos o conjunto tem.
--   PRODUTO CARTESIANO A × B = TODAS as combinações (a, b), pegando um
--   elemento de cada conjunto. |A × B| = |A| · |B|.
--   SUBCONJUNTO: a Itens_Pedido só guarda os pares que aconteceram,
--   então ela é um pedaço (⊆) do produto cartesiano.
--
-- O QUE CADA LINHA FAZ
--   SELECT ( ... ) AS nome   → cada parêntese é uma contagem separada,
--                              e o AS dá o nome da coluna no resultado
--   COUNT(*) FROM pedidos    → conta as linhas de pedidos = |Pedidos| = 6
--   COUNT(*) FROM produtos   → conta as linhas de produtos = |Produtos| = 5
--   pedidos CROSS JOIN produtos
--                            → junta CADA pedido com CADA produto,
--                              ou seja, monta o produto cartesiano (30 pares)
--   COUNT(*) FROM itens_pedido
--                            → conta os pares que existem de verdade = 10
--
-- RESULTADO ESPERADO
--   pedidos | produtos | produto_cartesiano | itens_pedido
--      6    |    5     |         30         |      10
--
-- ROTEIRO
-- [ANTES] "A primeira consulta é o produto cartesiano, que o Matheus mostrou
--   nos slides 3 e 4. Produto cartesiano é juntar cada elemento de um conjunto
--   com cada elemento do outro: todas as combinações possíveis."
-- [RODAR]
-- [RESULTADO] "Temos 6 pedidos e 5 produtos: essas são as cardinalidades.
--   O CROSS JOIN junta cada pedido com cada produto e dá 30, que é 6 vezes 5,
--   exatamente a fórmula do produto cartesiano. Mas a Itens_Pedido tem só 10:
--   das 30 combinações possíveis, só 10 foram compradas de verdade. Então a
--   tabela é um subconjunto do produto cartesiano."
-- [PONTE] "Agora as operações entre conjuntos, com os conjuntos A e B do slide 5."
--
-- SE PERGUNTAREM "e o JOIN normal?": "O CROSS JOIN é o produto cartesiano
--   inteiro. O JOIN normal filtra esse produto e fica só com os pares em que
--   a chave bate."
SELECT
    (SELECT COUNT(*) FROM pedidos)                     AS pedidos,
    (SELECT COUNT(*) FROM produtos)                    AS produtos,
    (SELECT COUNT(*) FROM pedidos CROSS JOIN produtos) AS produto_cartesiano,
    (SELECT COUNT(*) FROM itens_pedido)                AS itens_pedido;


-- =====================================================================
-- CONSULTA 2 — UNIÃO  A ∪ B (slide 5 · Matheus)
-- =====================================================================
-- CONCEITO
--   UNIÃO = quem está em A OU em B (ou nos dois). Junta tudo, sem repetir.
--   A ∪ B = {1, 4} ∪ {1, 2, 3} = {1, 2, 3, 4}
--
-- O QUE CADA LINHA FAZ
--   1º SELECT ... WHERE cidade = 'São Paulo'
--                            → monta o conjunto A (WHERE filtra as linhas)
--   2º SELECT ... JOIN pedidos p ON p.id_cliente = c.id
--                            → monta o conjunto B: o JOIN liga cada cliente
--                              aos pedidos dele, então só sobra quem tem pedido
--   UNION                    → junta os dois resultados e tira os repetidos
--                              (a Ana aparece 3 vezes em B e 1 vez em A,
--                              mas sai uma vez só)
--   ORDER BY id              → só ordena para ficar fácil de ler
--
-- RESULTADO ESPERADO
--   1 Ana · 2 Bruno · 3 Carla · 4 Diego
--
-- ROTEIRO
-- [ANTES] "O conjunto A são os clientes de São Paulo: Ana e Diego. O conjunto B
--   são os clientes que fizeram pedido: Ana, Bruno e Carla. Nessa consulta,
--   o primeiro SELECT monta o A, o segundo monta o B, e o UNION faz a união."
-- [RODAR]
-- [RESULTADO] "Deu 1, 2, 3 e 4, igual à conta à mão. Repara que a Ana está nos
--   dois conjuntos, mas aparece uma vez só. Isso porque conjunto não tem
--   elemento repetido, e o UNION segue essa regra."
-- [PONTE] "Agora, com os mesmos dois conjuntos, a interseção."
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
UNION
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;


-- =====================================================================
-- CONSULTA 3 — INTERSEÇÃO  A ∩ B (slide 5 · Matheus)
-- =====================================================================
-- CONCEITO
--   INTERSEÇÃO = quem está em A E em B ao mesmo tempo. O que os dois têm em comum.
--   A ∩ B = {1, 4} ∩ {1, 2, 3} = {1}
--
-- O QUE CADA LINHA FAZ
--   os mesmos dois SELECTs da consulta 2 (A e B)
--   INTERSECT                → devolve só as linhas que aparecem nos DOIS
--
-- RESULTADO ESPERADO
--   1 Ana
--
-- ROTEIRO
-- [ANTES] "São os mesmos dois conjuntos. Só troquei o UNION pelo INTERSECT,
--   que é a interseção: só o que está nos dois ao mesmo tempo."
-- [RODAR]
-- [RESULTADO] "Sobrou só a Ana. Ela é a única que é de São Paulo E fez pedido.
--   O Diego é de São Paulo mas não comprou, e o Bruno e a Carla compraram mas
--   não são de São Paulo."
-- [PONTE] "E agora a diferença, que é a única em que a ordem importa."
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
INTERSECT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;


-- =====================================================================
-- CONSULTA 4 — DIFERENÇA  A − B (slide 5 · Matheus)
-- =====================================================================
-- CONCEITO
--   DIFERENÇA = quem está em A MAS NÃO está em B. Tira de A o que está em B.
--   A − B = {1, 4} − {1, 2, 3} = {4}
--   NÃO é comutativa: B − A = {2, 3}, então A − B ≠ B − A.
--
-- O QUE CADA LINHA FAZ
--   os mesmos dois SELECTs (A primeiro, B depois)
--   EXCEPT                   → pega o 1º resultado e tira tudo que está no 2º
--
-- RESULTADO ESPERADO
--   4 Diego
--
-- ROTEIRO
-- [ANTES] "Agora o EXCEPT, que é a diferença: pego o conjunto A e tiro dele
--   tudo o que também está no B."
-- [RODAR]
-- [RESULTADO] "Sobrou o Diego: ele é de São Paulo, mas nunca fez pedido. E aqui
--   a ordem importa. Se eu fizesse B menos A, sobrariam o Bruno e a Carla, que
--   compraram mas não são de São Paulo. Na matemática também é assim: A menos B
--   é diferente de B menos A."
-- [PONTE] "Com isso fecha a parte de conjuntos. Agora a parte do Pedro:
--   relações e funções."
SELECT id, nome FROM clientes WHERE cidade = 'São Paulo'
EXCEPT
SELECT c.id, c.nome FROM clientes c JOIN pedidos p ON p.id_cliente = c.id
ORDER BY id;


-- =====================================================================
-- CONSULTA 5 — FUNÇÃO × RELAÇÃO (slides 6, 7 e 8 · Pedro)
-- =====================================================================
-- CONCEITO
--   RELAÇÃO = qualquer conjunto de pares (um subconjunto de A × B).
--   FUNÇÃO  = relação em que CADA elemento da origem tem EXATAMENTE 1 imagem
--             (nem 0, nem 2).
--   Pedidos → Clientes É FUNÇÃO: cada pedido tem 1 cliente. Quem garante
--     isso é a chave estrangeira id_cliente (REFERENCES = o cliente precisa
--     existir; NOT NULL = o pedido não pode ficar sem cliente).
--   Pedidos → Produtos NÃO É FUNÇÃO: alguns pedidos têm 2 produtos.
--     É uma relação MUITOS-PARA-MUITOS. Por isso existe a Itens_Pedido:
--     cada item aponta para 1 pedido e 1 produto (duas funções).
--
-- O QUE CADA LINHA FAZ
--   FROM pedidos p           → a origem: os pedidos
--   JOIN clientes c ON c.id = p.id_cliente
--                            → segue a chave estrangeira até o cliente
--   JOIN itens_pedido i ON i.id_pedido = p.id
--                            → pega os itens (produtos) de cada pedido
--   GROUP BY p.id            → agrupa tudo por pedido (uma linha por pedido)
--   COUNT(DISTINCT c.id)     → conta quantos clientes diferentes o pedido tem
--   COUNT(i.id_produto)      → conta quantos produtos o pedido tem
--
-- RESULTADO ESPERADO
--   pedido | qtd_clientes | qtd_produtos
--     1    |      1       |      2
--     2    |      1       |      1
--     3    |      1       |      2
--     4    |      1       |      2
--     5    |      1       |      1
--     6    |      1       |      2
--
-- ROTEIRO
-- [ANTES] "O Pedro explicou que função é quando cada elemento tem exatamente uma
--   imagem. Essa consulta conta, para cada pedido, quantos clientes e quantos
--   produtos ele tem."
-- [RODAR]
-- [RESULTADO — coluna qtd_clientes] "Cliente: 1 para todos os pedidos. Cada
--   pedido tem exatamente uma imagem, então Pedidos → Clientes é função. E quem
--   garante isso é a chave estrangeira: o banco não deixa criar pedido para um
--   cliente que não existe, nem pedido sem cliente."
-- [RESULTADO — coluna qtd_produtos] "Produto: os pedidos 1, 3, 4 e 6 têm dois.
--   Um elemento com duas imagens quebra a regra, então Pedidos → Produtos não é
--   função, é uma relação muitos-para-muitos. Por isso existe a Itens_Pedido:
--   cada linha dela aponta para um pedido e um produto, e a relação vira duas
--   funções."
-- [PONTE] ver ENCERRAMENTO abaixo.
--
-- SE PERGUNTAREM "o Diego não tem pedido, isso quebra a função?": "Não. A regra
--   vale para quem sai da seta, que são os pedidos. Todo pedido tem um cliente,
--   mas o cliente não é obrigado a ter pedido."
SELECT p.id                  AS pedido,
       COUNT(DISTINCT c.id)  AS qtd_clientes,
       COUNT(i.id_produto)   AS qtd_produtos
FROM pedidos p
JOIN clientes c     ON c.id = p.id_cliente
JOIN itens_pedido i ON i.id_pedido = p.id
GROUP BY p.id
ORDER BY p.id;


-- =====================================================================
-- ENCERRAMENTO DA DEMONSTRAÇÃO (DBeaver → slide 9 → slide 10)
-- =====================================================================
-- [VOLTAR PARA O SLIDE 9, apontando para a tabela À mão × Banco]
-- "Tudo o que o banco devolveu bate com a conta que a gente fez à mão:
--   30 pares no produto cartesiano, 10 na Itens_Pedido, a união, a interseção,
--   a diferença e a função Pedidos → Clientes."
-- [PASSAR PARA O SLIDE 10 — conclusão]
-- =====================================================================
