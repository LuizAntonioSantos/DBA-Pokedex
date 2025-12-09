--TABELA EXPERIENCE_GROWTH
INSERT INTO experience_growth (total_exp, exp_type)
SELECT DISTINCT 
    experience_growth_total,
    experience_growth
FROM pokemon_original
WHERE experience_growth_total IS NOT NULL;

--teste
select eg.exp_type from experience_growth eg;


--TABELA POKEDEX
INSERT INTO pokedex (pokedex_num, original_pokemon_id)
SELECT DISTINCT 
    pokedex_number,
    NULLIF(original_pokemon_id, 'NULL')::INT
FROM pokemon_original
WHERE pokedex_number IS NOT NULL
ORDER BY pokedex_number ASC
ON CONFLICT (pokedex_num) DO NOTHING;

--teste
select p.pokedex_num from pokedex p;

--TABELA POKEMON
INSERT INTO pokemon (
	pokemon_id,
    pokedex_num, 
    pokemon_name, 
    classification, 
    height, 
    weight,
    base_happiness, 
    catch_rate, 
    game_of_origin, 
    ev_yield, 
    is_legendary,
    alternat_form_name,
    exp_growth_id,
    male_ratio,
    female_ratio
)
SELECT 
	op.pokemon_id,
    op.pokedex_number,
    op.pokemon_name,
    op.classification,
    op.pokemon_height,
    op.pokemon_weight,
    op.base_happiness,
    op.catch_rate,
    op.games_of_origin,
    op.ev_yield_total,
    op.is_legendary,
    op.alternate_form_name,
    e.experience_growth_id,
    op.male_ratio,
    op.female_ratio
FROM pokemon_original op
LEFT JOIN experience_growth e 
       ON e.total_exp = op.experience_growth_total
       ON CONFLICT DO NOTHING;

--teste
select *from pokemon p;

--TABELA TYPE
INSERT INTO type (name)
SELECT DISTINCT primary_type 
FROM pokemon_original 
WHERE primary_type IS NOT NULL;

INSERT INTO type (name)
SELECT DISTINCT secondary_type 
FROM pokemon_original 
WHERE secondary_type IS NOT NULL
AND secondary_type NOT IN (SELECT name FROM type);

--teste
select *from type t;

--TABELA POKEMON_TYPE (DE RELACIONAMENTO)
--tipo primário
INSERT INTO pokemon_type (pokemon_id, type_id, slot)
SELECT DISTINCT 
       p.pokemon_id, 
       t.type_id, 
       1
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN type t ON t.name = o.primary_type
ON CONFLICT (pokemon_id, type_id) DO NOTHING;

--tipo secundário
INSERT INTO pokemon_type (pokemon_id, type_id, slot)
SELECT p.pokemon_id, t.type_id, 2
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN type t ON t.name = o.secondary_type
WHERE o.secondary_type IS NOT NULL
ON CONFLICT DO NOTHING;

--teste
select *from pokemon p
inner join pokemon_type pt on p.pokemon_id = pt.pokemon_id
inner join type t on pt.type_id = t.type_id 
where t.name='"Rock"' order by p.pokemon_id ASC;

select *from pokemon_type;

--TABELA EGG_GROUP
INSERT INTO egg_group (name)
SELECT DISTINCT primary_egg_group
FROM pokemon_original 
WHERE primary_egg_group IS NOT NULL;

INSERT INTO egg_group (name)
SELECT DISTINCT secondary_egg_group
FROM pokemon_original 
WHERE secondary_egg_group IS NOT NULL
AND secondary_egg_group NOT IN (SELECT name FROM egg_group);

select *from egg_group;

--TABELA POKEMON_EGG (RELACIONAMENTO)
INSERT INTO pokemon_egg (egg_group_id, pokemon_id, slot)
SELECT e.egg_group_id, p.pokemon_id, 1
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN egg_group e ON e.name = o.primary_egg_group
ON CONFLICT DO NOTHING;


INSERT INTO pokemon_egg (egg_group_id, pokemon_id, slot)
SELECT e.egg_group_id, p.pokemon_id, 2
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN egg_group e ON e.name = o.secondary_egg_group
WHERE o.secondary_egg_group IS NOT NULL
ON CONFLICT DO NOTHING;

--teste
select *from pokemon p
inner join pokemon_egg pe on p.pokemon_id=pe.pokemon_id 
inner join egg_group eg on pe.egg_group_id=eg.egg_group_id 
where eg.name='"Field"';

