-- Swell Brands — newsletter subscribers
-- Run this in the Supabase SQL Editor once per project.

create table subscribers (
  id         uuid primary key default gen_random_uuid(),
  email      text unique not null,
  source     text default 'website',
  created_at timestamptz default now()
);

alter table subscribers enable row level security;

create policy "anyone can subscribe"
  on subscribers for insert
  to anon
  with check (true);

create policy "authenticated users can view"
  on subscribers for select
  to authenticated
  using (true);
