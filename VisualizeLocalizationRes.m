function [] = VisualizeLocalizationRes( ...
    boxes, pts_name, occ_name, test, testname, figdir, ...
    crop_images, show_groundtruth, show_keypoint_num, errors, ...
    draw_line_between_gt_det, method_name, max_to_show)
if(~exist('max_to_show', 'var') || max_to_show > length(test))
    max_to_show = length(test);
end

fprintf(['Visualizing landmark localization predication of first %d images' ...
    ' for %s method ...\n'], max_to_show, method_name);
save_res = fullfile(figdir, method_name);
if(~exist(save_res, 'dir'))
    mkdir(save_res);
end
for i = 1 : max_to_show
    if(isempty(boxes{i}))
        im = imread(test(i).im);
        clf; imagesc(im); axis off; axis image; hold on;
        
        if isfield(test(i), 'bbox')
            bbox = test(i).bbox;
            [im, offset] = CropImage(im, bbox, 0);
            clf; imagesc(im); axis off; axis image; hold on;
        end
        continue;
    end
    
    pts_gt = test(i).pts;
    if isfield(test(i), 'occ') && ~isempty(test(i).occ)
        occ_gt = test(i).occ;
    else
        occ_gt = zeros(1, size(pts_gt, 1));
    end
    
    im = imread(test(i).im);
    b = boxes{i}(1);
    pts_det = getfield(b, pts_name);
    occ_det = getfield(b, occ_name);
    
    if crop_images
        if isfield(test(i), 'bbox')
            bbox = test(i).bbox;
            [im, offset] = CropImage(im, bbox, 0.3);
        else
            bbox = [min(pts_gt(:, 1)),  min(pts_gt(:, 2)), ...
                max(pts_gt(:, 1)), max(pts_gt(:, 2))];
            [im, offset] = CropImage(im, bbox, 0.3);
        end
        
        pts_gt(:, 1) = pts_gt(:, 1) - offset(1);
        pts_gt(:, 2) = pts_gt(:, 2) - offset(2);
        
        pts_det(:, 1) = pts_det(:, 1) - offset(1);
        pts_det(:, 2) = pts_det(:, 2) - offset(2);
    end
    
    clf; imagesc(im); axis off; axis image; hold on;
    if(size(im, 3) == 1)
        colormap(gray);
    end
    plot(pts_det(occ_det == 0, 1), pts_det(occ_det == 0, 2), '.g', ...
        'MarkerSize', 20);
    plot(pts_det(occ_det == 1, 1), pts_det(occ_det == 1, 2), '.r', ...
        'MarkerSize', 20);
    
    if show_keypoint_num
        ShowKeypointNums(pts_det, 'k');
    end
    
    if show_groundtruth
        plot(pts_gt(occ_gt == 0, 1), pts_gt(occ_gt == 0, 2), '.b', ...
            'MarkerSize', 20);
        plot(pts_gt(occ_gt == 1, 1), pts_gt(occ_gt == 1, 2), '.m', ...
            'MarkerSize', 20);
        
        if show_keypoint_num
            ShowKeypointNums(pts_gt, 'm');
        end
    end
    if draw_line_between_gt_det
        for k = 1 : size(pts_gt, 1)
            plot([pts_gt(k, 1) pts_det(k, 1)], [pts_gt(k, 2) pts_det(k, 2)], 'g');
        end
    end
    title(sprintf('%.3f', errors(i)));
    pause;
    %export_fig(fullfile(save_res, num2str(i)), '-pdf');
end


function [im, offset] = CropImage(im, box, pad_ratio)
% Crops image around the bounding box.
pad = pad_ratio * ((box(3) - box(1) + 1) + (box(4) - box(2) + 1));
x1 = max(1, round(box(1) - pad));
y1 = max(1, round(box(2) - pad));
x2 = min(size(im, 2), round(box(3) + pad));
y2 = min(size(im, 1), round(box(4) + pad));

im = im(y1:y2, x1:x2, :);

offset(1) = x1 -1;
offset(2) = y1 -1;

function ShowKeypointNums(pts, color)
for i = 1 : size(pts, 1)
    text(pts(i, 1), pts(i, 2), num2str(i), 'Color', color, 'FontSize', 10);
end
