--procedure 
create or replace procedure tornar_pseudo ()
as $$
begin
	update pokemon p set is_legendary = 'Pseudo-Legendary'
	where p.pokemon_id IN (
	select p.pokemon_id from pokemon p
	join pokemon_stats ps on p.pokemon_id = ps.pokemon_id
	where p.is_legendary IS NULL and p.alternat_form_name IS NULL and pokemon_name <> 'Scizor' and pokemon_name <> 'Archaludon'
	group by p.pokemon_id
	having sum(ps.base_value) = 600
	);

	update pokemon set is_legendary = 'Pseudo-Legendary' where pokemon_id = 522;
end;
$$ language plpgsql;

--chamar procedure
call tornar_pseudo();