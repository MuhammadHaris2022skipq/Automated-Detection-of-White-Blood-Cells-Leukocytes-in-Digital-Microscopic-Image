function [TP, FP, TN, FN] = calError(true, predicted)

% This function calculates True Positives, False Positives, True Negatives
% and False Negatives for two matrices of equal size assuming they are
% populated by 1's and 0's.
% The trueMat contains the actual true values while the predictedMat
% contains the 1's and 0's predicted from the algorithm used.

adder = true + predicted;
TP = length(find(adder == 2));
TN = length(find(adder == 0));
subtr = true - predicted;
FP = length(find(subtr == -1));
FN = length(find(subtr == 1));