-- Quais tipos de Pokémon têm maiores stats médios?
SELECT 
    t.name AS tipo,
    AVG(ps.base_value) AS media_stats
FROM pokemon_type pt
JOIN type t 
    ON pt.type_id = t.type_id
JOIN pokemon_stats ps 
    ON pt.pokemon_id = ps.pokemon_id
WHERE t.name <> 'NULL' 
GROUP BY t.name
ORDER BY media_stats DESC;


-- Qual é a habilidade que mais predomina nos Pokémons?
SELECT 
    a.name AS habilidade,
    COUNT(pa.pokemon_id) AS qtd_pokemons
FROM pokemon_ability pa
JOIN ability a 
    ON pa.ability_id = a.ability_id
WHERE a.name <> 'NULL' 
GROUP BY a.name
ORDER BY qtd_pokemons DESC;

-- Qual estatística média por grupo de ovo?

SELECT 
    eg.name AS egg_group,
    AVG(ps.base_value) AS media_stats
FROM pokemon_egg pe
JOIN egg_group eg 
    ON pe.egg_group_id = eg.egg_group_id
JOIN pokemon_stats ps
    ON pe.pokemon_id = ps.pokemon_id
WHERE eg.name <> 'NULL'
GROUP BY eg.name
ORDER BY media_stats DESC;