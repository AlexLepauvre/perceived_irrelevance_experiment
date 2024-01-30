function [trial_mat] = prepare_log(trial_mat)
% This function adds column to the trial matrix for each event we might
% want to log:
trial_mat.texture(:) = nan;  % Texture being presented
trial_mat.vis_stim_time(:) = nan;  % Time stamp of the visual stimulus onset
trial_mat.time_of_resp_vis(:) = nan;  % Time stamp of response to visual stimulus
trial_mat.has_response_vis(:) = 0;  % Whether there was a response
trial_mat.trial_response_vis{1} = 'empty';  % Correctness of vis repsonse (hit, miss, ...)
trial_mat.fix_time(:) = nan;  % Time stamp of fixation onset
trial_mat.JitOnset(:) = nan;  % Time stamp of the jitter onset
trial_mat.trial_end(:) = nan;  % Time stamp of trial end
trial_mat.wrong_key(:) =  nan;  % Wrong key being pressed during the trial
trial_mat.wrong_key_timestemp(:) =  nan;  % Time stamp of wrong key press
trial_mat.orientation_probe_ts(:) = nan; % Time stamp of the orientation probe
trial_mat.orientation_probe_response(:) =  nan;  % Pressed key for the orientation probe
trial_mat.orientation_probe_accuracy(:) =  nan;  % Accuracy of orientation response
trial_mat.orientation_probe_rt(:) =  nan;  % Reaction time of orientation probe
trial_mat.duration_probe_ts(:) = nan; % Time stamp of the orientation probe
trial_mat.duration_probe_response(:) =  nan;  % Pressed key for the orientation probe
trial_mat.duration_probe_accuracy(:) =  nan;  % Accuracy of orientation response
trial_mat.duration_probe_rt(:) =  nan;  % Reaction time of orientation probe
end

