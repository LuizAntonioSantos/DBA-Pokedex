-- Function para pegar os pokemons por tipo

create or replace function fn_pokemon_by_type(type_1 VARCHAR, type_2 VARCHAR default NULL)
returns table(
    pokemon_name VARCHAR(150),
    primary_type  VARCHAR(50),
    secondary_type VARCHAR(50)
)
as $$
begin
	IF type_2 IS NULL THEN
		RETURN QUERY
		SELECT 
			p.pokemon_name
		FROM type t
		JOIN pokemon_type pt ON pt.type_id = t.type_id
		JOIN pokemon p ON p.pokemon_id = pt.pokemon_id
		WHERE t.name = type_1;

	ELSIF type_2 IS NOT NULL THEN
		RETURN QUERY
		SELECT 
			p.pokemon_name,
            t1.name AS primary_type,
            t2.name AS secondary_type
        FROM pokemon p
        JOIN pokemon_type pt1 ON pt1.pokemon_id = p.pokemon_id
        JOIN type t1 ON t1.type_id = pt1.type_id
        JOIN pokemon_type pt2 ON pt2.pokemon_id = p.pokemon_id
        JOIN type t2 ON t2.type_id = pt2.type_id
        
        WHERE pt1.slot = 1 AND pt2.slot = 2 
			AND t1.name = type_1 AND t2.name = type_2;		
	END IF;
end;
$$ language plpgsql;


select * from fn_pokemon_by_type('Dark','Fairy');