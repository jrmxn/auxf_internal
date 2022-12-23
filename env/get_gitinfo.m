function d = get_gitinfo(d)
if exist('d','var')==1
    if not(isstruct(d))
        error('Bad d input.');
    end
end

[git_stat, head_hash] = system('git rev-parse HEAD');
if git_stat==0
    d.ver_h = strtrim(head_hash);
else
    d.ver_h = nan;
    warning('Could not get git hash.');
end

[git_stat, head_tag] = system('git describe --tags');
if git_stat==0
    d.ver = strtrim(head_tag);
else
    [git_stat, head_hash_short] = system('git rev-parse --short HEAD');
    if git_stat==0
%         silently fall back on short hash
        d.ver = strtrim(head_hash_short);
    else
        d.ver = nan;
        warning('Could not get git tag.');
    end
end


d.time = datetime;

d.ver_str = d.ver(1:6);

[~,hn] = system('hostname');
d.hn = strtrim(hn);

end