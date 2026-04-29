# CLAUDE.md — Swell Brands

Context for Claude (and future humans) working on this repo.

## What this is

A single-page marketing site for **Swell Brands** — the parent company of:

- **Ditch** — coastal kitchen / hospitality (live at https://eatatditch.com)
- **Swell Surf Co.** — apparel & goods (coming)
- **One more** — TBA

The site is intentionally minimal: one HTML file, no build step, no framework. The goal is a tight brand statement plus newsletter capture for upcoming drops.

## Stack

| Layer | Choice | Why |
|---|---|---|
| Source | GitHub (`eatatditch/swellbrands`) | Single source of truth |
| Host | Vercel | Auto-deploys `main` to prod, every PR to a preview URL |
| Data | Supabase (Postgres + REST) | Anonymous inserts to a `subscribers` table; RLS protects it |
| Build | None | Static `index.html`. Edit, commit, push. |

If a task starts to feel like it needs a framework — stop and ask. This site stays static unless we decide together to graduate it.

## Repo layout

```
.
├── index.html           # The whole site. HTML + embedded CSS + embedded JS.
├── vercel.json          # www → apex redirect, security headers
├── supabase/
│   └── schema.sql       # subscribers table + RLS policies (run once in Supabase SQL editor)
├── README.md            # Public-facing readme
└── CLAUDE.md            # This file
```

## Brand guidelines

### Voice
Quiet confidence. We are surfers who happen to run a holding company, not marketers reaching for the surf vibe. Short sentences. No exclamation marks. Pacific Northwest/Montauk-coastal cadence — patient, weathered, a little dry. Never "epic," "stoked," or "rad."

Yes:
- "Born from the lineup."
- "Sent only when the set is rolling in."
- "We'd rather make one thing well than ten things fast."

No:
- "Stoked to launch our radical new drop!!"
- Anything in ALL CAPS for emphasis
- Emoji in body copy

### Color (CSS variables in `index.html`)
- `--ink: #0b2230` — deep ocean, primary text + dark surfaces
- `--ink-soft: #1f3a4a` — secondary text
- `--foam: #f5f1e8` — page background, off-white sand
- `--sand: #e8dfcc` — secondary surfaces
- `--tide: #2b6477` — accent (links, italics)
- `--sun: #e2a05a` — single warm accent, used sparingly

### Type
- Display: **Fraunces** (Google Fonts, weights 400/500/600). Italic is the brand voice — use for emphasis.
- Body: **Inter** (Google Fonts, weights 400/500/600).

### Layout principles
- Generous whitespace, oversized type, single accent color per section
- Animate sparingly: fade-up on scroll only (`.reveal` class)
- Honor `prefers-reduced-motion`
- No carousels, no video autoplay, no pop-ups

## Newsletter form (Supabase)

The form posts directly to Supabase REST: `POST /rest/v1/subscribers` with the anon key. Both `SUPABASE_URL` and `SUPABASE_ANON_KEY` are committed in `index.html` and are safe to expose — Row Level Security blocks reads.

### Schema (see `supabase/schema.sql`)
```sql
create table subscribers (
  id          bigint generated always as identity primary key,
  email       text not null unique,
  source      text,
  created_at  timestamptz not null default now()
);
alter table subscribers enable row level security;
create policy "anon insert" on subscribers
  for insert to anon with check (true);
-- No select/update/delete policies → anon cannot read or modify rows.
```

### Wiring it up
1. Create a Supabase project at https://app.supabase.com
2. Run `supabase/schema.sql` in the SQL Editor
3. Copy your project URL and anon key from Settings → API
4. Paste into the two constants at the top of the `<script>` block in `index.html`
5. Commit, push, Vercel deploys

### Viewing signups
Supabase dashboard → Table Editor → `subscribers`. The anon key cannot read the table; viewing requires a logged-in dashboard session.

## Deployment runbook

### First-time Vercel setup
1. Vercel → Add New → Project → import `eatatditch/swellbrands`
2. Framework preset: **Other** (no build, no install command, output dir: root)
3. Domains tab → add `swellbrands.co` (apex) and `www.swellbrands.co`
4. Point DNS:
   - Apex: `A` record → `76.76.21.21`
   - `www`: `CNAME` → `cname.vercel-dns.com`
5. `www.swellbrands.co` is configured to redirect to apex — set in Vercel domains panel **and** in `vercel.json`

### Day-to-day deploy
```
git add .
git commit -m "..."
git push
```
Vercel auto-deploys `main` to prod. PRs get a preview URL on the PR conversation.

### Rollback
Vercel dashboard → Deployments → find a known-good deploy → "Promote to Production." No downtime.

## Feature playbook

When asked to add something, default to **the smallest possible change**. Some examples and their right-sized solution:

| Ask | Right answer |
|---|---|
| "Add an Instagram link" | New `<a>` in the footer. Done. |
| "Add a fourth brand" | Duplicate `.brand-card`, add a new gradient class. Done. |
| "Make the hero image a real photo" | Add `<img>` with `loading="eager"` and `decoding="async"`, store the asset in Supabase Storage or `/public`. |
| "Add a contact form" | Reuse the newsletter pattern — second Supabase table, second `INSERT` policy. Don't add a backend. |
| "I want a blog" | Stop. This is a question, not a task. Ask if we should graduate to Next.js + MDX, or whether a Notion-backed JSON fetch on page load is enough. |
| "Add analytics" | Vercel Analytics (one script tag) before any third-party tool. |

### Things that should trigger an "are you sure?"
- Adding a build step (Webpack, Vite, Next.js, etc.)
- Adding a JS framework (React, Vue, Svelte, etc.)
- Adding a CSS framework (Tailwind, etc.) — the embedded CSS is intentional
- Adding a CMS (Sanity, Contentful, etc.)
- Adding e-commerce (Shopify, Stripe, etc.)

Each of these is fine if we discuss it first. The goal is for the site to stay editable in 60 seconds from any browser.

## Editing flows

- **Browser:** open the repo on GitHub, press `.` → github.dev (full VS Code in a tab)
- **Local:** `git pull`, edit `index.html`, open it in a browser (no server needed), `git push`
- **With Claude:** run `claude` in this directory — this file is the context

## Branches

Active development happens on `claude/build-swell-brands-site-PVOpu` (or successors). Merge to `main` to deploy to production.

## Don't

- Don't commit secrets. The Supabase anon key is fine; the `service_role` key is not — never put it in the repo.
- Don't `git push --force` to `main`.
- Don't add files that aren't strictly needed (no `.DS_Store`, no `node_modules`, no `dist/`).
- Don't break the "open `index.html` in a browser and it works" promise.
