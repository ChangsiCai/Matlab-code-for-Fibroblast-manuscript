function baseline = estimate_baseline_percentile(signal, windowSize, percentile)
    % signal: 1D Ca2+ signal vector
    % windowSize: number of samples in the sliding window (e.g., 100)
    % percentile: low percentile to use for baseline (e.g., 8)

    % Pad signal to handle edges
    halfWin = floor(windowSize / 2);
    paddedSignal = padarray(signal(:), [halfWin 0], 'replicate');

    % Preallocate baseline
    baseline = zeros(size(signal));

    % Sliding window percentile filter
    for i = 1:length(signal)
        windowData = paddedSignal(i:i + windowSize - 1);
        baseline(i) = prctile(windowData, percentile);
    end
end
