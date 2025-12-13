--Function
CREATE OR REPLACE FUNCTION sync_dim_type()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO dw.dim_type (type_id, name)
        VALUES (NEW.id, NEW.name)
        ON CONFLICT (type_id)
            DO UPDATE SET name = EXCLUDED.name;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE dw.dim_type
        SET name = NEW.name
        WHERE type_id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM dw.dim_type
        WHERE type_id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--Trigger
CREATE TRIGGER tr_sync_dim_type
AFTER INSERT OR UPDATE OR DELETE ON pokemon_trab.type
FOR EACH ROW EXECUTE FUNCTION sync_dim_type();