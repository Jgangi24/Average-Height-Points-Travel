-- Version 2 schema: trip planner (3 fixed, always-editable trip slots)

-- Safe to re-run: drops these two tables first in case an earlier attempt
-- got partway through (e.g. tables created but the seed insert failed).
-- Nothing else in the app depends on them yet, so this is safe.
drop table if exists trip_legs;
drop table if exists trips;

create table trips (
  id uuid primary key default gen_random_uuid(),
  slot integer not null unique check (slot between 1 and 3),
  destination text not null,
  subtitle text,
  notes text[] not null default '{}',
  created_at timestamptz not null default now()
);

-- One row per leg (flights or hotel) per trip. source_program_ids stores
-- which rewards programs can pay for that leg, so "ways to pay" and the
-- coverage bar are worked out automatically -- swapping a trip's destination
-- needs no code change.
create table trip_legs (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  kind text not null check (kind in ('flights', 'hotel')),
  description text not null default '',
  points_estimate integer not null default 0,
  source_program_ids uuid[] not null default '{}',
  real_points integer,
  real_source text,
  real_price_date date,
  unique (trip_id, kind)
);

alter table trips enable row level security;
alter table trip_legs enable row level security;

create policy "Authenticated users have full access" on trips
  for all to authenticated using (true) with check (true);

create policy "Authenticated users have full access" on trip_legs
  for all to authenticated using (true) with check (true);

grant select, insert, update, delete on trips, trip_legs to authenticated;

-- Seed the 3 trip slots with what's being planned around now, matching the
-- v7 mockup. All three are fully editable in the app -- swap a destination
-- by editing it, no code change needed.
insert into trips (slot, destination, subtitle, notes) values
(1, 'Disney World', 'Orlando, 5 nights', array[
  'Both kids pay adult prices for park tickets, since Disney''s adult pricing starts at age 10.',
  'Park tickets are a cash cost, not a points cost. A later version could track a cash budget next to the points.'
]),
(2, 'Japan', 'Tokyo, 9 nights', array[
  'Many Tokyo hotel rooms fit only 2 or 3 people, so plan on 2 rooms or a family room.',
  'Four award seats on the same flight to Japan are hard to find. Search early and keep dates flexible.'
]),
(3, 'London', '6 nights', array[
  'Many London hotel rooms fit only 2 or 3 people. Look for a family room or book 2 rooms.',
  'British Airways award tickets can add high cash fees on top of the points. Compare before you book.'
]);

-- Null literals below are cast explicitly (::integer / ::text / ::date) --
-- without a cast, Postgres infers a bare NULL's type as text by default,
-- which then conflicts across a UNION ALL with the real Japan flight price
-- (an integer/text/date row further down).
with prog as (select short_name, id from programs)
insert into trip_legs (trip_id, kind, description, points_estimate, source_program_ids, real_points, real_source, real_price_date)
select t.id, 'flights', 'Boston to Orlando, 4 round-trip seats', 70000,
  array[(select id from prog where short_name = 'Chase'), (select id from prog where short_name = 'Amex'), (select id from prog where short_name = 'Capital One')],
  null::integer, null::text, null::date
from trips t where t.slot = 1
union all
select t.id, 'hotel', '5 nights, 1 room that fits 4', 250000,
  array[(select id from prog where short_name = 'Hilton'), (select id from prog where short_name = 'Marriott'), (select id from prog where short_name = 'Chase')],
  null::integer, null::text, null::date
from trips t where t.slot = 1
union all
select t.id, 'flights', 'Boston to Tokyo, 4 round-trip seats', 340000,
  array[(select id from prog where short_name = 'Chase'), (select id from prog where short_name = 'Amex'), (select id from prog where short_name = 'Capital One')],
  312000, 'seats.aero', date '2026-09-08'
from trips t where t.slot = 2
union all
select t.id, 'hotel', '9 nights, 2 rooms', 360000,
  array[(select id from prog where short_name = 'Hilton'), (select id from prog where short_name = 'Marriott'), (select id from prog where short_name = 'Chase')],
  null::integer, null::text, null::date
from trips t where t.slot = 2
union all
select t.id, 'flights', 'Boston to London, 4 round-trip seats', 200000,
  array[(select id from prog where short_name = 'Chase'), (select id from prog where short_name = 'Amex'), (select id from prog where short_name = 'Capital One')],
  null::integer, null::text, null::date
from trips t where t.slot = 3
union all
select t.id, 'hotel', '6 nights, 1 family room', 240000,
  array[(select id from prog where short_name = 'Marriott'), (select id from prog where short_name = 'Hilton'), (select id from prog where short_name = 'Chase')],
  null::integer, null::text, null::date
from trips t where t.slot = 3;
