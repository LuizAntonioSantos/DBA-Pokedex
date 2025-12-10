CREATE OR REPLACE FUNCTION sync_dim_pokemon()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_pokemon (pokemon_id, pokemon_name, classification, height, weight, base_happiness, capture_rate, is_legendary, male_ratio, female_ratio)
        VALUES (NEW.id, NEW.name, NEW.classification, NEW.height, NEW.weight, NEW.base_happiness, NEW.capture_rate, NEW.is_legendary, NEW.male_ratio, NEW.female_ratio)
        ON CONFLICT (pokemon_id)
            DO UPDATE SET 
                pokemon_name = EXCLUDED.pokemon_name,
                classification = EXCLUDED.classification,
                height = EXCLUDED.height,
                weight = EXCLUDED.weight,
                base_happiness = EXCLUDED.base_happiness,
                capture_rate = EXCLUDED.capture_rate,
                is_legendary = EXCLUDED.is_legendary,
                male_ratio = EXCLUDED.male_ratio,
                female_ratio = EXCLUDED.female_ratio;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_pokemon
        SET pokemon_name = NEW.name,
            classification = NEW.classification,
            height = NEW.height,
            weight = NEW.weight,
            base_happiness = NEW.base_happiness,
            capture_rate = NEW.capture_rate,
            is_legendary = NEW.is_legendary,
            male_ratio = NEW.male_ratio,
            female_ratio = NEW.female_ratio
        WHERE pokemon_id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM dw.dim_pokemon
        WHERE pokemon_id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_sync_dim_pokemon
AFTER INSERT OR UPDATE OR DELETE ON pokemon_trab.pokemon
FOR EACH ROW EXECUTE FUNCTION sync_dim_pokemon();