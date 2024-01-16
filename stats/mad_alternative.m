function y = mad_alternative(X, flag, dim)
    % Custom MAD function to compute mean or median absolute deviation
    % courtesey of GPT4

    if nargin < 2
        flag = 0;
    end
    if nargin < 3
        dim = find(size(X) ~= 1, 1);
        if isempty(dim)
            dim = 1;
        end
    end

    % Computing the mean or median
    if flag == 0
        center = mean(X, dim);
    else
        center = median(X, dim);
    end

    % Subtracting the center and taking absolute values
    abs_dev = abs(X - center);

    % Calculating mean or median absolute deviation
    if flag == 0
        y = mean(abs_dev, dim);
    else
        y = median(abs_dev, dim);
    end
end
