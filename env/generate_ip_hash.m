function v_hash = generate_ip_hash(v, exc)
if nargin<2
    exc = {};
end
vstr = v;
% fields to exclude from hash check:
% (all other fields in input parser are used to make a hash - if hash is
% differnt on load, a new net is made)
exc = [exc, {'d_overwrite', 'overwrite', 'time'}];
for ix_exc = 1:length(exc)
    if isfield(vstr, exc{ix_exc})
        vstr = rmfield(vstr, exc{ix_exc});
    end
end

%sort alphabetically
[~, ix_vstr] = sort(lower(fieldnames(vstr)));
vstr = orderfields(vstr, ix_vstr);

vstr = strtrim(struct2string(vstr));
v_hash = string2hash(vstr);
end