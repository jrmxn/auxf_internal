function [b, stats] = robustfit_alternative(X, y, varargin)
% Set default values
weightFunction = 'bisquare'; % Only 'bisquare' is currently supported
k = 4.685; % Default tuning constant for bisquare weight function
includeConst = 'on'; % Default to include constant term

% Default convergence settings
maxIter = 100; % Maximum number of iterations
tol = 1e-5;    % Convergence tolerance for coefficient change

case_reject = not(all(isfinite([X, y]), 2));
X(case_reject, :) = [];
y(case_reject, :) = [];

% Process variable input arguments
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            case 'bisquare'
                weightFunction = varargin{i};
                k = varargin{i+1}; % Next argument should be the tuning constant
                i = i + 1; % Skip the next argument as it has been processed
            case {'on', 'off'}
                includeConst = varargin{i};
            otherwise
                error('Unsupported weight function. Only ''bisquare'' is supported.');
        end
    end
end

% Add a column of ones to X for the intercept term if 'includeConst' is 'on'
if strcmp(includeConst, 'on')
    X = [ones(size(X, 1), 1), X];
end

% Initial OLS regression
b = X \ y;
n = length(y);
p = size(X, 2);

% Main loop for iteratively reweighted least squares


for iter = 1:maxIter
    previous_b = b;
    % Compute residuals
    residuals = y - X * b;

    % Calculate bisquare weights
    r = residuals / (k * mad_alternative(residuals, 1));
    weights = (abs(r) < 1) .* (1 - r.^2).^2;

    % Weighted least squares
    W = diag(weights);
    %     b = (X' * W * X) \ (X' * W * y);
    b = pinv(X' * W * X) * (X' * W * y);  % more robust v2

    % Check for convergence
    if max(abs(b - previous_b)) < tol
        break;
    end
end

% Computing statistics (Optional)
residuals = y - X * b;
sigma = sqrt(sum(residuals.^2) / (n - p));
var_b = sigma^2 * (X' * X) \ eye(size(X, 2));  % New, more stable approach
se_b = sqrt(diag(var_b));

% Output structure
stats = struct('se', se_b, 'residuals', residuals);


end

%% TESTS
% % Generate test data for a single predictor
% n = 100; % number of samples
% p = 1; % number of predictors (single for easy visualization)
% outlierRatio = 0.2; % 10% of the data are outliers
% 
% [X, y] = generateTestData(n, p, outlierRatio);
% 
% % Standard linear regression (OLS)
% b_ols = [ones(n, 1), X] \ y;
% k = 5
% % Custom robust regression
% [b_custom, ~] = robustfit_alternative(X, y, 'off');
% 
% % MATLAB's robustfit
% if exist('robustfit', 'file') == 2
%     b_matlab = robustfit(X, y, 'bisquare', k, 'off');
% else
%     b_matlab = NaN(size(b_custom)); % Placeholder if robustfit is not available
% end
% 
% % Plot data and fitted lines
% figure;
% scatter(X, y, 'filled');
% hold on;
% 
% % OLS line
% plot(X, [ones(n, 1), X] * b_ols, 'r--', 'LineWidth', 2);
% 
% % Custom robust line
% plot(X, [X] * b_custom, 'g-', 'LineWidth', 2);
% 
% % MATLAB's robustfit line
% if ~isnan(b_matlab(1))
%     plot(X, [X] * b_matlab, 'b--', 'LineWidth', 2);
% end
% 
% legend('Data', 'OLS Regression', 'Custom Robust Regression', 'MATLAB Robustfit', 'Location', 'best');
% xlabel('Predictor');
% ylabel('Response');
% title('Comparison of Regression Fits');
% hold off;
% 
% 
% function [X, y] = generateTestData(n, p, outlierRatio)
% % n: number of samples
% % p: number of predictors
% % outlierRatio: fraction of samples that are outliers
% 
% % Generate random predictor data
% X = randn(n, p);
% 
% % True coefficients (random)
% trueCoeffs = randn(p + 1, 1);
% 
% % Generate response variable
% y = [ones(n, 1), X] * trueCoeffs + randn(n, 1) * 0.5; % adding some noise
% 
% % Introduce outliers
% numOutliers = round(outlierRatio * n);
% outlierIndices = randperm(n, numOutliers);
% y(outlierIndices) = y(outlierIndices) + randn(numOutliers, 1) * 10; % large noise for outliers
% end
