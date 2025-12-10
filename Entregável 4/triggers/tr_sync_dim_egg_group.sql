-- trigger
create trigger tr_sync_dim_egg_group
after insert or update or delete on public.egg_group
for each row execute function sync_dim_egg_group();

--function
create or replace function sync_dim_egg_group()
returns trigger as $$
begin
    if tg_op = 'insert' then
        insert into dw.dim_egg_group (egg_group_id, name)
        values (new.id, new.name)
        on conflict (egg_group_id)
            do update set name = excluded.name;
        return new;

    elsif tg_op = 'update' then
        update dw.dim_egg_group
        set name = new.name
        where egg_group_id = old.id;
        return new;

    elsif tg_op = 'delete' then
        delete from dw.dim_egg_group
        where egg_group_id = old.id;
        return old;
    end if;
    return null;
end;
$$ language plpgsql;