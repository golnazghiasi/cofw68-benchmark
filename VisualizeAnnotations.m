load('COFW68_Data/COFW_test.mat', 'IsT', 'phisT');
load('COFW68_Data/cofw68_test_bboxes.mat', 'bboxes');

for i = 1 : length(IsT)
    clf; imshow(IsT{i}); axis 'equal'; hold on;
    load(['COFW68_Data/test_annotations/' num2str(i) '_points.mat'], 'Points', 'Occ');
    plot(Points(Occ == 0, 1), Points(Occ == 0, 2), '.g', 'MarkerSize', 10);
    plot(Points(Occ == 1, 1), Points(Occ == 1, 2), '.r', 'MarkerSize', 10);
    
    rectangle('Position', bboxes(i, :), 'EdgeColor', 'b', 'LineWidth', 1);
    pause;
end
