--TABELA EXPERIENCE_GROWTH
INSERT INTO experience_growth (total_exp, exp_type)
SELECT DISTINCT 
    po."Experience_Growth_Total",
    po."Experience_Growth"
FROM pokemon_original po
WHERE po."Experience_Growth_Total" IS NOT NULL;

--teste
select eg.exp_type from experience_growth eg;


--TABELA POKEDEX
INSERT INTO pokedex (pokedex_num, original_pokemon_id)
SELECT DISTINCT 
    po."Pokedex_Number",
    NULLIF(po."Original_Pokemon_ID", 'NULL')::INT
FROM pokemon_original po
WHERE po."Pokedex_Number" IS NOT NULL
ORDER BY po."Pokedex_Number" ASC
ON CONFLICT (pokedex_num) DO NOTHING;


--TABELA POKEMON
INSERT INTO pokemon (
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
    op."Pokedex_Number",
    op."Pokemon_Name",
    op."Classification",
    op."Pokemon_Height",
    op."Pokemon_Weight",
    op."Base_Happiness",
    op."Catch_Rate",
    op."Game(s)_of_Origin",
    op."EV_Yield_Total",
    op."Legendary_Type",
    op."Alternate_Form_Name",
    e.experience_growth_ID,
    op."Male_Ratio",
    op."Female_Ratio"
FROM pokemon_original op
LEFT JOIN experience_growth e 
       ON e.total_exp = op."Experience_Growth_Total";

--teste
select *from pokemon p;

--TABELA TYPE
INSERT INTO type (name)
SELECT DISTINCT o."Primary_Type"
FROM pokemon_original o
WHERE o."Primary_Type" IS NOT NULL;

INSERT INTO type (name)
SELECT DISTINCT o."Secondary_Type"
FROM pokemon_original o
WHERE o."Secondary_Type" IS NOT NULL
AND o."Secondary_Type" NOT IN (SELECT name FROM type);

--teste
select *from type t;

--TABELA POKEMON_TYPE (DE RELACIONAMENTO)

-- Tipo primário
INSERT INTO pokemon_type (pokemon_id, type_id, slot)
SELECT DISTINCT
    p.pokemon_id,
    t.type_id,
    1
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN type t ON t.name = o."Primary_Type"
ON CONFLICT (pokemon_id, type_id) DO NOTHING;

-- Tipo secundário
INSERT INTO pokemon_type (pokemon_id, type_id, slot)
SELECT
    p.pokemon_id,
    t.type_id,
    2
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN type t ON t.name = o."Secondary_Type"
WHERE o."Secondary_Type" IS NOT NULL
ON CONFLICT DO NOTHING;



--teste
select *from pokemon p
inner join pokemon_type pt on p.pokemon_id = pt.pokemon_id
inner join type t on pt.type_id = t.type_id 
where t.name='Rock' order by p.pokemon_id ASC;

select *from pokemon_type;

--TABELA EGG_GROUP
INSERT INTO egg_group (name)
SELECT DISTINCT o."Primary_Egg_Group"
FROM pokemon_original o
WHERE o."Primary_Egg_Group" IS NOT NULL;

INSERT INTO egg_group (name)
SELECT DISTINCT o."Secondary_Egg_Group"
FROM pokemon_original o
WHERE o."Secondary_Egg_Group" IS NOT NULL
AND o."Secondary_Egg_Group" NOT IN (SELECT name FROM egg_group);


select *from egg_group;

--TABELA POKEMON_EGG (RELACIONAMENTO)
-- Primário
INSERT INTO pokemon_egg (egg_group_id, pokemon_id, slot)
SELECT e.egg_group_id, p.pokemon_id, 1
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN egg_group e ON e.name = o."Primary_Egg_Group"
ON CONFLICT DO NOTHING;

-- Secundário
INSERT INTO pokemon_egg (egg_group_id, pokemon_id, slot)
SELECT e.egg_group_id, p.pokemon_id, 2
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN egg_group e ON e.name = o."Secondary_Egg_Group"
WHERE o."Secondary_Egg_Group" IS NOT NULL
ON CONFLICT DO NOTHING;


--teste
select *from pokemon p
inner join pokemon_egg pe on p.pokemon_id=pe.pokemon_id 
inner join egg_group eg on pe.egg_group_id=eg.egg_group_id 
where eg.name='Field';

--TABELA STATS
INSERT INTO stats (name) VALUES
('HP'), ('Attack'), ('Defense'), ('Sp. Attack'), ('Sp. Defense'), ('Speed');

--teste
select *from stats;

--TABELA
INSERT INTO pokemon_stats (pokemon_id, stat_id, base_value, effort_value)
SELECT 
    p.pokemon_id, 
    s.stat_id,
    CASE s.name
        WHEN 'HP'          THEN o."Health_Stat"
        WHEN 'Attack'      THEN o."Attack_Stat"
        WHEN 'Defense'     THEN o."Defense_Stat"
        WHEN 'Sp. Attack'  THEN o."Special_Attack_Stat"
        WHEN 'Sp. Defense' THEN o."Special Defense_Stat"
        WHEN 'Speed'       THEN o."Speed_Stat"
    END AS base_value,
    CASE s.name
        WHEN 'HP'          THEN o."Health_EV"
        WHEN 'Attack'      THEN o."Attack_EV"
        WHEN 'Defense'     THEN o."Defense_EV"
        WHEN 'Sp. Attack'  THEN o."Special_Attack_EV"
        WHEN 'Sp. Defense' THEN o."Special_Defense_EV"
        WHEN 'Speed'       THEN o."Speed_EV"
    END AS effort_value
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN stats s ON s.name IN ('HP','Attack','Defense','Sp. Attack','Sp. Defense','Speed')
ON CONFLICT DO NOTHING;


--teste
select *from pokemon p
inner join pokemon_stats ps on p.pokemon_id=ps.pokemon_id 
inner join stats s on ps.stat_id=s.stat_id
where s.name='Attack' and ps.base_value > 100;

--TABELA ABILITY
INSERT INTO ability (name, description)
SELECT DISTINCT 
    o."Primary_Ability", 
    o."Primary_Ability_Description"
FROM pokemon_original o
WHERE o."Primary_Ability" IS NOT NULL;

INSERT INTO ability (name, description)
SELECT DISTINCT 
    o."Secondary_Ability", 
    o."Secondary_Ability_Description"
FROM pokemon_original o
WHERE o."Secondary_Ability" IS NOT NULL
AND o."Secondary_Ability" NOT IN (SELECT name FROM ability);

INSERT INTO ability (name, description)
SELECT DISTINCT 
    o."Hidden_Ability", 
    o."Hidden_Ability_Description"
FROM pokemon_original o
WHERE o."Hidden_Ability" IS NOT NULL
AND o."Hidden_Ability" NOT IN (SELECT name FROM ability);

--teste
select *from ability;

--TABELA POKEMON_ABILITY
-- Primary
INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN ability a ON a.name = o."Primary_Ability"
ON CONFLICT DO NOTHING;

-- Secondary
INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN ability a ON a.name = o."Secondary_Ability"
WHERE o."Secondary_Ability" IS NOT NULL
ON CONFLICT DO NOTHING;

-- Hidden
INSERT INTO pokemon_ability (pokemon_id, ability_id)
SELECT p.pokemon_id, a.ability_id
FROM pokemon_original o
JOIN pokemon p ON p.pokemon_name = o."Pokemon_Name"
JOIN ability a ON a.name = o."Hidden_Ability"
WHERE o."Hidden_Ability" IS NOT NULL
ON CONFLICT DO NOTHING;



--teste
select *from pokemon p 
inner join pokemon_ability pa on p.pokemon_id = pa.pokemon_id 
inner join ability a on pa.ability_id = a.ability_id 
where a.name = 'Speed Boost'

--TABELA POKEMON_EVOLUTION
--númerico
INSERT INTO pokemon_evolution (from_pokemon_id, to_pokemon_id, condition)
SELECT DISTINCT prev_p.pokemon_id AS from_id,
                curr_p.pokemon_id AS to_id,
                COALESCE(NULLIF(TRIM(o."Evolution_Details"), ''), 'Unknown') AS condition
FROM pokemon_original o
JOIN pokemon curr_p ON curr_p.pokedex_num = o."Pokedex_Number"
JOIN pokemon prev_p ON prev_p.pokedex_num = o."Pre_Evolution_Pokemon_Id"::INT
WHERE o."Pre_Evolution_Pokemon_Id" ~ '^[0-9]+$'
ON CONFLICT DO NOTHING;


--texto
INSERT INTO pokemon_evolution (from_pokemon_id, to_pokemon_id, condition)
SELECT DISTINCT 
    prev_p.pokemon_id AS from_id,
    curr_p.pokemon_id AS to_id,
    COALESCE(NULLIF(TRIM(o."Evolution_Details"), ''), 'Unknown') AS condition
FROM pokemon_original o
JOIN pokemon curr_p ON LOWER(curr_p.pokemon_name) = LOWER(o."Pokemon_Name")
JOIN pokemon prev_p ON LOWER(prev_p.pokemon_name) = LOWER(o."Pre_Evolution_Pokemon_Id")
WHERE o."Pre_Evolution_Pokemon_Id" !~ '^[0-9]+$'
  AND o."Pre_Evolution_Pokemon_Id" IS NOT NULL
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

DROP TABLE pokemon_original;

UPDATE pokemon
SET is_legendary = NULL
WHERE is_legendary ='NULL';

UPDATE pokemon
SET alternat_form_name = NULL
WHERE alternat_form_name = 'NULL';