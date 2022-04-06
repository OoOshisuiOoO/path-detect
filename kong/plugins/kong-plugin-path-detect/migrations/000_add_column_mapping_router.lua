return {
  postgres = {
    up = [[
      DO $$
          BEGIN
              ALTER TABLE IF EXISTS ONLY routes ADD mapping_id TEXT default null;
          EXCEPTION WHEN DUPLICATE_COLUMN THEN
      END$$;
    ]],
  },
  cassandra = {
    up = [[
      ALTER TABLE routes ADD mapping_id set<text>;
    ]],
  }
}
