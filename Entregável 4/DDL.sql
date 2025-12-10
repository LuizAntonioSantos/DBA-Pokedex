CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE dw.dim_pokemon (
    pokemon_sk        SERIAL PRIMARY KEY,   
    pokemon_id        INT,                  
    pokemon_name      VARCHAR(150),
    classification    VARCHAR(150),
    height            DECIMAL(10,2),
    weight            DECIMAL(10,2),
    base_happiness    INT,
    capture_rate      INT,
    is_legendary      VARCHAR(50),
    male_ratio        DECIMAL(5,2),
    female_ratio      DECIMAL(5,2),
);

CREATE TABLE dw.dim_type (
    type_sk   SERIAL PRIMARY KEY,
    type_id   INT,
    name      VARCHAR(50),
);


CREATE TABLE dw.dim_ability (
    ability_sk   SERIAL PRIMARY KEY,
    ability_id   INT,
    name         VARCHAR(100),
    description  TEXT,
);

CREATE TABLE dw.dim_egg_group (
    egg_group_sk  SERIAL PRIMARY KEY,
    egg_group_id  INT,
    name          VARCHAR(100),
);

CREATE TABLE dw.dim_stat (
    stat_sk   SERIAL PRIMARY KEY,
    stat_id   INT,
    name      VARCHAR(50),
);


CREATE TABLE dw.fato_pokemon (
    fato_pokemon_sk   SERIAL PRIMARY KEY,

    pokemon_sk        INT REFERENCES dw.dim_pokemon(pokemon_sk),
    type_sk           INT REFERENCES dw.dim_tipo(type_sk),
    ability_sk        INT REFERENCES dw.dim_habilidade(ability_sk),
    egg_group_sk      INT REFERENCES dw.dim_egg_group(egg_group_sk),
    stat_sk           INT REFERENCES dw.dim_stat(stat_sk),

    total_stats       INT,
    avg_stat          DECIMAL(10,2),
    qtd_abilities     INT,
    qtd_types         INT,
);