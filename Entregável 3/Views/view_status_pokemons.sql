create or replace view status_pokemons as
	select distinct
		p.pokemon_name as nome,
		max(case when pt.slot = 1 then t.name end) as tipo1,
    	max(case when pt.slot = 2 then t.name end) as tipo2,
		a.name as habilidade,
		max(case when s.name = 'HP' then ps.base_value end) as vida,
    	max(case when s.name = 'Attack' then ps.base_value end) as ataque,
    	max(case when s.name = 'Defense' then ps.base_value end) as defesa,
    	max(case when s.name = 'Sp. Attack' then ps.base_value end) as ataque_especial,
    	max(case when s.name = 'Sp. Defense' then ps.base_value end) as defesa_especial,
    	max(case when s.name = 'Speed' then ps.base_value end) as velocidade,
		eg.name as ovo
	from 
		pokemon p
		join 
			pokemon_type pt on pt.pokemon_id = p.pokemon_id
		join
			type t on t.type_id = pt.type_id
		join
			pokemon_ability pa on pa.pokemon_id=p.pokemon_id
		join
			ability a on a.ability_id=pa.ability_id
		join
			pokemon_stats ps on ps.pokemon_id=p.pokemon_id
		join
			stats s on s.stat_id=ps.stat_id
		join
			pokemon_egg pe on p.pokemon_id=pe.pokemon_id
		join
			egg_group eg on pe.egg_group_id=eg.egg_group_id
		where
			t.name <> 'NULL'
			and eg.name <> 'NULL'
		group by 
			p.pokemon_name,
			a.name,
			eg.name
;
