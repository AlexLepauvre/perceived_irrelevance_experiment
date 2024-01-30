function [trial_mat] = prepare_log(trial_mat)
% This function adds column to the trial matrix for each event we might
% want to log:

%% Visual presentation log:
trial_mat.texture(:) = nan;  % Texture being presented
trial_mat.stimulus_onset_ts(:) = nan;  % Time stamp of the visual stimulus onset
trial_mat.fix_time(:) = nan;  % Time stamp of fixation onset
trial_mat.JitOnset(:) = nan;  % Time stamp of the jitter onset
trial_mat.trial_end(:) = nan;  % Time stamp of trial end

%% Response log:
trial_mat.response_flag(:) = nan;  % Whether there was a response
trial_mat.response_ts(:) = nan;  % Time stamp of response to visual stimulus
trial_mat.response_key(:) = 0;  % Whether there was a response
trial_mat.wrong_key(:) =  nan;  % Wrong key being pressed during the trial
trial_mat.hit(:) = nan;
trial_mat.cr(:) = nan;
trial_mat.miss(:) = nan;
trial_mat.fa(:) = nan;

%% Probes log:
trial_mat.orientation_probe_ts(:) = nan; % Time stamp of the orientation probe
trial_mat.orientation_probe_response(:) =  nan;  % Pressed key for the orientation probe
trial_mat.orientation_probe_accuracy(:) =  nan;  % Accuracy of orientation response
trial_mat.orientation_probe_rt(:) =  nan;  % Reaction time of orientation probe
trial_mat.duration_probe_ts(:) = nan; % Time stamp of the orientation probe
trial_mat.duration_probe_response(:) =  nan;  % Pressed key for the orientation probe
trial_mat.duration_probe_accuracy(:) =  nan;  % Accuracy of orientation response
trial_mat.duration_probe_rt(:) =  nan;  % Reaction time of orientation probe
end

