--Trigger tabela ability
CREATE OR REPLACE FUNCTION sync_dim_ability ()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_habilidade (ability_id, name, description)
        VALUES (NEW.id, NEW.name, NEW.description)
        ON CONFLICT (ability_id)
            DO UPDATE SET 
                name = EXCLUDED.name,
                description = EXCLUDED.description;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_habilidade
        SET name = NEW.name,
            description = NEW.description
        WHERE ability_id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM dw.dim_habilidade
        WHERE ability_id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
--Trigger tabela pokemon_stats
CREATE TRIGGER tr_sync_dim_habilidade
AFTER INSERT OR UPDATE OR DELETE ON public.habilidade
FOR EACH ROW EXECUTE FUNCTION sync_dim_habilidade();

CREATE OR REPLACE FUNCTION sync_dim_stat()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_stat (stat_id, name)
        VALUES (NEW.id, NEW.name)
        ON CONFLICT (stat_id)
            DO UPDATE SET name = EXCLUDED.name;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_stat
        SET name = NEW.name
        WHERE stat_id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM dw.dim_stat
        WHERE stat_id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_sync_dim_stat
AFTER INSERT OR UPDATE OR DELETE ON public.stat
FOR EACH ROW EXECUTE FUNCTION sync_dim_stat();
