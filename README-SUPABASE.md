# Supabase setup

## 1. Configure the browser app

Copy `.env.example` to `.env.local` and set your Supabase publishable key (or legacy anon key):

```env
VITE_SUPABASE_URL=https://temhzqgbsntpapfncuep.supabase.co
VITE_SUPABASE_ANON_KEY=your_publishable_or_anon_key
```

Never put a `service_role` or secret key in a browser app.

## 2. Create the table and policies

Run `supabase-schema.sql` in Supabase Dashboard → SQL Editor. Students can insert requests, while reading and updating is restricted to signed-in admin users.

## 3. Create the admin account

In Supabase Dashboard → Authentication → Users, create an admin user with email and password. The admin login page uses Supabase password authentication once `.env.local` is configured.

## Current scope

Student submissions, admin list refresh, approval/rejection and recharge completion write to `public.credit_requests`. For a secure student result page across sessions, add an email OTP or private request token lookup; the anonymous role is not allowed to read student records.

