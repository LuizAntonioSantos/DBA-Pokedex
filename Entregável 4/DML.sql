insert into dw.dim_pokemon (
	pokemon_id,
	pokemon_name,
	classification,
	height,
	weight,
	base_happiness,
	capture_rate,
	is_legendary,
	male_ratio,
	female_ratio
) select p.pokemon_id, 
	p.pokemon_name, 
	p.classification, 
	p.height, 
	p.weight, 
	p.base_happiness, 
	p.catch_rate, 
	p.is_legendary, 
	p.male_ratio, 
	p.female_ratio
from pokemon_trab.pokemon p
;


insert into dw.dim_tipo (
	type_id,
	name
) select t.type_id, t.name
from pokemon_trab.type t
;


insert into dw.dim_habilidade (
	ability_id,
	name,
	description
) select a.ability_id, a.name, a.description
from pokemon_trab.ability a
;


insert into dw.dim_egg_group (
	egg_group_id,
	name
) select e.egg_group_id, e.name
from pokemon_trab.egg_group e
;


insert into dw.dim_stat(
	stat_id,
	name
) select s.stat_id, s.name
from pokemon_trab.stats s
;


insert into dw.fato_pokemon (
	pokemon_sk,
	type_sk,
	ability_sk,
	egg_group_sk,
	total_stats,
	avg_stat,
	qtd_abilities,
	qtd_types
) select
    dp.pokemon_sk,
    dt.type_sk,
    dh.ability_sk,
    de.egg_group_sk,
    stats.total_stats,
    stats.media_stats,
    habilidade.qtd_habilidades,
    tipos.qtd_tipos
from pokemon_trab.pokemon p
join dw.dim_pokemon dp
    on dp.pokemon_id = p.pokemon_id

left join (
    select pokemon_id, count(*) as qtd_tipos
    from pokemon_trab.pokemon_type
    group by pokemon_id
) tipos on tipos.pokemon_id = p.pokemon_id

left join pokemon_trab.pokemon_type pt 
    on pt.pokemon_id = p.pokemon_id

left join dw.dim_tipo dt
    on dt.type_id = pt.type_id

left join (
    select pokemon_id, count(*) as qtd_habilidades
    from pokemon_trab.pokemon_ability
    group by pokemon_id
) habilidade on habilidade.pokemon_id = p.pokemon_id

left join pokemon_trab.pokemon_ability pa
    on pa.pokemon_id = p.pokemon_id

left join dw.dim_habilidade dh
    on dh.ability_id = pa.ability_id

left join pokemon_trab.pokemon_egg pe
    on pe.pokemon_id = p.pokemon_id

left join dw.dim_egg_group de
    on de.egg_group_id = pe.egg_group_id

left join (
    select 
        pokemon_id,
        sum(base_value) as total_stats,
        avg(base_value) as media_stats
    from pokemon_trab.pokemon_stats
    group by pokemon_id
) stats on stats.pokemon_id = p.pokemon_id;