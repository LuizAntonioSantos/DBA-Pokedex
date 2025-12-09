-- function
create or replace function comparacao_status (poke_um varchar, poke_dois varchar, status_aux varchar)
returns text
as $$
declare 
	qtd1 int;
	qtd2 int;
begin
	select base_value into qtd1 from pokemon_stats ps 
	join pokemon p on ps.pokemon_id = p.pokemon_id
	join stats s on ps.stat_id = s.stat_id 
	where p.pokemon_name = poke_um and s.name = status_aux;

	select base_value into qtd2 from pokemon_stats ps 
	join pokemon p on ps.pokemon_id = p.pokemon_id
	join stats s on ps.stat_id = s.stat_id 
	where p.pokemon_name = poke_dois and s.name = status_aux;

	if qtd1 > qtd2 then 
		return 'O ' || poke_um || ' tem mais ' || status_aux || ' do que o ' || poke_dois || '.';
	elsif qtd2 > qtd1 then
		return 'O ' || poke_um || ' tem menos ' || status_aux || ' do que o ' || poke_dois || '.';
	else 
		return 'Os dois pokémon possuem a mesma quantidade de ' || status_aux || '.';
	end if;
end;
$$ language plpgsql;

-- teste function
select * from comparacao_status('Samurott','Camerupt','Attack');