--TABELA STATS
INSERT INTO stats (name) VALUES
('HP'), ('Attack'), ('Defense'), ('Sp. Attack'), ('Sp. Defense'), ('Speed');

--teste
select *from stats;

--TABELA
INSERT INTO pokemon_stats (pokemon_id, stat_id, base_value, effort_value)
SELECT p.pokemon_id, s.stat_id,
       CASE s.name
           WHEN 'HP' THEN o.health_stat
           WHEN 'Attack' THEN o.attack_stat
           WHEN 'Defense' THEN o.defense_stat
           WHEN 'Sp. Attack' THEN o.special_attack_stat
           WHEN 'Sp. Defense' THEN o.special_defense_stat
           WHEN 'Speed' THEN o.speed_stat
       END AS base_value,
       CASE s.name
           WHEN 'HP' THEN o.health_ev
           WHEN 'Attack' THEN o.attack_ev
           WHEN 'Defense' THEN o.defense_ev
           WHEN 'Sp. Attack' THEN o.special_attack_ev
           WHEN 'Sp. Defense' THEN o.special_defense_ev
           WHEN 'Speed' THEN o.speed_ev
       END AS effort_value
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN stats s ON s.name IN ('HP','Attack','Defense','Sp. Attack','Sp. Defense','Speed')
ON CONFLICT DO NOTHING;

--teste
select *from pokemon p
inner join pokemon_stats ps on p.pokemon_id=ps.pokemon_id 
inner join stats s on ps.stat_id=s.stat_id
where s.name='Attack' and ps.base_value > 100;

--TABELA ABILITY
INSERT INTO ability (name, description)
SELECT DISTINCT primary_ability, primary_ability_description
FROM pokemon_original
WHERE primary_ability IS NOT NULL;

INSERT INTO ability (name, description)
SELECT DISTINCT secondary_ability, secondary_ability_description
FROM pokemon_original
WHERE secondary_ability IS NOT NULL
AND secondary_ability NOT IN (SELECT name FROM ability);

INSERT INTO ability (name, description)
SELECT DISTINCT hidden_ability, hidden_ability_description
FROM pokemon_original
WHERE hidden_ability IS NOT NULL
AND hidden_ability NOT IN (SELECT name FROM ability);

--teste
select *from ability;

--TABELA POKEMON_ABILITY
INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN ability a ON a.name = o.primary_ability
ON CONFLICT DO NOTHING;


INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN ability a ON a.name = o.secondary_ability
WHERE o.secondary_ability IS NOT NULL
ON CONFLICT DO NOTHING;


INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o.pokemon_name
JOIN ability a ON a.name = o.hidden_ability
WHERE o.hidden_ability IS NOT NULL
ON CONFLICT DO NOTHING;

--teste
select *from pokemon p 
inner join pokemon_ability pa on p.pokemon_id = pa.pokemon_id 
inner join ability a on pa.ability_id = a.ability_id 
where a.name = '"Speed Boost"'

--TABELA POKEMON_EVOLUTION
INSERT INTO pokemon_evolution (from_pokemon_id, to_pokemon_id, condition)
SELECT DISTINCT 
    o.pre_evolution_pokemon_id::INT AS from_id,
    o.pokemon_id AS to_id,
    COALESCE(NULLIF(TRIM(o.evolution_details), ''), 'Unknown') AS condition
FROM pokemon_original o
WHERE o.pre_evolution_pokemon_id ~ '^[0-9]+$'
  AND o.pre_evolution_pokemon_id IS NOT NULL
  AND o.pre_evolution_pokemon_id <> ''
ON CONFLICT DO NOTHING;

--teste
SELECT 
    pe.from_pokemon_id,
    pf.pokemon_name AS evolves_from,
    pe.to_pokemon_id,
    pt.pokemon_name AS evolves_to,
    pe.condition
FROM pokemon_evolution pe
JOIN pokemon pf ON pf.pokemon_id = pe.from_pokemon_id
JOIN pokemon pt ON pt.pokemon_id = pe.to_pokemon_id
ORDER BY pe.from_pokemon_id;

UPDATE pokemon
SET is_legendary = NULL
WHERE is_legendary ='NULL';

UPDATE pokemon
SET alternat_form_name = NULL
WHERE alternat_form_name = 'NULL';