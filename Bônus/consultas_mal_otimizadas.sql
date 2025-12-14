-- 1
SELECT *
FROM pokemon p
JOIN pokemon_stats ps ON ps.pokemon_id = p.pokemon_id
JOIN stats s ON s.stat_id = ps.stat_id
JOIN pokemon_type pt ON pt.pokemon_id = p.pokemon_id
JOIN type t ON t.type_id = pt.type_id
JOIN pokemon_ability pa ON pa.pokemon_id = p.pokemon_id
JOIN ability a ON a.ability_id = pa.ability_id
JOIN experience_growth eg ON eg.experience_growth_id = p.exp_growth_id;

-- 2
SELECT pokemon_name
FROM pokemon
WHERE LOWER(pokemon_name) = 'pikachu';

-- 3
SELECT p.pokemon_name,
       (SELECT AVG(ps.base_value)
        FROM pokemon_stats ps
        WHERE ps.pokemon_id = p.pokemon_id)
FROM pokemon p;

-- 4
SELECT p.pokemon_name, t.name
FROM pokemon p
JOIN pokemon_type pt ON pt.pokemon_id = p.pokemon_id
JOIN type t ON 1 = 1;

-- 5
SELECT pokemon_name, weight
FROM pokemon
ORDER BY weight DESC;

-- 6
SELECT *
FROM pokemon p
JOIN pokemon_evolution pe
  ON CAST(p.pokemon_id AS VARCHAR) = pe.from_pokemon_id;

-- 7
SELECT p.pokemon_name, s.name, ps.base_value
FROM pokemon p
JOIN pokemon_stats ps ON ps.pokemon_id = p.pokemon_id
JOIN stats s ON s.stat_id = ps.stat_id
WHERE s.name = 'attack';

-- 8
SELECT DISTINCT p.pokemon_name
FROM pokemon p
JOIN pokemon_type pt ON pt.pokemon_id = p.pokemon_id
JOIN type t ON t.type_id = pt.type_id;
