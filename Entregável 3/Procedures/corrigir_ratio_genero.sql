-- Procedimento para corrigir os valores de ratio de gênero dos pokémons
CREATE OR REPLACE PROCEDURE corrigir_ratio_genero(p_pokemon_id INT)
AS $$
DECLARE 
    v_male   NUMERIC;
    v_female NUMERIC;
    v_total  NUMERIC;
BEGIN 
    SELECT male_ratio, female_ratio
    INTO v_male, v_female
    FROM pokemon
    WHERE pokemon_id = p_pokemon_id;

    
    IF v_male IS NULL AND v_female IS NULL THEN
        v_male := 50;
        v_female := 50;

    
    ELSIF v_male IS NOT NULL AND v_female IS NULL THEN
        v_female := 100 - v_male;

    
    ELSIF v_male IS NULL AND v_female IS NOT NULL THEN
        v_male := 100 - v_female;

    ELSE
        v_total := v_male + v_female;

        RAISE NOTICE 'TOTAL calculado: %', v_total;

        IF v_total <> 100 THEN
            
            v_male := (v_male / v_total) * 100;
            v_female := 100 - v_male;
        ELSE
            RAISE NOTICE 'Nada a fazer';
        END IF;
    END IF;

    
    IF (v_male + v_female) <> 100 THEN
        v_female := 100 - v_male;
    END IF;

    UPDATE pokemon
    SET male_ratio = v_male,
        female_ratio = v_female
    WHERE pokemon_id = p_pokemon_id;
END;
$$ LANGUAGE plpgsql;
