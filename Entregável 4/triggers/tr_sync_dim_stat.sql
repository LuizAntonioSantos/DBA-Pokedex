--trigger
create trigger tr_sync_dim_stat
after insert or update or delete on public.stat
for each row execute function sync_dim_stat();

--function
create or replace function sync_dim_stat()
returns trigger as $$
begin
    if tg_op = 'insert' then
        insert into dw.dim_stat (stat_id, name)
        values (new.id, new.name)
        on conflict (stat_id)
            do update set name = excluded.name;
        return new;

    elsif tg_op = 'update' then
        update dw.dim_stat
        set name = new.name
        where stat_id = old.id;
        return new;

    elsif tg_op = 'delete' then
        delete from dw.dim_stat
        where stat_id = old.id;
        return old;
    end if;
    return null;
end;
$$ language plpgsql;