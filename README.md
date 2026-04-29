# swellbrands.co

Marketing site for **Swell Brands** — the parent company of Ditch, Swell Surf Co., and what's coming next.

## Stack

- **GitHub** — source
- **Vercel** — hosting (auto-deploys from `main`)
- **Supabase** — newsletter signups

## Editing

- **Browser:** open this repo on GitHub and press <kbd>.</kbd> to launch [github.dev](https://github.dev) (full VS Code in a tab, no install)
- **Terminal:** `git pull`, edit `index.html`, `git push`
- **With AI:** run `claude` in this directory — [`CLAUDE.md`](./CLAUDE.md) provides full context

## Local preview

Open `index.html` directly in a browser. No build step, no dependencies.

## Newsletter signups

The "join the swell" form posts to a Supabase `subscribers` table. View signups at [app.supabase.com](https://app.supabase.com) → your project → Table Editor → `subscribers`.

To wire up Supabase:

1. Create a project at [app.supabase.com](https://app.supabase.com)
2. In the SQL Editor, run [`supabase/schema.sql`](./supabase/schema.sql)
3. Edit these two lines in `index.html`:

   ```javascript
   const SUPABASE_URL      = 'https://YOUR-PROJECT-ID.supabase.co';
   const SUPABASE_ANON_KEY = 'YOUR-PUBLIC-ANON-KEY';
   ```

Both values are public-safe — Row Level Security protects the data (anonymous clients can insert but cannot read).

## Domain

Live at <https://swellbrands.co> (apex) and <https://www.swellbrands.co> (redirects to apex).

DNS:
- Apex `A` → `76.76.21.21`
- `www` `CNAME` → `cname.vercel-dns.com`

## Project context

See [`CLAUDE.md`](./CLAUDE.md) for full project context, brand guidelines, deployment runbook, and feature playbook.
