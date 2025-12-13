--Function
CREATE OR REPLACE FUNCTION sync_dim_ability()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_ability (ability_id, name, description)
        VALUES (NEW.id, NEW.name, NEW.description)
        ON CONFLICT (ability_id)
            DO UPDATE SET 
                name = EXCLUDED.name,
                description = EXCLUDED.description;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_ability
        SET name = NEW.name,
            description = NEW.description
        WHERE ability_id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM dw.dim_ability
        WHERE ability_id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--Trigger
CREATE TRIGGER tr_sync_dim_ability
AFTER INSERT OR UPDATE OR DELETE ON public.ability
FOR EACH ROW EXECUTE FUNCTION sync_dim_ability();
