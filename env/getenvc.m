function op = getenvc(ip)
%% run getenv, but throw an error if it returns empty
op = getenv(ip);
if contains(op, 'ERROR:')
    if strcmpi(op(1:6), 'ERROR:')
        error('%s', op(7:end));
    end
end
assert(not(isempty(op)), sprintf('Environment variable %s not found.', ip))
end