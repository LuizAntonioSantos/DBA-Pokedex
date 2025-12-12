create or replace view view_eeveelutions as
	select
		p.pokedex_num as pokedex,
		p.pokemon_name as nome,
		evolucao.pokemon_name as evolucao
	from
		pokemon p
		left join 
			pokemon_evolution e on p.pokemon_id=e.from_pokemon_id
		left join
			pokemon evolucao on evolucao.pokemon_id=e.to_pokemon_id
	where
		p.pokedex_num = 133 
;