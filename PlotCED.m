function PlotCED(errors, ave_errors, success_rate, precision, recall, method_names, eval_on_vis_keypoints)

figure; hold on; grid on;
colors = distinguishable_colors(length(method_names));
for i = 1 : length(method_names)
    [y, x] = ecdf(errors{i});
    plot(x, y, 'color', colors(i, :), 'linewidth', 2);
    method_names{i} = [method_names{i} sprintf(', %.4f%% [%.2f%%]', ave_errors{i}, success_rate{i})];
    if ~isnan(precision{i})
        method_names{i} = [method_names{i} sprintf(', Precision: %.2f%%, Recall: %.2f%%', precision{i}, recall{i})];
    end
end

fontsize = 10;
ylabel('Proportion of faces', 'fontsize', fontsize);
xlabel('Average localization error as fraction of interpupillary distance', 'fontsize', fontsize);
if eval_on_vis_keypoints
    title('Evaluation on only the visible keypoints');
else
    title('Evaluation on all the keypoints');
end

set(gca,'fontsize', fontsize);
set(gcf,'color', 'w')
legend(method_names, 'Location', 'SouthEast', 'FontSize', 8);
xlim([0 0.3]);

