function [stimuliTiming, correct_key] = showOrientationProbe(target_id, target_ori, orientations)
global PHOTODIODE
global stimSizeLength stimSizeHeight % texture
global gray w center  originalHeight originalWidth LeftKey LeftKey_text RightKey RightKey_text 
global ORIENTATION_PROBE_TEXT

% Fill background with gray:
Screen('FillRect', w, gray);

% Get the two textures:
texture1 = getPointer(target_id, target_ori);
% Get one of the remaining orientations:
ori_left = orientations(~strcmp(orientations, target_ori));
distractor_ori = ori_left(randperm(numel(ori_left), 1));
texture2 = getPointer(target_id, distractor_ori{1});

% Set stimuli positions:
stimSizeLength = round((stimSizeHeight/originalHeight) * originalWidth);
margin = stimSizeLength * 2; % Adjust the margin between stimuli as needed

% Set the stimuli positions:
left_x = center(1) - margin / 2 - stimSizeLength;
right_x = center(1) + margin/2;
y = center(2) - stimSizeHeight/2;
left_pos = [right_x, y , right_x + stimSizeLength, y + stimSizeHeight];
right_pos = [right_x, y , right_x + stimSizeLength, y + stimSizeHeight];

% Randomly alternate between the target being presented left or right:
if randi([1, 2]) == 1
    % Draw the first texture:
    Screen('DrawTexture',w, texture1,[],round(left_pos));
    % Draw the second texture:
    Screen('DrawTexture',w, texture2,[],round(right_pos));
    correct_key = LeftKey;
else
    % Draw the first texture:
    Screen('DrawTexture',w, texture2,[],round(left_pos));
    % Draw the second texture:
    Screen('DrawTexture',w, texture1,[],round(right_pos));
    correct_key = RightKey;
end

% Draw the text:
text_padding = 100;
sy = y + stimSizeHeight + text_padding;
% Left key instructions:
DrawFormattedText(w, textProcess(LeftKey_text), left_x, sy);
% Right key instructions:
DrawFormattedText(w, textProcess(RightKey_text), right_x, sy);
% Probe instructions:
DrawFormattedText(w, textProcess(ORIENTATION_PROBE_TEXT), 'center');
if PHOTODIODE
    drawPhotodiodBlock('on');
end
drawFixation()
[~, stimuliTiming] = Screen('Flip', w, [], 1);
end

