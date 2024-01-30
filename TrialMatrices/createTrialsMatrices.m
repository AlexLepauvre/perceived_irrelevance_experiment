clear all
%% Set constant parameters:
n_subjects_per_cond = 10;
lab_id = "SX";

% Set all the conditions:
conditions = ['task_relevance', 'duration', 'category', 'orientation'];
% Create a structure storing the levels of each of these conditions:
conditions_levels = struct(...
    'task_relevance', ["target", "non-target", "irrelevant"],...
    'duration', [0.500, 1.500], ...
    'category', ["face", "object"], ...
    'orientation', ["center", "left", "right"], ...
    'identity', ["_01", "_02", "_03", "_04", "_05", "_06", ...
    "_07", "_08", "_09", "_10", "_11", "_12", "_13", "_14",...
    "_15", "_16", "_17", "_18", "_19", "_20"]);
% Additional timing parameters:
trial_duration = 2;
surprise_trial_interval = 0.5;
jitter_mean = 1;
jitter_min = 0.7;
jitter_max = 2;
exp_dist = makedist("Exponential", "mu", jitter_mean);
jitter_distribution = truncate(exp_dist, jitter_min, jitter_max);

% Surprise trials parameters:
surprise_trials.face = ["face_01", "face_02"];
surprise_trials.object = ["object_01", "object_02"];

% Pre-surprise parameters:
n_trials_per_cell = 3;
n_targets = 2;
n_target_trials = 6;

%% Surprise trials:
subject_i = 1;
surprise_trial_tables = struct();
for i = 1:n_subjects_per_cond
    for cate_i = 1:numel(conditions_levels.category)
        for task_rel = 1:numel(conditions_levels.task_relevance)
            for dur_i = 1:numel(conditions_levels.duration)
                for ori_i = 1:numel(conditions_levels.orientation)
                    for identity_i = 1:numel(surprise_trials.(conditions_levels.category(cate_i)))
                        % Prepare all the data for the table:
                        sub_id =  sprintf("%s%d", lab_id, 100 + subject_i);
                        task = conditions_levels.category(cate_i) + "surprise";
                        is_practice = false;
                        target_01 = nan;
                        target_02 = nan;
                        stim_jitter = 0.5;
                        task_relevance = conditions_levels.task_relevance(task_rel);
                        duration = conditions_levels.duration(dur_i);
                        category = conditions_levels.category(cate_i);
                        orientation = conditions_levels.orientation(ori_i);
                        identity = surprise_trials.(conditions_levels.category(cate_i))(identity_i);
                        critical_trial = true;
                        % Create this subject's surprise table:
                        tbl = table(sub_id, task, is_practice, target_01, target_02, task_relevance, category, orientation, identity, duration, trial_duration, stim_jitter, critical_trial, surprise_trial_interval,...
                            'VariableNames', ["sub_id", "task", "is_practice", "target_01", "target_02", "task_relevance", ...
                            "category", "orientation","identity", "duration", "trial_duration", "stim_jit", "critical_trial", "surprise_trial_interval"]);
                        surprise_trial_tables.(sub_id) = tbl;
                        subject_i = subject_i + 1;
                    end
                end
            end
        end
    end
end

