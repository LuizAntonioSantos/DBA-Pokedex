select * from pokemon_database;

-- TABELA EXPERIENCE GROWTH

CREATE TABLE IF NOT EXISTS experience_growth (
    experience_growth_id SERIAL PRIMARY KEY,
    total_exp INT,
    exp_type VARCHAR
);

-- TABELA POKEDEX

CREATE TABLE IF NOT EXISTS pokedex (
    pokedex_num INT PRIMARY KEY,
    original_pokemon_id INT,
    pokemon_id SERIAL
);

-- TABELA POKEMON

CREATE TABLE IF NOT EXISTS pokemon (
    pokemon_id SERIAL PRIMARY KEY,
    pokedex_num INT,
    pokemon_name VARCHAR,
    classification VARCHAR,
    height NUMERIC(10,2),
    weight NUMERIC(10,2),
    base_happiness INT,
    catch_rate INT,
    game_of_origin VARCHAR,
    ev_yield INT,
    is_legendary BOOLEAN,
    alternat_form_name VARCHAR,
    exp_growth_id INT, 
    male_ratio NUMERIC(5,2),
    female_ratio NUMERIC(5,2),

    FOREIGN KEY (pokedex_num) REFERENCES pokedex(pokedex_num),
    FOREIGN KEY (exp_growth_id) REFERENCES experience_growth(experience_growth_id)
    );

-- Atualizando FK de pokedex
    
ALTER TABLE pokedex
ADD CONSTRAINT fk_pokedex_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(pokemon_id);

-- Tabela EVOLUÇÃO

CREATE TABLE IF NOT EXISTS pokemon_evolution (
    from_pokemon_id INT REFERENCES pokemon(pokemon_id),
    to_pokemon_id INT REFERENCES pokemon(pokemon_id),
    condition VARCHAR
);

-- Tabela TIPOS

CREATE TABLE IF NOT EXISTS type (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR
);

-- Ligação entre o pokemon e os tipos

CREATE TABLE IF NOT EXISTS pokemon_type (
    pokemon_id INT REFERENCES pokemon(pokemon_id),
    type_id INT REFERENCES type(type_id),
    slot INT CHECK (slot IN (1, 2)) 
);

-- Tabela EGG GROUP

CREATE TABLE IF NOT EXISTS egg_group (
    egg_group_id SERIAL PRIMARY KEY,
    name VARCHAR
);

-- Ligação entre o pokemon e a tabela Egg Group

CREATE TABLE IF NOT EXISTS pokemon_egg (
    egg_group_id INT REFERENCES egg_group(egg_group_id),
    pokemon_id INT REFERENCES pokemon(pokemon_id),
    slot INT
);

-- Tabela STATS

CREATE TABLE IF NOT EXISTS stats (
    stat_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Ligação entre o pokemon e os stats

CREATE TABLE IF NOT EXISTS pokemon_stats (
    pokemon_id INT REFERENCES pokemon(pokemon_id),
    stat_id INT REFERENCES stats(stat_id),
    base_value INT,
    effort_value INT
);

-- Tabela HABILIDADES

CREATE TABLE IF NOT EXISTS ability (
    ability_id SERIAL PRIMARY KEY,
    name VARCHAR,
    description TEXT
);

-- Ligação entre o pokemon e as habilidades

CREATE TABLE IF NOT EXISTS pokemon_ability (
    pokemon_id INT REFERENCES pokemon(pokemon_id),
    ability_id INT REFERENCES ability(ability_id)
);