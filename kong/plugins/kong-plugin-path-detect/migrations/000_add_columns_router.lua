return {
  postgres = {
    up = [[
      DO $$
          BEGIN
              ALTER TABLE IF EXISTS ONLY routes ADD mapping_id TEXT[];
          EXCEPTION WHEN DUPLICATE_COLUMN THEN
      END$$;
    ]],
  }
}
