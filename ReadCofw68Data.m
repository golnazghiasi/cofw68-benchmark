function test = ReadCofw68Data(data_file_add, data_dir)

fprintf('Reading COFW68 test data ...\n');
load(data_file_add, 'IsT', 'bboxesT');

for i = 1 : length(IsT)
    im_add = [data_dir '/im_' num2str(i) '.png'];
    pts_add = [data_dir  num2str(i) '_points.mat'];
    try
        imread(im_add);
    catch
        I = IsT{i};
        imwrite(I, im_add);
    end
    load(pts_add, 'Points', 'Occ');
    test(i).id = num2str(i);
    test(i).im = im_add;
    test(i).pts = Points;
    test(i).occ = Occ;
end
