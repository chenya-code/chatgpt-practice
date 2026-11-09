-- Run this in Supabase Dashboard > SQL Editor.
create table if not exists public.credit_requests (
  id text primary key,
  email text not null,
  name text not null check (char_length(name) <= 20),
  course text not null,
  created_at timestamptz not null default now(),
  status text not null default '待处理' check (status in ('待处理', '通过', '驳回')),
  reason text,
  reviewed_at timestamptz,
  recharged boolean not null default false,
  recharged_at timestamptz
);

-- Only this explicitly designated Auth user can review or change requests.
-- Replace the value with the administrator's Auth user UUID after creating that user.
create table if not exists public.app_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.credit_requests enable row level security;

-- Students can submit requests. Admin-only reads and updates require a
-- signed-in Supabase Auth user; the app must not expose requests to anon.
create policy "Anyone can submit a credit request"
on public.credit_requests for insert to anon
with check (status = '待处理' and recharged = false and reason is null and reviewed_at is null);

create policy "Authenticated admins can update requests"
on public.credit_requests for update to authenticated
using (exists (select 1 from public.app_admins a where a.user_id = (select auth.uid())))
with check (exists (select 1 from public.app_admins a where a.user_id = (select auth.uid())));

create policy "Authenticated admins can read requests"
on public.credit_requests for select to authenticated
using (exists (select 1 from public.app_admins a where a.user_id = (select auth.uid())));

alter table public.app_admins enable row level security;
create policy "Admins can read own admin mapping"
on public.app_admins for select to authenticated
using (user_id = (select auth.uid()));

grant insert, select on public.credit_requests to anon;
grant select, update on public.credit_requests to authenticated;
grant select on public.app_admins to authenticated;

create index if not exists credit_requests_created_at_idx
on public.credit_requests (created_at desc);

