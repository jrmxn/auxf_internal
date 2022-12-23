function dt_anon = anon_datetime(dt_real, dt_day)
dt_1972 = datetime('1972-01-01', 'InputFormat','yyyy-MM-dd');
dt_anon = dt_1972 + (dt_real - dt_day);
end