%% Pre-surprise trials:
subjects_ids = fieldnames(surprise_trial_tables);
subjects_tables = struct();
% Loop through each subject:
for subject_i = 1:numel(subjects_ids)
    % Get the sub id:
    sub_id = subjects_ids{subject_i};
    % Extract the subject's surprise table:
    surp_trial = surprise_trial_tables.(sub_id);

    % Figure out task relevance condition:
    if strcmp(surp_trial.task_relevance, "target") || strcmp(surp_trial.task_relevance, "non-target")
        task_rel_cate = surp_trial.category;
        task_irrel_cate = conditions_levels.category(~strcmp(conditions_levels.category, surp_trial.category));
    else
        task_irrel_cate = surp_trial.category;
        task_rel_cate = conditions_levels.category(~strcmp(conditions_levels.category, surp_trial.category));
    end

    % Create stimuli pools to avoid  that the stimuli repeat themselves:
    stimuli_pool.face = conditions_levels.identity;
    stimuli_pool.object = conditions_levels.identity;

    % Randomly fetch the two targets from the relevant pool:
    if strcmp(surp_trial.task_relevance, "target")
        targets_inds = randperm(numel(stimuli_pool.(task_rel_cate)), n_targets - 1);
        targets_id = [surp_trial.identity, strcat(task_rel_cate, stimuli_pool.(task_rel_cate)(targets_inds))];
        % Delete from the pool:
        stimuli_pool.(task_rel_cate)(targets_inds) = [];
    else
        targets_inds = randperm(numel(stimuli_pool.(task_rel_cate)), n_targets);
        targets_id = strcat(task_rel_cate, stimuli_pool.(task_rel_cate)(targets_inds));
        % Delete from the pool:
        stimuli_pool.(task_rel_cate)(targets_inds) = [];
    end
    % Add the targets to the surprise trials:
    surp_trial.target_01 = targets_id(1);
    surp_trial.target_02 = targets_id(2);

    % Create the non target trials:
    non_target_table = table();
    for cate_i = 1:numel(conditions_levels.category)
        for dur_i = 1:numel(conditions_levels.duration)
            for ori_i = 1:numel(conditions_levels.orientation)
                for i = 1:n_trials_per_cell
                    % Extract the variables:
                    cate = conditions_levels.category(cate_i);
                    dur = conditions_levels.duration(dur_i);
                    ori = conditions_levels.orientation(ori_i);
                    % Randomly fetch 1 identity from the category stimulus
                    % pool:
                    ind = randperm(numel(stimuli_pool.(cate)), 1);
                    stim_id = strcat(cate, stimuli_pool.(cate)(ind));
                    % Delete from the array
                    stimuli_pool.(cate)(ind) = [];

                    % Fetch jitter:
                    trial_jitter = random(jitter_distribution, 1, 1);

                    % Figure out the task relevance of this trial:s
                    if cate == task_rel_cate
                        task_relevance = "non-target";
                    else
                        task_relevance = "irrelevant";
                    end

                    % Get additional info:
                    task = surp_trial.task;
                    is_practice = false;
                    critical_trial = false;
                    tbl = table({sub_id}, task, is_practice, targets_id(1), targets_id(2), task_relevance, cate, ori, stim_id, dur, trial_duration, trial_jitter, critical_trial, surprise_trial_interval,...
                        'VariableNames', ["sub_id", "task", "is_practice", "target_01", "target_02", "task_relevance", ...
                        "category", "orientation","identity", "duration", "trial_duration", "stim_jit", "critical_trial", "surprise_trial_interval"]);
                    non_target_table = [non_target_table; tbl];
                end
            end
        end
    end

    % Create the target trials:
    % Create the pull of target identities to ensure that each target is
    % shown equally often:
    n_trial_per_id = n_target_trials / n_targets;
    targets_pull = repmat(targets_id, n_trial_per_id, 1);
    targets_table = table();
    while ~isempty(targets_pull)
        for dur_i = 1:numel(conditions_levels.duration)
            for ori_i = 1:numel(conditions_levels.orientation)
                % Randomly pick on target:
                target_ind = randperm(numel(targets_pull), 1);
                target_id = targets_pull(target_ind);
                targets_pull(target_ind) = [];

                % Get trial parameters:
                cate = split(target_id, "_");
                cate = cate(1);
                dur = conditions_levels.duration(dur_i);
                ori = conditions_levels.orientation(ori_i);
                trial_jitter = random(jitter_distribution, 1, 1);
                task_relevance = "target";
                task = surp_trial.task;
                is_practice = false;
                critical_trial = false;
                tbl = table({sub_id}, task, is_practice, targets_id(1), targets_id(2), task_relevance, cate, ori, target_id, dur, trial_duration, trial_jitter, critical_trial, surprise_trial_interval,...
                    'VariableNames', ["sub_id", "task", "is_practice", "target_01", "target_02", "task_relevance", ...
                    "category", "orientation","identity", "duration", "trial_duration", "stim_jit", "critical_trial", "surprise_trial_interval"]);
                targets_table = [targets_table; tbl];
            end
        end
    end

    % Combine the target with the rest:
    pre_surprise_table = [non_target_table; targets_table];
    % Randomize the order:
    pre_surprise_table = pre_surprise_table(randperm(height(pre_surprise_table)), :);
    % Combine with surprise trial:
    subject_table = [pre_surprise_table; surp_trial];
    % Add a column for trial number and block:
    subject_table = addvars(subject_table, ones(height(subject_table), 1), (1:height(subject_table))', 'NewVariableNames', {'block', 'trial'}, 'Before', 4);
    % Add the surprise trial at the end:
    subjects_tables.(sub_id) = subject_table;
end

%% Save the tables
% Here there is the added twist that we are generating different streams of
% subjects ID for each task separately. Easier to handle when we run the
% task:
subjects_ids = fieldnames(subjects_tables);
new_sub_ids.facesurprise = 101;
new_sub_ids.objectsurprise = 1001;
for subject_i = 1:numel(subjects_ids)
    % Get the sub id:
    sub_id = subjects_ids{subject_i};
    
    % Get this subject's table:
    subject_table = subjects_tables.(sub_id);
    % Extract the task of this subject:
    subject_task = subject_table.task(1);

    % Get the new subject id:
    new_subid = sprintf("%s%d", lab_id, new_sub_ids.(subject_task));
    subject_table.sub_id(:) = new_subid;
    new_sub_ids.(subject_task) = new_sub_ids.(subject_task) + 1;

    % Save the subject's table:
    file_name = fullfile(pwd, sprintf("sub-%s_task-%s_trials.csv", new_subid, task));
    writetable(subject_table, file_name);
end