codegen = imread('C:\Users\psf\Desktop\FYP\code generated Bin images\01.bmp'); 
groundtruth = imread('C:\Users\psf\Desktop\FYP\ground truth images data set2\01.bmp');

[TP, FP, TN, FN] = calError(codegen,groundtruth)
Sensitivity = TP/(TP+FN)
Specificity = TN/(TN+FP)
Accuracy = (TP+TN)/(TP+FP+FN+TN)