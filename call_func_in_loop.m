read_path = 'C:\Users\psf\Desktop\fyp_code_v4\Dataset_images\';
dest_path = 'C:\Users\psf\Desktop\fyp_code_v4\code_generated_images\';

for i=1:99
file_name = strcat('0',int2str(i));
ext = strcat(file_name,'.bmp');
read_file = strcat(read_path,ext);
out_image = WBC_SegProposed_loop(read_file,0);

save_file = strcat(dest_path,ext);

imwrite(out_image,save_file);

end