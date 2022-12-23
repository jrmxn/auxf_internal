function ts = anon_timestamp(ts, dt_day)
dt_real = datetime(ts * 1e-6, 'ConvertFrom', 'posixtime');
dt_anon = anon_datetime(dt_real, dt_day);
ts = posixtime(dt_anon) * 1e6;
end

