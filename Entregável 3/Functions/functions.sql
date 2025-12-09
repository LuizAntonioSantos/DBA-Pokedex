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

--Function para retornar a condição evolutiva entre dois Pokémon
--OBS: A base de dados original não abrange certos tipos de evolução e simplesmente as considera "NULL", como por exemplo evoluções por troca(sem itens) ou baseadas em friendship.
create or replace function get_evolution_condition(from_pokemon TEXT, to_pokemon TEXT)
returns text as $$
declare
    from_id INT;
    to_id INT;
    evo_condition TEXT;
begin

    SELECT pokemon_id
    INTO from_id
    FROM pokemon
    WHERE pokedex_num::TEXT = from_pokemon
       OR LOWER(pokemon_name) = LOWER(from_pokemon)
    limit 1;

    SELECT pokemon_id
    INTO to_id
    FROM pokemon
    WHERE pokedex_num::TEXT = to_pokemon
       OR LOWER(pokemon_name) = LOWER(to_pokemon)
    limit 1;

    IF from_id IS NULL THEN
        RETURN 'Pokémon de origem não encontrado.';
    END IF;

    IF to_id IS NULL THEN
        RETURN 'Pokémon alvo não encontrado.';
    END IF;

    SELECT condition
    INTO evo_condition
    FROM pokemon_evolution
    WHERE from_pokemon_id = from_id
      AND to_pokemon_id = to_id;

    IF evo_condition IS NULL THEN
        RETURN 'Esses Pokémon não possuem relação evolutiva.';
    END IF;

    RETURN evo_condition;
end;
$$ language plpgsql;


select *from get_evolution_condition('Poliwhirl', 'Politoad');