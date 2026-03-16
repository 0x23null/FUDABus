# Database Scripts

Current scripts for the active project flow:

1. `sqlectron_01_reset_schema.sql`
   Reset the current schema used by the app.
2. `sqlectron_04_seed_demo_week.sql`
   Seed demo data for the week `2026-03-15` to `2026-03-21`.
3. `sqlectron_05_smoke_check_week.sql`
   Verify the seeded trips and counts after reset/seed.

Recommended run order in Sqlectron:

1. `sqlectron_01_reset_schema.sql`
2. `sqlectron_04_seed_demo_week.sql`
3. `sqlectron_05_smoke_check_week.sql`

Older SQL files are kept in `legacy/` for reference only.
