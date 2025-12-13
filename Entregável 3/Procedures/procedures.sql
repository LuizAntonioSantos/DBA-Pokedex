--Procedure para adicionar uma coluna que tem o maior valor de stats base de um Pokémon, potencialmente ajudando em consultas e podendo ser atualizado quando necessário.
create or replace procedure update_highest_stat_value()
language plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pokemon' 
          AND column_name = 'highest_stat'
    ) THEN
        ALTER TABLE pokemon ADD COLUMN highest_stat TEXT;
    END IF;

    UPDATE pokemon p
    SET highest_stat = COALESCE((
        SELECT 'Highest Stat: ' || s.name || ' (' || ps.base_value::TEXT || ')'
        FROM pokemon_stats ps
        JOIN stats s ON s.stat_id = ps.stat_id
        WHERE ps.pokemon_id = p.pokemon_id
        ORDER BY ps.base_value DESC, s.name
        LIMIT 1
    ), 'Highest Stat: Unknown');
END;
$$;


call update_highest_stat_value();