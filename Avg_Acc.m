code_gen_path = 'C:\Users\psf\Desktop\fyp_code_v4\code_generated_images\';
ground_truth_path = 'C:\Users\psf\Desktop\fyp_code_v4\ground truth images data set2\';

file_names = {};
sen = {};
spec = {};
acc = {};

for i=1:99
file_name = strcat('0',int2str(i));
ext = strcat(file_name,'.bmp');
code_gen = strcat(code_gen_path,ext);
code_gen_file = imread(code_gen);
ground_truth = strcat(ground_truth_path,ext);
ground_truth_file = imread(ground_truth);

[TP, FP, TN, FN] = calError(code_gen_file,ground_truth_file);
Sensitivity = TP/(TP+FN);
Specificity = TN/(TN+FP);
Accuracy = (TP+TN)/(TP+FP+FN+TN);
file_names = [file_names;ext];
acc = [acc;Accuracy];
spec = [spec;Specificity];
sen = [sen;Sensitivity];

end
T = table(file_names,acc,spec,sen);

writetable(T,'files_data.xlsx',"Sheet",1,'Range','A1:D99');

