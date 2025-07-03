# 📁 Projeto de Banco de Dados para Clínica Médica

Este repositório contém os **scripts de consultas SQL e PL/SQL** desenvolvidos com base no modelo relacional da clínica médica. O objetivo da entrega é demonstrar, por meio de scripts comentados e bem estruturados, a aplicação dos principais conceitos de consulta e programação no Oracle SQL, conforme checklist fornecido pela disciplina.

---

## 📚 Descrição da Entrega

Esta entrega contém:

- Script SQL com **consultas e subconsultas** e Script PL/SQL com **estruturas de controle, cursores, funções e procedimentos**
- Checklist completa com os **26 itens de SQL** e **20 itens de PL/SQL**, totalizando **46 itens obrigatórios**
---

## 🛠️ Como Executar
Ambiente Recomendado
Utilize preferencialmente o ambiente online [Oracle Live SQL](https://livesql.oracle.com/) ou uma instalação local do Oracle Database.

# Execução dos Scripts
Criação das tabelas:
Execute o script table_create.sql.

Povoamento dos dados:
Execute o script db_seed_av4.sql.

Consultas SQL e PL/SQL:
Execute os arquivos da pasta /consultas e /plsql conforme interesse ou item da checklist.

## 🗂️ Estrutura do Repositório

```bash
📁 /AV4-consultas
├── table_create.sql          # Script de criação das tabelas
├── db_seed_av4.sql           # Script de povoamento
📄 README.md                 # Este arquivo
```

## ✅ Checklist de Implementação SQL e PL/SQL

### 📦 SQL

| Nº  | Descrição                                             | Status |
|-----|--------------------------------------------------------|--------|
| 1   | `ALTER TABLE`                                          | ✅     |
| 2   | `CREATE INDEX`                                         | ✅     |
| 3   | `INSERT INTO`                                          | ✅     |
| 4   | `UPDATE`                                               | ✅     |
| 5   | `DELETE`                                               | ✅     |
| 6   | `SELECT-FROM-WHERE`                                    | ✅     |
| 7   | `BETWEEN`                                              | ✅     |
| 8   | `IN`                                                   | ✅     |
| 9   | `LIKE`                                                 | ✅     |
| 10  | `IS NULL` ou `IS NOT NULL`                             | ✅     |
| 11  | `INNER JOIN`                                           | ✅     |
| 12  | `MAX`                                                  | ✅     |
| 13  | `MIN`                                                  | ✅     |
| 14  | `AVG`                                                  | ✅     |
| 15  | `COUNT`                                                | ✅     |
| 16  | `LEFT` ou `RIGHT` ou `FULL OUTER JOIN`                 | ✅     |
| 17  | Subconsulta com operador relacional (`>`, `<`, etc)    | ✅     |
| 18  | Subconsulta com `IN`                                   | ✅     |
| 19  | Subconsulta com `ANY`                                  | ✅     |
| 20  | Subconsulta com `ALL`                                  | ✅     |
| 21  | `ORDER BY`                                             | ✅     |
| 22  | `GROUP BY`                                             | ✅     |
| 23  | `HAVING`                                               | ✅     |
| 24  | `UNION`, `INTERSECT` ou `MINUS`                        | ✅     |
| 25  | `CREATE VIEW`                                          | ✅     |
| 26  | `GRANT` / `REVOKE`                                     | ✅     |

---

### 🧠 PL/SQL

| Nº  | Descrição                                                   | Status |
|-----|--------------------------------------------------------------|--------|
| 1   | Uso de `RECORD`                                              | ✅     |
| 2   | Uso de estrutura de dados do tipo `TABLE`                    | ✅     |
| 3   | Bloco anônimo                                                | ✅     |
| 4   | `CREATE PROCEDURE`                                           | ✅     |
| 5   | `CREATE FUNCTION`                                            | ✅     |
| 6   | `%TYPE`                                                      | ✅     |
| 7   | `%ROWTYPE`                                                   | ✅     |
| 8   | `IF ELSIF`                                                   | ✅     |
| 9   | `CASE WHEN`                                                  | ✅     |
| 10  | `LOOP EXIT WHEN`                                             | ✅     |
| 11  | `WHILE LOOP`                                                 | ✅     |
| 12  | `FOR IN LOOP`                                                | ✅     |
| 13  | `SELECT … INTO`                                              | ✅     |
| 14  | `CURSOR` (`OPEN`, `FETCH`, `CLOSE`)                          | ✅     |
| 15  | `EXCEPTION WHEN`                                             | ❌     |
| 16  | Uso de parâmetros (`IN`, `OUT` ou `IN OUT`)                  | ❌     |
| 17  | `CREATE OR REPLACE PACKAGE`                                  | ❌     |
| 18  | `CREATE OR REPLACE PACKAGE BODY`                             | ❌     |
| 19  | `CREATE OR REPLACE TRIGGER` (comando)                        | ❌     |
| 20  | `CREATE OR REPLACE TRIGGER` (linha)                          | ❌     |


---
## 👥 Equipe
- Francisco Gabriel de Lima Brasil - fglb

- Guilherme Campelo - gocc

- Nicolas Bezerra - nvgb

- Esdras Albino - ehas

- Rinaldo - rsbj

- Victor Kemerer
