# Do Produto Cartesiano à Chave Estrangeira: a Matemática por trás das Tabelas

Trabalho de **Matemática Computacional Aplicada** sobre **conjuntos, relações e funções** aplicados à modelagem de bancos de dados.

Com o banco real de uma loja virtual em PostgreSQL, o trabalho mostra que:

- cada tabela é um **conjunto** e um subconjunto do **produto cartesiano** dos domínios dos seus atributos;
- a ligação entre tabelas é uma **relação**;
- a chave primária e a chave estrangeira funcionam como **funções**;
- `UNION`, `INTERSECT` e `EXCEPT` são a **união**, a **interseção** e a **diferença** de conjuntos.

Integrantes: Luiz, Pedro e Matheus.

**Slides da apresentação:** https://claude.ai/artifact/JqBC2E5NpQcPMdyCedT1tr

## Conteúdo

| Arquivo | Para que serve |
|---|---|
| `sql/01_schema.sql` | Cria as 4 tabelas: `clientes`, `pedidos`, `produtos` e `itens_pedido` |
| `sql/02_dados.sql` | Insere 4 clientes, 6 pedidos, 5 produtos e 10 itens de pedido |
| `sql/demo_dbeaver.sql` | Consultas da demonstração, na ordem dos slides, com o resultado esperado em cada comentário |
| `pdfs/estudo_*.pdf` | Plano de estudo e slides de cada integrante |
| `pdfs/slides_apresentacao.pdf` | Os 10 slides da apresentação em PDF |

## Como montar o banco

Com o PostgreSQL instalado, crie o banco e rode os dois scripts:

```bash
createdb -h localhost -U postgres loja
```

```bash
psql -h localhost -U postgres -d loja -f sql/01_schema.sql
```

```bash
psql -h localhost -U postgres -d loja -f sql/02_dados.sql
```

## Como rodar a demonstração (DBeaver)

1. Crie uma conexão PostgreSQL com o banco `loja` (`localhost:5432`, usuário `postgres`).
2. Clique com o botão direito na conexão → **Editor SQL → Novo script SQL**.
3. Cole o conteúdo de `sql/demo_dbeaver.sql`.
4. Coloque o cursor dentro de uma consulta e aperte **Cmd+Enter** (ou **Ctrl+Enter**), uma por vez.
5. Para ver as mensagens "Recusado" do passo 4, ative a saída do servidor (**Cmd+Shift+O** ou **Ctrl+Shift+O**).

## Resultados esperados

| Conceito | À mão | Banco |
|---|---|---|
| \|Pedidos × Produtos\| | 6 × 5 = 30 | 30 |
| Itens_Pedido ⊆ Pedidos × Produtos | 10 pares | 10, nenhum fora |
| A = clientes de São Paulo | {1, 4} | Ana, Diego |
| B = clientes com pedido | {1, 2, 3} | Ana, Bruno, Carla |
| A ∪ B | {1, 2, 3, 4} | `UNION`: 1, 2, 3, 4 |
| A ∩ B | {1} | `INTERSECT`: 1 |
| A − B | {4} | `EXCEPT`: 4 |
| B − A | {2, 3} | `EXCEPT`: 2, 3 |
| Pedidos → Clientes | cada pedido tem 1 cliente (é função) | todos com 1 |
| Pedidos → Produtos | pedidos 1, 3, 4 e 6 têm 2 produtos (não é função) | 1, 3, 4, 6 |

## Referências

- CODD, E. F. A relational model of data for large shared data banks. *Communications of the ACM*, 1970.
- SILBERSCHATZ, A.; KORTH, H. F.; SUDARSHAN, S. *Sistema de Banco de Dados*. 6. ed. Elsevier, 2012.
