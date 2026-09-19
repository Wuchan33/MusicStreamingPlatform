--  SEQUENCE RESET

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND is_identity = 'YES'
        ORDER BY table_name
    LOOP
        EXECUTE format(
            'SELECT setval(pg_get_serial_sequence(%L, %L),
                           COALESCE((SELECT max(%I) FROM %I), 0) + 1,
                           false)',
            r.table_name, r.column_name, r.column_name, r.table_name);
    END LOOP;
END $$;
