-- Script para criar a tabela de histórico no schema
CREATE TABLE IF NOT EXISTS pokemon_trab.pokemon_stats_history (
    history_id SERIAL PRIMARY KEY,
    pokemon_id INT,
    stat_id INT,
    old_base_value INT,
    new_base_value INT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger para registrar alterações nos stats dos pokémons
CREATE OR REPLACE FUNCTION pokemon_trab.log_stats_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.base_value <> NEW.base_value THEN
        INSERT INTO pokemon_trab.pokemon_stats_history (pokemon_id, stat_id, old_base_value, new_base_value)
        VALUES (OLD.pokemon_id, OLD.stat_id, OLD.base_value, NEW.base_value);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_log_stats_changes
AFTER UPDATE ON pokemon_trab.pokemon_stats
FOR EACH ROW
EXECUTE FUNCTION pokemon_trab.log_stats_changes();

-- Teste
INSERT INTO pokemon_trab.pokemon_stats (pokemon_id, stat_id, base_value, effort_value)
VALUES (
    (SELECT pokemon_id FROM pokemon_trab.pokemon WHERE pokemon_name = 'ExemploOk' LIMIT 1),
    (SELECT stat_id FROM pokemon_trab.stats WHERE name = 'Speed_Test' LIMIT 1),
    50, 
    1
);