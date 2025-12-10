# Trabalho de Banco de Dados (PostgreSQL) – Dataset Pokémon

## Sobre o Projeto

Este trabalho foi desenvolvido para a disciplina de Banco de Dados, sob orientação do professor Diego Cardoso Borda Castro.

Este projeto consiste na utilização do dataset de Pokémon para criação de um banco de dados em PostgreSQL, realizando desde a carga inicial dos dados até a normalização e migração para um esquema dimensional.

O objetivo é demonstrar conhecimento em modelagem relacional, normalização, criação de esquema próprio e construção de scripts de ETL/migração.

---

## Estrutura Inicial

Antes de iniciar qualquer teste ou execução de consultas, é necessário preparar o ambiente conforme os passos abaixo.

### 1 - Criar o schema

```sql
CREATE SCHEMA pokemon_trab;
```

### 2 - Importar o CSV

Importe o CSV original do **Pokémon Database** para dentro do PostgreSQL.

* Nome da tabela a ser criada: **pokemon_original**
* Schema destino: **pokemon_trab**

> Certifique-se de que o CSV esteja no formato correto conforme o dataset do Pokémon Database.

---

## Scripts Necessários

Após criar o schema e importar o CSV, execute os scripts **nesta ordem obrigatória**:

### 1 - como_comecar.sql

Contém a preparação inicial das tabelas, ajustes de tipos, padronização de dados e demais estruturas necessárias para iniciar o projeto.

### 2 - banco_normalizado.sql

Responsável por transformar os dados originais em um banco **normalizado**, seguindo as regras de normalização aplicadas para o trabalho.

### 3 - script_migracao.sql

Executa a migração dos dados do banco normalizado para o ambiente final (por exemplo: um esquema dimensional, DW em estrela, tabelas fato/dimensões, etc.).

---

## Depois de Executar os Scripts

Com o ambiente pronto, você poderá:

* Rodar consultas analíticas
* Testar o modelo normalizado
* Explorar o DW
* Ver o ETL

Esses scripts garantem que toda a base esteja coerente e apta para testes e análises.

---


