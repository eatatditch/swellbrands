-- Swell Brands — newsletter subscribers
-- Run this in the Supabase SQL Editor once per project.
--
-- Security model:
--   - Anonymous clients (anon key) can INSERT new rows.
--   - Anonymous clients CANNOT read, update, or delete.
--   - Reads happen via the Supabase dashboard (authenticated session) or service_role.

create table if not exists public.subscribers (
  id          bigint generated always as identity primary key,
  email       text not null,
  source      text,
  created_at  timestamptz not null default now()
);

-- Case-insensitive uniqueness on email.
create unique index if not exists subscribers_email_key
  on public.subscribers (lower(email));

-- Enforce a basic email shape at the DB level.
alter table public.subscribers
  drop constraint if exists subscribers_email_format;
alter table public.subscribers
  add constraint subscribers_email_format
  check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$');

-- Lock the table down.
alter table public.subscribers enable row level security;

-- Wipe any prior policies so re-running this file is safe.
drop policy if exists "anon insert" on public.subscribers;
drop policy if exists "anon select" on public.subscribers;
drop policy if exists "anon update" on public.subscribers;
drop policy if exists "anon delete" on public.subscribers;

-- Only INSERT is allowed for anonymous clients.
create policy "anon insert"
  on public.subscribers
  for insert
  to anon
  with check (true);

-- (No select/update/delete policies → anon is fully blocked from reading or modifying.)
