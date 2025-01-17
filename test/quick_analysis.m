% this function makes a quick analysisfor a single subject of the
% reconstructed time prp task. As inout it recieves the subject number, the
% sessions and the task type. It returns a structure that contains the
% performances and some controls for the presentation of the stimuli

function [output_struct,refRate] = quick_analysis(subjectNum, session, task, plotting)

if nargin<2
    session = 1;
    task = 'prp';
    plotting = 0;
elseif nargin<3
    task = 'prp';
    plotting = 0;
elseif nargin<4
    plotting = 0;
end
%%
global DATA_FOLDER LAB_ID refRate
if isempty(DATA_FOLDER); DATA_FOLDER = 'data'; end
if isempty(LAB_ID); LAB_ID = 'SX'; end
if isempty(refRate); refRate = 1/60; end

% make SUB_ID
subID = sprintf('%s%d', LAB_ID, subjectNum);

% make file name
mydir  = pwd;
idcs   = strfind(mydir,'\');
parent_dir = mydir(1:idcs(end)-1);
filename = string(fullfile(parent_dir,DATA_FOLDER,['sub-', subID],['ses-',num2str(session)],...
    ['sub-', subID,'_ses-',num2str(session),'_run-all_task-', task,'_events.mat']));

event_table = load(filename);

try
    event_table = event_table.input_table;
catch
    event_table = event_table.d;
end

if ~ ismember('RT_aud', event_table.Properties.VariableNames)
    % Add functions folder to path (when we separate all functions)
    function_folder = [parent_dir,filesep,'functions\'];
    addpath(function_folder)

    [event_table, ~] = compute_performance(event_table);

end

% remove targets and practice
practice_event_table = event_table(event_table.is_practice == 1, :);
full_event_table = event_table;
event_table = event_table(~strcmp(event_table.task_relevance, 'target') & ~event_table.is_practice,:);

%% performances

% performanance
output_struct.hits = sum(strcmp(full_event_table.trial_response_vis, 'hit'));
output_struct.misses = sum(strcmp(full_event_table.trial_response_vis, 'miss'));
output_struct.crs = sum(strcmp(full_event_table.trial_response_vis, 'cr'));
output_struct.fas = sum(strcmp(full_event_table.trial_response_vis, 'fa'));

% check if participant inclusion critera are violated
if output_struct.hits/output_struct.misses < 4 
    warning('less then 80 % hits')
elseif output_struct.crs/output_struct.fas < 4
    warning('more than 20 % false alarms')
else 
    display('No includsion criterion violated')
end 

output_struct.mean_aud_acc = mean(event_table.trial_accuracy_aud, 'omitnan');

% split by category

cates = {'face','object','letter','false_font'};
for cate = 1:4

    output_struct.cate_hits(cate) = sum(strcmp(full_event_table.trial_response_vis, 'hit') & strcmp(full_event_table.category, cates{cate}));
    output_struct.cate_misses(cate) = sum(strcmp(full_event_table.trial_response_vis, 'miss') & strcmp(full_event_table.category, cates{cate}));
    output_struct.cate_crs(cate) = sum(strcmp(full_event_table.trial_response_vis, 'cr') & strcmp(full_event_table.category, cates{cate}));
    output_struct.cate_fas(cate) = sum(strcmp(full_event_table.trial_response_vis, 'fa') & strcmp(full_event_table.category, cates{cate}));

    % auditory accuracy
    output_struct.mean_aud_acc_cate(cate) = mean(event_table.trial_accuracy_aud(strcmp(event_table.category, cates{cate})), 'omitnan');

    % reaction time
    output_struct.mean_RT_aud_cate(cate) = mean(event_table.RT_aud(strcmp(event_table.category, cates{cate})), 'omitnan');

end

% split by picht

pitches = [1000, 1100];
for pitch = 1:2

    output_struct.pitch_hits(pitch) = sum(strcmp(full_event_table.trial_response_vis, 'hit') & full_event_table.pitch == pitches(pitch));
    output_struct.pitch_misses(pitch) = sum(strcmp(full_event_table.trial_response_vis, 'miss') & full_event_table.pitch == pitches(pitch));
    output_struct.pitch_crs(pitch) = sum(strcmp(full_event_table.trial_response_vis, 'cr') & full_event_table.pitch == pitches(pitch));
    output_struct.pitch_fas(pitch) = sum(strcmp(full_event_table.trial_response_vis, 'fa') & full_event_table.pitch == pitches(pitch));

    % auditory accuracy
    output_struct.mean_aud_acc_pitch(pitch) = mean(event_table.trial_accuracy_aud(event_table.pitch == pitches(pitch)), 'omitnan');

    % reaction time
    output_struct.mean_RT_aud_pitch(pitch) = mean(event_table.RT_aud(event_table.pitch == pitches(pitch)), 'omitnan');

end


%% reaction time

% reaction time
output_struct.mean_RT_aud = mean(event_table.RT_aud, 'omitnan');

% split by SOA and SOA lock
output_struct.RT_aud_off(1) = mean(event_table.RT_aud(event_table.SOA == 0 & strcmp(event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.RT_aud_off(2) = mean(event_table.RT_aud(event_table.SOA == 0.116 & strcmp(event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.RT_aud_off(3) = mean(event_table.RT_aud(event_table.SOA == 0.232 & strcmp(event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.RT_aud_off(4) = mean(event_table.RT_aud(event_table.SOA == 0.466 & strcmp(event_table.SOA_lock, 'offset')), 'omitnan');

output_struct.RT_aud_on(1) = mean(event_table.RT_aud(event_table.SOA == 0 & strcmp(event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.RT_aud_on(2) = mean(event_table.RT_aud(event_table.SOA == 0.116 & strcmp(event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.RT_aud_on(3) = mean(event_table.RT_aud(event_table.SOA == 0.232 & strcmp(event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.RT_aud_on(4) = mean(event_table.RT_aud(event_table.SOA == 0.466 & strcmp(event_table.SOA_lock, 'onset')), 'omitnan');

% split by task relevnace

% task relevant
relevant_event_table = event_table(strcmp(event_table.task_relevance, 'non-target'),:);

output_struct.task_relevant.RT_aud_off(1) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0 & strcmp(relevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_relevant.RT_aud_off(2) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.116 & strcmp(relevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_relevant.RT_aud_off(3) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.232 & strcmp(relevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_relevant.RT_aud_off(4) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.466 & strcmp(relevant_event_table.SOA_lock, 'offset')), 'omitnan');

output_struct.task_relevant.RT_aud_on(1) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0 & strcmp(relevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_relevant.RT_aud_on(2) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.116 & strcmp(relevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_relevant.RT_aud_on(3) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.232 & strcmp(relevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_relevant.RT_aud_on(4) = mean(relevant_event_table.RT_aud(relevant_event_table.SOA == 0.466 & strcmp(relevant_event_table.SOA_lock, 'onset')), 'omitnan');


% task irrelevant
irrelevant_event_table = event_table(strcmp(event_table.task_relevance, 'irrelevant'),:);

output_struct.task_irrelevant.RT_aud_off(1) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0 & strcmp(irrelevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_off(2) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.116 & strcmp(irrelevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_off(3) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.232 & strcmp(irrelevant_event_table.SOA_lock, 'offset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_off(4) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.466 & strcmp(irrelevant_event_table.SOA_lock, 'offset')), 'omitnan');

output_struct.task_irrelevant.RT_aud_on(1) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0 & strcmp(irrelevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_on(2) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.116 & strcmp(irrelevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_on(3) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.232 & strcmp(irrelevant_event_table.SOA_lock, 'onset')), 'omitnan');
output_struct.task_irrelevant.RT_aud_on(4) = mean(irrelevant_event_table.RT_aud(irrelevant_event_table.SOA == 0.466 & strcmp(irrelevant_event_table.SOA_lock, 'onset')), 'omitnan');


%% controls

% control stim duration
output_struct.real_dur = event_table.fix_time - event_table.vis_stim_time;
output_struct.dur_diff = output_struct.real_dur - event_table.duration;
output_struct.dur_diff_max = max(output_struct.dur_diff);
output_struct.dur_diff_mean = mean(output_struct.dur_diff);

% check currect frames
output_struct.correct_frame = sum(output_struct.dur_diff < (0.5*refRate) & output_struct.dur_diff > (-0.5*refRate));
output_struct.one_frame_late = sum(output_struct.dur_diff > (0.5*refRate) & output_struct.dur_diff < (1.5*refRate));
output_struct.two_frames_late = sum(output_struct.dur_diff > (1.5*refRate) & output_struct.dur_diff < (2.5*refRate));
output_struct.three_frames_late = sum(output_struct.dur_diff > (2.5*refRate) & output_struct.dur_diff < (3.5*refRate));
output_struct.one_frame_early = sum(output_struct.dur_diff < (-0.5*refRate) & output_struct.dur_diff > (-1.5*refRate));
output_struct.two_frames_early = sum(output_struct.dur_diff < (-1.5*refRate) & output_struct.dur_diff > (-2.5*refRate));
output_struct.three_frames_early = sum(output_struct.dur_diff < (-2.5*refRate) & output_struct.dur_diff > (-3.5*refRate));


% control SOA
output_struct.real_SOA = event_table.aud_stim_time - event_table.vis_stim_time;
output_struct.SOA_diff = output_struct.real_SOA - event_table.onset_SOA;
output_struct.SOA_diff_max = max(output_struct.SOA_diff);
output_struct.SOA_diff_min = min(output_struct.SOA_diff);
output_struct.SOA_diff_mean = mean(output_struct.SOA_diff);

% control trial duration
output_struct.trial_durs = event_table.JitOnset - event_table.vis_stim_time;
output_struct.trial_dur_mean = mean(event_table.JitOnset - event_table.vis_stim_time);

output_struct.real_trial_durs_plus_jitter = event_table.trial_end - event_table.vis_stim_time;
output_struct.real_trial_dur_mean_plus_jitter = mean(output_struct.real_trial_durs_plus_jitter);
output_struct.target_trial_durs_plus_jitter = 2 + event_table.stim_jit;
output_struct.diff_trial_durs_plus_jitter = output_struct.real_trial_durs_plus_jitter - output_struct.target_trial_durs_plus_jitter;

%% performance table
perf_table = table('RowNames', {'hits', 'misses', 'cr', 'fas', 'aud_acc', 'mean_RT_aud'});

perf_table.all = [output_struct.hits, output_struct.misses, output_struct.crs,...
    output_struct.fas, output_struct.mean_aud_acc, output_struct.mean_RT_aud]';

for cate = 1:4
    perf_table.(cates{cate})(:) = [output_struct.cate_hits(cate), output_struct.cate_misses(cate), output_struct.cate_crs(cate),...
        output_struct.cate_fas(cate), output_struct.mean_aud_acc_cate(cate), output_struct.mean_RT_aud_cate(cate)]';
end

pitches = {'low','high'};
for pitch = 1:2
    perf_table.(pitches{pitch})(:) = [output_struct.pitch_hits(pitch), output_struct.pitch_misses(pitch), output_struct.pitch_crs(pitch),...
        output_struct.pitch_fas(pitch), output_struct.mean_aud_acc_pitch(pitch), output_struct.mean_RT_aud_pitch(pitch)]';
end

% save table
test_data_dir = fullfile(mydir,'test_data',['sub-', subID],['ses-',num2str(session)]);

if ~exist(test_data_dir, 'dir')
    mkdir(test_data_dir);
end

perf_table_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_performance.csv']));
writetable(perf_table, perf_table_filename);
%% timing control

% timing control table
output_timing_table = table;
output_timing_table.real_dur = output_struct.real_dur;
output_timing_table.target_dur = event_table.duration;
output_timing_table.dur_diff = output_struct.dur_diff;
output_timing_table.real_SOA = output_struct.real_SOA;
output_timing_table.target_SOA = event_table.onset_SOA;
output_timing_table.SOA_diff = output_struct.SOA_diff;
output_timing_table.trial_dur = output_struct.trial_durs;
output_timing_table.real_trial_dur_plus_jitter = output_struct.real_trial_durs_plus_jitter;
output_timing_table.taregt_trial_dur_plus_jitter = output_struct.target_trial_durs_plus_jitter;
output_timing_table.diff_trial_dur_plus_jitter = output_struct.diff_trial_durs_plus_jitter;

timing_output_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_test_timing.csv']));
writetable(output_timing_table, timing_output_filename);

%% plotting

if plotting

    SOAs = [0, 0.116, 0.232, 0.466];


    %
    %     figure(1)
    %     prp_effect = tiledlayout(1,3);
    %     nexttile
    %     title('task relevant and irrelevant')
    %     hold on
    %     plot(SOAs*1000,output_struct.RT_aud_on*1000, 'b')
    %     plot(SOAs*1000,output_struct.RT_aud_off*1000, 'r')
    %     ylim([400, 800])
    %     ylabel('Auditory reaction time [ms]')
    %     xlabel('SOA [ms]')
    %     hold off
    %
    %     nexttile
    %     title('task relevant')
    %     hold on
    %     plot(SOAs*1000,output_struct.task_relevant.RT_aud_on*1000, 'b')
    %     plot(SOAs*1000,output_struct.task_relevant.RT_aud_off*1000, 'r')
    %     ylim([400, 800])
    %     ylabel('Auditory reaction time [ms]')
    %     xlabel('SOA [ms]')
    %     hold off
    %
    %     nexttile
    %     title('task irrelevant')
    %     hold on
    %     plot(SOAs*1000,output_struct.task_irrelevant.RT_aud_on*1000, 'b')
    %     plot(SOAs*1000,output_struct.task_irrelevant.RT_aud_off*1000, 'r')
    %     ylim([400, 800])
    %     ylabel('Auditory reaction time [ms]')
    %     xlabel('SOA [ms]')
    %     hold off
    %
    %     lgd = legend('onset', 'offset');
    %     lgd.Layout.Tile = 'east';

    %% timing plots
    figure(2)
    histogram(output_struct.dur_diff, [-3.5*refRate, -2.5*refRate, -1.5*refRate, -0.5*refRate, ...
        0.5*refRate, 1.5*refRate, 2.5*refRate, 3.5*refRate]);
    ylim([0, length(output_struct.dur_diff) + 50])
    title(['Jitter in visual stimulus duration (Refresh rate: ', num2str(refRate), ' s)'])
    ylabel('Number of trials')
    xlabel('Frames off')

    h1 = gca;
    h1.XTick = [-3*refRate, -2*refRate, -refRate, 0, refRate, 2*refRate, 3*refRate];
    h1.XTickLabel = ["-3", "-2", "-1", "0", "+1", "+2", "+3"];

    fig_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_duration_jitter.fig']));
    saveas(h1,fig_filename)
    png_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_duration_jitter.png']));
    saveas(h1,png_filename)

    figure(3)
    histogram(output_struct.SOA_diff*1000);
    title('Jitter in SOA')
    ylabel('Number of trials')
    xlabel('ms off')

    h2 = gca;
    fig_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_all_SOA_jitter.fig']));
    saveas(h2,fig_filename)
    png_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_all_SOA_jitter.png']));
    saveas(h2,png_filename)

    figure(4)
    single_soas = tiledlayout(2,2);
    nbins = 8;
    for sub_plot = 1:4
        nexttile

        onset_data = (output_struct.SOA_diff(event_table.SOA == SOAs(sub_plot) & strcmp(event_table.SOA_lock, 'onset')))*1000;
        offset_data = (output_struct.SOA_diff(event_table.SOA == SOAs(sub_plot) & strcmp(event_table.SOA_lock, 'offset')))*1000;
        plot_data = nan(length(offset_data)*2, 2);
        plot_data(1:length(onset_data),1) = onset_data;
        plot_data(1:length(offset_data),2) = offset_data;
        hist(plot_data,nbins);
        title(['SOA: ', num2str(SOAs(sub_plot)), ' ms'])
        ylabel('Number of trials')
        xlabel('ms off')
    end

    lgd = legend('offset', 'onset');
    lgd.Layout.Tile = 'east';

    fig_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_single_SOAs_jitter.fig']));
    saveas(single_soas,fig_filename)
    png_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_single_SOAs_jitter.png']));
    saveas(single_soas,png_filename)

    %% performance plots
    figure(5)
    rot_table = rows2vars(perf_table);
    perf_plots = tiledlayout(2,2);

    nexttile
    title('Misses and False Alarms')
    bar([rot_table.fas,rot_table.misses])
    set(gca,'XTickLabel', rot_table.OriginalVariableNames)
    legend('false alarms', 'misses','Location','southoutside')
    ylabel('Counts')

    nexttile
    title('Hits and correct rejects')
    bar([rot_table.hits,rot_table.cr])
    set(gca,'XTickLabel', rot_table.OriginalVariableNames)
    legend('hits', 'correct rejects','Location','southoutside')
    ylabel('Counts')

    nexttile
    title('Accuracy')
    bar(rot_table.aud_acc)
    set(gca,'XTickLabel', rot_table.OriginalVariableNames)
    ylim([0.7,1])
    ylabel('mean auditory accuracy')

    nexttile
    title('Reaction time')
    bar((rot_table.mean_RT_aud)*1000)
    set(gca,'XTickLabel', rot_table.OriginalVariableNames)
    ylim([400,900])
    ylabel('mean auditory reaction time [ms]')

    fig_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_performance.fig']));
    saveas(perf_plots,fig_filename)
    png_filename = string(fullfile(test_data_dir, ['sub-', subID,'_ses-',num2str(session),'_', task,'_performance.png']));
    saveas(perf_plots,png_filename)

end


end