create table if not exists public.reading_club_game_results (
  event_id uuid primary key,
  game_key text not null check (game_key in ('g1','g2','g3','g4','g5')),
  passed boolean not null,
  created_at timestamptz not null default now()
);

create index if not exists reading_club_game_results_game_key_idx
on public.reading_club_game_results (game_key, passed);

alter table public.reading_club_game_results enable row level security;

revoke all on table public.reading_club_game_results from anon, authenticated;
grant insert (event_id, game_key, passed) on public.reading_club_game_results to anon, authenticated;

drop policy if exists allow_reading_club_result_insert on public.reading_club_game_results;

create policy allow_reading_club_result_insert
on public.reading_club_game_results
for insert
to anon, authenticated
with check (game_key in ('g1','g2','g3','g4','g5'));

create or replace function public.get_reading_club_game_statistics()
returns table (
  game_key text,
  total_participants bigint,
  passed_participants bigint
)
language sql
stable
security definer
set search_path = ''
as $$
  with games(game_key) as (
    values ('g1'::text),('g2'::text),('g3'::text),('g4'::text),('g5'::text)
  )
  select
    games.game_key,
    count(results.event_id)::bigint as total_participants,
    count(results.event_id) filter (where results.passed)::bigint as passed_participants
  from games
  left join public.reading_club_game_results as results
    on results.game_key = games.game_key
  group by games.game_key
  order by games.game_key;
$$;

revoke execute on function public.get_reading_club_game_statistics() from public;
revoke execute on function public.get_reading_club_game_statistics() from anon, authenticated;
grant execute on function public.get_reading_club_game_statistics() to anon, authenticated;
