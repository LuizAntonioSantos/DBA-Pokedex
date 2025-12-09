--altera todos os varchar da tabela original para text, caso dê erro na hora de importar o arquivo csv (DDL da tabela original)
DO $$
DECLARE r RECORD;
BEGIN
    FOR r IN (
        SELECT column_name 
        FROM information_schema.columns
        WHERE table_name = 'pokemon_original'
        AND data_type = 'character varying'
    )
    LOOP
        EXECUTE format(
            'ALTER TABLE pokemon_original ALTER COLUMN "%s" TYPE TEXT;',
            r.column_name
        );
    END LOOP;
END $$;
--altera os nomes da tabela original para os nomes da tabela normalizada, permitindo a migração direta do arquivo.
ALTER TABLE pokemon_original RENAME COLUMN "Pokemon Id" TO pokemon_id;
ALTER TABLE pokemon_original RENAME COLUMN "Pokedex Number" TO pokedex_number;
ALTER TABLE pokemon_original RENAME COLUMN "Pokemon Name" TO pokemon_name;
ALTER TABLE pokemon_original RENAME COLUMN "Legendary Type" TO is_legendary;
ALTER TABLE pokemon_original RENAME COLUMN "Classification" TO classification;
ALTER TABLE pokemon_original RENAME COLUMN "Alternate Form Name" TO alternate_form_name;
ALTER TABLE pokemon_original RENAME COLUMN "Original Pokemon ID" TO original_pokemon_id;
ALTER TABLE pokemon_original RENAME COLUMN "Pokemon Height" TO pokemon_height;
ALTER TABLE pokemon_original RENAME COLUMN "Pokemon Weight" TO pokemon_weight;
ALTER TABLE pokemon_original RENAME COLUMN "Primary Type" TO primary_type;
ALTER TABLE pokemon_original RENAME COLUMN "Secondary Type" TO secondary_type;
ALTER TABLE pokemon_original RENAME COLUMN "Primary Ability" TO primary_ability;
ALTER TABLE pokemon_original RENAME COLUMN "Primary Ability Description" TO primary_ability_description;
ALTER TABLE pokemon_original RENAME COLUMN "Secondary Ability" TO secondary_ability;
ALTER TABLE pokemon_original RENAME COLUMN "Secondary Ability Description" TO secondary_ability_description;
ALTER TABLE pokemon_original RENAME COLUMN "Hidden Ability" TO hidden_ability;
ALTER TABLE pokemon_original RENAME COLUMN "Hidden Ability Description" TO hidden_ability_description;
ALTER TABLE pokemon_original RENAME COLUMN "Special Event Ability" TO special_event_ability;
ALTER TABLE pokemon_original RENAME COLUMN "Special Event Ability Description" TO special_event_ability_description;
ALTER TABLE pokemon_original RENAME COLUMN "Male Ratio" TO male_ratio;
ALTER TABLE pokemon_original RENAME COLUMN "Female Ratio" TO female_ratio;
ALTER TABLE pokemon_original RENAME COLUMN "Base Happiness" TO base_happiness;
ALTER TABLE pokemon_original RENAME COLUMN "Game(s) of Origin" TO games_of_origin;
ALTER TABLE pokemon_original RENAME COLUMN "Health Stat" TO health_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Attack Stat" TO attack_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Defense Stat" TO defense_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Special Attack Stat" TO special_attack_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Special Defense Stat" TO special_defense_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Speed Stat" TO speed_stat;
ALTER TABLE pokemon_original RENAME COLUMN "Base Stat Total" TO base_stat_total;
ALTER TABLE pokemon_original RENAME COLUMN "Health EV" TO health_ev;
ALTER TABLE pokemon_original RENAME COLUMN "Attack EV" TO attack_ev;
ALTER TABLE pokemon_original RENAME COLUMN "Defense EV" TO defense_ev;
ALTER TABLE pokemon_original RENAME COLUMN "Special Attack EV" TO special_attack_ev;
ALTER TABLE pokemon_original RENAME COLUMN "Special Defense EV" TO special_defense_ev;
ALTER TABLE pokemon_original RENAME COLUMN "Speed EV" TO speed_ev;
ALTER TABLE pokemon_original RENAME COLUMN "EV Yield Total" TO ev_yield_total;
ALTER TABLE pokemon_original RENAME COLUMN "Catch Rate" TO catch_rate;
ALTER TABLE pokemon_original RENAME COLUMN "Experience Growth" TO experience_growth;
ALTER TABLE pokemon_original RENAME COLUMN "Experience Growth Total" TO experience_growth_total;
ALTER TABLE pokemon_original RENAME COLUMN "Primary Egg Group" TO primary_egg_group;
ALTER TABLE pokemon_original RENAME COLUMN "Secondary Egg Group" TO secondary_egg_group;
ALTER TABLE pokemon_original RENAME COLUMN "Egg Cycle Count" TO egg_cycle_count;
ALTER TABLE pokemon_original RENAME COLUMN "Pre-Evolution Pokemon Id" TO pre_evolution_pokemon_id;
ALTER TABLE pokemon_original RENAME COLUMN "Evolution Details" TO evolution_details;
