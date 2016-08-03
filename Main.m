function Main(file_name, method_name)

%addpath ~/export_fig/
close all;

% Normalizing errors with respect to the distance between the center of eyes.
% Indexes of eyes keypoints in the ground-truth.
left_eye_inds = 37 : 42;
right_eye_inds = 43 : 48;

cofw_test_images_dir = 'COFW68_Data/test_annotations/';
cofw_test_data_file = 'COFW68_Data/COFW_test.mat';
test_data_path = 'COFW68_Data/data.mat';
try
    load([test_data_path]);
catch
    test = ReadCofw68Data(cofw_test_data_file, cofw_test_images_dir);
    save([test_data_path], 'test');
end

file_names = cell(1, 0);
method_names = cell(1, 0);

% Golnaz Ghiasi, Charless Fowlkes,
% Occlusion Coherence: Detecting and Localizing Occluded Faces, arXiv:1506.08347, 2015
file_names{end+1} = 'Results/HPM_HelenLfpw_COFW68test.txt';
method_names{end+1} = 'HPM(HELEN,LFPW)';

% Ghiasi G, Fowlkes CC, Using segmentation to predict the absence of occluded parts, BMVC 2015
file_names{end+1} = 'Results/SDM_COFW68.txt';
method_names{end+1} = 'SDM(HELEN)';

% Zhu, Shizhan and Li, Cheng and Loy, Chen Change and Tang, Xiaoou,
% Face Alignment by Coarse-to-Fine Shape Searching, CVPR 2015
file_names{end+1} = 'Results/CFSS_CFOW68.txt';
method_names{end+1} = 'CFSS(HELEN,LFPW,AFW)';

% Zhanpeng Zhang, Ping Luo, Chen Change Loy, Xiaoou Tang
% Learning Deep Representation for Face Alignment with Auxiliary Attributes, PAMI 2016
file_names{end+1} = 'Results/TCDCN_CFOW68.txt';
method_names{end+1} = 'TCDCN(HELEN,LFPW,AFW,MAFL)';

% X. P. Burgos-Artizzu, P. Perona and P. DollárA, Robust face landmark estimation under occlusion, ICCV 2013
file_names{end+1} = 'Results/RCPR-occ_300w.txt';
method_names{end+1} = 'RCPR-occ(HELEN,LFPW)';

% Add other methods here.
% file_names{end+1} = 'address of the detection info file';
% method_names{end+1} = 'name of the method';

% Adds the results of the input (if exists).
if(exist('file_name', 'var'))
    file_names{end+1} = file_name;
    method_names{end+1} = method_name;
end

max_to_show = 20;
crop_images = true;
show_groundtruth = true;
show_keypoint_num = 0;
draw_line_between_gt_det = true;
vis_predictions = false;
if vis_predictions
    visdir = 'vis';
    if ~exist(visdir, 'dir')
        mkdir(visdir);
    end
end

for eval_on_vis_keypoints = 0 : 1
    for i = 1 : length(file_names)
        fprintf('Reading detection results of "%s" from "%s".\n', ...
            method_names{i}, file_names{i});
        boxes = ReadDetectionResults(file_names{i});
        
        fprintf('Evaluating ...\n');
        [errors{i}, precision{i}, recall{i}] = LandmarkLocalizationEval( ...
            boxes, 'pts68', 'occ68', test, left_eye_inds, right_eye_inds, eval_on_vis_keypoints);
        
        % Prints results.
        ave_errors{i} = nanmean(errors{i});
        success_rate{i} = sum(errors{i} <= 0.1) / length(errors{i}) * 100;
        fprintf('Average Error: %.4f, Success rate(at the thresh 0.1): %.2f%% ', ave_errors{i}, success_rate{i});
        fprintf('(normalized by the distance between the centers of eyes)\n');
        fprintf('recall: %.3f precision %.3f\n', recall{i}, precision{i});
        fprintf('number of nan: %d\n', sum(isnan(errors{i})));
        
        % Visualize predictions
        if vis_predictions && eval_on_vis_keypoints == 0
            VisualizeLocalizationRes(boxes, 'pts68', 'occ68', test, 'cofw_68test_vis', ...
                visdir, crop_images, show_groundtruth, show_keypoint_num, ...
                errors{i}, draw_line_between_gt_det, method_names{i}, max_to_show);
        end
    end
    PlotCED(errors, ave_errors, success_rate, precision, recall, method_names, eval_on_vis_keypoints);
    %export_fig(['COFW68_vis' num2str(eval_on_vis_keypoints) '_CED'], '-pdf');
end

