create or replace view view_pokemons_maior_status as 
	select distinct
		p.pokemon_id as id,
		p.pokedex_num as numero_pokedex,
		p.pokemon_name as nome,
		sum(ps.base_value) as soma 
	from 
		pokemon p
		join
			pokemon_stats ps on ps.pokemon_id=p.pokemon_id
	group by
		p.pokemon_id,
		p.pokedex_num,
		p.pokemon_name	
	order by
		soma desc
	limit 10
;