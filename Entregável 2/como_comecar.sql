-- Primeiro criar um esquema com o nome 'pokemon_trab'
-- Segundo criar a tabela pokemon_original e importar os dados dentro dela

CREATE OR REPLACE FUNCTION strip_quotes(text)
RETURNS text AS $$
BEGIN
    RETURN regexp_replace($1, '^"(.*)"$', '\1');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

DO $$
DECLARE
    col text;
    update_list text := '';
BEGIN

    FOR col IN 
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = 'pokemon_trab'
          AND table_name = 'pokemon_original'
          AND data_type IN ('text', 'character varying')
    LOOP
        update_list := update_list ||
            format('%I = replace(%I, ''"'', ''''), ', col, col);
    END LOOP;


    IF update_list = '' THEN
        RAISE NOTICE 'Nenhuma coluna text/varchar encontrada.';
        RETURN;
    END IF;


    update_list := left(update_list, length(update_list) - 2);


    EXECUTE format('UPDATE pokemon_trab.pokemon_original SET %s;', update_list);
END $$;


