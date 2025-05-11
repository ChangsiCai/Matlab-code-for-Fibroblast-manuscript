function baseline = asLS_baseline_v1(signal, smoothness_param, asym_param)
% Estimate baseline with asymmetric least squares
MIN_DIFF = 1e-6;
MAX_ITER = 100;
ORDER = 2;

signal_length = length(signal);
signal = signal(:);

%assert(rem(nargin-1,2) == 0,'Number of parameter pairs is in error');

if nargin == 1
    smoothness_param = 1e3;
    asym_param = 1e-4;
end

penalty_vector = ones(signal_length, 1);

difference_matrix = diff(speye(signal_length), ORDER);


if length(smoothness_param) == 1
    smoothness_param = smoothness_param*ones(signal_length,1);
else
    ;
end
smoothness_matrix = smoothness_param*ones(1,size(difference_matrix,1));

differ = zeros(MAX_ITER);

for count = 1:MAX_ITER
    Weights = spdiags(penalty_vector, 0, signal_length, signal_length);

    C = chol(Weights + (smoothness_matrix .* difference_matrix') * difference_matrix);
    
    if count > 1
        baseline_last = baseline;
    end
    
    baseline = C \ (C' \ (penalty_vector .* signal));

    % Test for convergence
    if count > 1
        differ(count) = sum(abs(baseline_last-baseline));
        if (sum(abs(baseline_last-baseline)) < MIN_DIFF)
            break;  % Change is negligible
        else
            ;
        end
    end
%     count
    penalty_vector = (asym_param) .* (signal > baseline) + (1-asym_param) .* (signal < baseline);
end
