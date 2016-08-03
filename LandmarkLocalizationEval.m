function [errors, precision, recall] = LandmarkLocalizationEval( ...
    boxes, pts_name, occ_name, test, left_eye_inds, ....
    right_eye_inds, vis_subset)

gr_occ = [];
dt_occ = [];
errors = nan(length(test), 1);
for i = 1 : length(test)
    if isempty(boxes{i})
        errors(i) = nan;
        continue;
    end
    
    pts_gt = test(i).pts;
    % Computes the distance between the centers of the eyes.
    p1 = mean(pts_gt(left_eye_inds, :), 1);
    p2 = mean(pts_gt(right_eye_inds, :), 1);
    normalization_dist = norm(p1 - p2);
    
    b = boxes{i}(1);
    pts_det = getfield(b, pts_name);
    occ_det = getfield(b, occ_name);
    
    if size(pts_det, 1) ~= size(pts_gt, 1)
        warning('The numbers of keypoints are different!');
        errors(i) = nan;
        continue;
    end
    
    if vis_subset && isfield(test(i), 'occ')
        occ_gt = test(i).occ;
        pts_gt = pts_gt(occ_gt == 0, :);
        pts_det = pts_det(occ_gt == 0, :);
    end
    
    dif = pts_gt - pts_det;
    e = (dif(:,1) .^ 2 + dif(:,2) .^ 2) .^ 0.5;
    errors(i) = mean(e) / normalization_dist;
    
    if isfield(test(i), 'occ')
        occ_gt = test(i).occ;
        gr_occ = [gr_occ, occ_gt];
        dt_occ = [dt_occ, occ_det'];
    end
end

precision = 0;
recall = 0;
if(isfield(test(1), 'occ'))
    gr_occ = gr_occ(:);
    dt_occ = dt_occ(:);
    C = confusionmat(gr_occ, dt_occ);
    recall = C(2, 2) / sum(C(2, :)) * 100;
    precision = C(2, 2) / sum(C(:, 2)) * 100;
end
