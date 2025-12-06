select * from pokemon_original;

-- TABELA EXPERIENCE GROWTH

CREATE TABLE IF NOT EXISTS experience_growth (
    experience_growth_id SERIAL PRIMARY KEY,
    total_exp INT NOT NULL,
    exp_type VARCHAR(50) NOT NULL
);

-- TABELA POKEDEX

CREATE TABLE IF NOT EXISTS pokedex (
    pokedex_num INT PRIMARY KEY,
    original_pokemon_id INT,
    UNIQUE (original_pokemon_id)
);


-- TABELA POKEMON
CREATE TABLE IF NOT EXISTS pokemon (
    pokemon_id SERIAL PRIMARY KEY,
    pokedex_num INT NOT NULL,
    pokemon_name VARCHAR(150) NOT NULL,
    classification VARCHAR(150),
    height NUMERIC(10,2),
    weight NUMERIC(10,2),
    base_happiness INT,
    catch_rate INT,
    game_of_origin VARCHAR(100),
    ev_yield INT,
    is_legendary VARCHAR(100) DEFAULT 'No',
    alternat_form_name VARCHAR(100),
    exp_growth_id INT,
    male_ratio NUMERIC(5,2) CHECK (male_ratio >= 0 AND male_ratio <= 100),
    female_ratio NUMERIC(5,2) CHECK (female_ratio >= 0 AND female_ratio <= 100),
    
    FOREIGN KEY (pokedex_num) REFERENCES pokedex(pokedex_num),
    FOREIGN KEY (exp_growth_id) REFERENCES experience_growth(experience_growth_id)
);

-- Indice para otimizar consultas por pokedex_num

CREATE INDEX idx_pokemon_pokedex_num ON pokemon(pokedex_num);

-- Tabela EVOLUÇÃO

CREATE TABLE IF NOT EXISTS pokemon_evolution (
    from_pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    to_pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    condition TEXT NOT NULL,
    PRIMARY KEY (from_pokemon_id, to_pokemon_id)
);

-- Tabela TIPOS

CREATE TABLE IF NOT EXISTS type (
    type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Ligação entre o pokemon e os tipos

CREATE TABLE IF NOT EXISTS pokemon_type (
    pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    type_id INT NOT NULL REFERENCES type(type_id),
    slot INT NOT NULL CHECK (slot IN (1,2)),
    PRIMARY KEY (pokemon_id, type_id)
);

-- Indice para otimizar consultas por pokemon_id e type_id
CREATE INDEX idx_pokemon_type_type_id ON pokemon_type(type_id);


-- Tabela EGG GROUP

CREATE TABLE IF NOT EXISTS egg_group (
    egg_group_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Ligação entre o pokemon e a tabela Egg Group

CREATE TABLE IF NOT EXISTS pokemon_egg (
    egg_group_id INT NOT NULL REFERENCES egg_group(egg_group_id),
    pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    slot INT CHECK (slot IN (1, 2)),
    PRIMARY KEY (egg_group_id, pokemon_id)
);

-- Tabela STATS

CREATE TABLE stats (
    stat_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Ligação entre o pokemon e os stats

CREATE TABLE pokemon_stats (
    pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    stat_id INT NOT NULL REFERENCES stats(stat_id),
    base_value INT NOT NULL,
    effort_value INT NOT NULL,
    PRIMARY KEY (pokemon_id, stat_id)
);


-- Tabela HABILIDADES

CREATE TABLE ability (
    ability_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Ligação entre o pokemon e as habilidades

CREATE TABLE pokemon_ability (
    pokemon_id INT NOT NULL REFERENCES pokemon(pokemon_id),
    ability_id INT NOT NULL REFERENCES ability(ability_id),
    PRIMARY KEY (pokemon_id, ability_id)
);