-- Trigger para prevenção de auto-evolução
CREATE OR REPLACE FUNCTION pokemon_trab.prevent_self_evolution()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.from_pokemon_id = NEW.to_pokemon_id THEN
        RAISE EXCEPTION 'Erro de Lógica: O Pokémon não pode evoluir para ele mesmo.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_prevent_self_evolution
BEFORE INSERT OR UPDATE ON pokemon_trab.pokemon_evolution
FOR EACH ROW
EXECUTE FUNCTION pokemon_trab.prevent_self_evolution();

-- Teste
INSERT INTO pokemon_trab.pokemon 
(pokedex_num, pokemon_name, exp_growth_id, male_ratio, female_ratio)
VALUES 
(9992, 'EvolucaoOk', 1, 0, 100);

INSERT INTO pokemon_trab.pokemon_evolution (from_pokemon_id, to_pokemon_id, condition)
VALUES (
    (SELECT pokemon_id FROM pokemon_trab.pokemon WHERE pokemon_name = 'ExemploOk' LIMIT 1),
    (SELECT pokemon_id FROM pokemon_trab.pokemon WHERE pokemon_name = 'ExemploOk' LIMIT 1),
    'Level 16'
);