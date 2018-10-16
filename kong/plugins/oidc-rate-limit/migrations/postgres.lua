return {
  {
    name = "2015-08-03-132400_init_oidc_user_ratelimiting_metrics",
    up = [[
      CREATE TABLE IF NOT EXISTS oidc_user_ratelimiting_metrics(
        identifier text,
        period text,
        period_date timestamp without time zone,
        value integer,
        PRIMARY KEY (identifier, period_date, period)
      );

      CREATE OR REPLACE FUNCTION increment_oidc_user_rate_limits(i text, p text, p_date timestamp with time zone, v integer) RETURNS VOID AS $$
      BEGIN
        LOOP
          UPDATE oidc_user_ratelimiting_metrics SET value = value + v WHERE identifier = i AND period = p AND period_date = p_date;
          IF found then
            RETURN;
          END IF;

          BEGIN
            INSERT INTO oidc_user_ratelimiting_metrics(period, period_date, identifier, value) VALUES(p, p_date, i, v);
            RETURN;
          EXCEPTION WHEN unique_violation THEN

          END;
        END LOOP;
      END;
      $$ LANGUAGE 'plpgsql';
    ]],
    down = [[
      DROP TABLE oidc_user_ratelimiting_metrics;
    ]]
  },
  {
    name = "oidc_user_ratelimiting_policies",
    up = function(_, _, dao)
      local rows, err = dao.plugins:find_all {name = "oidc-user-rate-limiting"}
      if err then return err end

      for i = 1, #rows do
        local oidc_user_rate_limiting = rows[i]

        -- Delete the old one to avoid conflicts when inserting the new one
        local _, err = dao.plugins:delete(oidc_user_rate_limiting)
        if err then return err end

        local _, err = dao.plugins:insert {
          name = "oidc-user-rate-limiting",
          consumer_id = oidc_user_rate_limiting.consumer_id,
          enabled = oidc_user_rate_limiting.enabled,
          config = {
            second = oidc_user_rate_limiting.config.second,
            minute = oidc_user_rate_limiting.config.minute,
            hour = oidc_user_rate_limiting.config.hour,
            day = oidc_user_rate_limiting.config.day,
            month = oidc_user_rate_limiting.config.month,
            year = oidc_user_rate_limiting.config.year,
            limit_by = "consumer",
            policy = "local",
            fault_tolerant = oidc_user_rate_limiting.config.continue_on_error
          }
        }
        if err then return err end
      end
    end
  }
}
