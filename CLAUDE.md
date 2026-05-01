# CLAUDE.md — swellbrands.co

## Project
Single-page marketing site for Swell Brands, parent of Ditch (restaurant), Swell Surf Co. (apparel), and a brunch concept.

## Stack
- GitHub (source) → Vercel (hosting) → Supabase (newsletter signups)
- Single self-contained index.html. No build step. No framework.

## Brand essentials
Voice: casual but standards-driven, irreverent, never corporate. Coastal soul, Long Island roots. Headlines lowercase. No emojis. No hospitality jargon.
Headline pattern: small script kicker + big chunky lowercase headline.
Type: Bagel Fat One (display) / Pacifico (script) / DM Sans (body).
Palette CSS variables in :root: --sand #f3e9d2, --paper #f8f1de, --ink #1a3741, --tide #1d4e58, --sun #ee7a3a (primary accent), --lime #d6dd6e, --hibiscus #c83e3e.
Pop accent: use <span class="pop"> once per headline to color one word orange.

## Working principles
- Keep index.html as a single file
- No build step, no framework, no npm
- Match existing brand voice
- Free tier first
