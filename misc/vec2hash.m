function hash=vec2hash(dob, type, rescale)
% just a modification of string2hash


% From string to double array
% dob = char(dob);  %2021-05-27
if(nargin<3)
    rescale = nan;
end
if isfinite(rescale)
    dob = dob - min(dob);
    dob = dob/range(dob);
    dob = dob * rescale;
end
dob = int64(dob);  % I think this fucntion was built for ints...
dob = double(dob);
assert(size(dob, 1) == 1, 'must be single column vector');
if(nargin<2), type='djb2'; end
if isempty(type), type='djb2';end

switch(type)
    case 'djb2'
        hash = 5381*ones(size(dob,1),1);
        for i=1:size(dob, 2)
            hash = mod(hash * 33 + dob(:,i), 2^32-1);
        end
    case 'sdbm'
        hash = zeros(size(dob,1),1);
        for i=1:size(dob, 2)
            hash = mod(hash * 65599 + dob(:,i), 2^32-1);
        end
    otherwise
        error('string_hash:inputs','unknown type');
end

assert(mod(hash, 1) == 0, 'not int...');
end