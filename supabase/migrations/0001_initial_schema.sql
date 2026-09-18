-- Version 1 schema: balances and cards
-- Run this once in the Supabase SQL Editor to create the starting tables.

-- Reference list of rewards programs (Chase, Amex, Capital One, Hilton, Marriott, ...)
create table programs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  short_name text not null,
  unit text not null default 'points',
  created_at timestamptz not null default now()
);

-- Point balances. One pot per program per owner (or shared), since some
-- programs (like Amex) pool points across more than one card.
create table points_pots (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references programs(id) on delete restrict,
  owner text not null check (owner in ('Jess', 'Abby', 'Both')),
  label text,
  balance integer not null default 0,
  updated_at timestamptz not null default now()
);

-- Credit cards, each feeding exactly one points pot.
create table cards (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner text not null check (owner in ('Jess', 'Abby', 'Both')),
  program_id uuid not null references programs(id) on delete restrict,
  pot_id uuid not null references points_pots(id) on delete restrict,
  annual_fee numeric,
  fee_month integer check (fee_month between 1 and 12),
  bill_due_day integer check (bill_due_day between 1 and 31),
  decision_note text,
  status text not null default 'open' check (status in ('open', 'closed')),
  closed_at timestamptz,
  created_at timestamptz not null default now()
);

-- Perks tied to a card. Name and value are real editable fields (not a
-- placeholder), used for both adding a new perk and editing an existing one.
create table perks (
  id uuid primary key default gen_random_uuid(),
  card_id uuid not null references cards(id) on delete cascade,
  name text not null,
  value numeric not null,
  cadence text not null check (cadence in ('monthly', 'quarterly', 'semiannual', 'annual')),
  status text not null default 'open' check (status in ('open', 'done', 'upcoming')),
  window_end date,
  note text,
  created_at timestamptz not null default now()
);

-- One row per time a perk gets checked off, so the app can total up
-- "redeemed this month" and "redeemed this year".
create table perk_redemptions (
  id uuid primary key default gen_random_uuid(),
  perk_id uuid not null references perks(id) on delete cascade,
  redeemed_on date not null default current_date
);

-- Program-level alerts shown behind the notification bell.
create table alerts (
  id uuid primary key default gen_random_uuid(),
  program_id uuid references programs(id) on delete set null,
  title text not null,
  description text not null,
  affects text,
  expires_on date,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

-- Lock every table down until we wire up real login and access rules later.
-- With this on and no policies yet, nobody (including the app) can read or
-- write through the public connection -- intentional, since there's no login yet.
alter table programs enable row level security;
alter table points_pots enable row level security;
alter table cards enable row level security;
alter table perks enable row level security;
alter table perk_redemptions enable row level security;
alter table alerts enable row level security;

-- Seed the five reward programs already in use.
insert into programs (name, short_name, unit) values
  ('Chase Ultimate Rewards', 'Chase', 'points'),
  ('Amex Membership Rewards', 'Amex', 'points'),
  ('Capital One miles', 'Capital One', 'miles'),
  ('Hilton Honors', 'Hilton', 'points'),
  ('Marriott Bonvoy', 'Marriott', 'points');
