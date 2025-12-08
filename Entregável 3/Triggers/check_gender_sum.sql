-- Trigger para validação de soma de gênero
CREATE OR REPLACE FUNCTION pokemon_trab.check_gender_sum()
RETURNS TRIGGER AS $$
BEGIN
    IF (COALESCE(NEW.male_ratio, 0) + COALESCE(NEW.female_ratio, 0)) > 100 THEN
        RAISE EXCEPTION 'A soma das taxas de macho e fêmea não pode exceder 100 porcento';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_check_gender_sum
BEFORE INSERT OR UPDATE ON pokemon_trab.pokemon
FOR EACH ROW
EXECUTE FUNCTION pokemon_trab.check_gender_sum();

-- Teste
INSERT INTO pokemon_trab.pokedex (pokedex_num, original_pokemon_id) 
VALUES (9991, 9991), (9992, 9992);

INSERT INTO pokemon_trab.pokemon 
(pokedex_num, pokemon_name, exp_growth_id, male_ratio, female_ratio)
VALUES 
(9991, 'ExemploFail', 1, 60.00, 50.00);