function [stimuliTiming, correct_key] = showDurationProbe(target_duration)
global PHOTODIODE
global stimSizeLength stimSizeHeight % texture
global gray w center  originalHeight originalWidth LeftKey LeftKey_text RightKey RightKey_text SHORT_TEXT LONG_TEXT
global DURATION_PROBE_TEXT

% Fill background with gray:
Screen('FillRect', w, gray);

% Set stimuli positions:
stimSizeLength = round((stimSizeHeight/originalHeight) * originalWidth);
margin = stimSizeLength * 2; % Adjust the margin between stimuli as needed

% Set the stimuli positions:
left_sx = center(1) - margin / 2 - stimSizeLength;
right_sx = center(1) + margin/2;
sy = center(2);

% Randomly alternate between the target being presented left or right:
if randi([1, 2]) == 1
    DrawFormattedText(w, textProcess(SHORT_TEXT), left_sx, sy);
    DrawFormattedText(w, textProcess(LONG_TEXT), right_sx, sy);
    if target_duration == 0.5
        correct_key = LeftKey;
    else
        correct_key = RightKey;
    end
else
    DrawFormattedText(w, textProcess(LONG_TEXT), left_sx, sy);
    DrawFormattedText(w, textProcess(SHORT_TEXT), right_sx, sy);
    if target_duration == 0.5
        correct_key = RightKey;
    else
        correct_key = LeftKey;
    end
end

% Draw the text:
text_padding = 200;
sy = sy + stimSizeHeight + text_padding;
% Left key instructions:
DrawFormattedText(w, textProcess(LeftKey_text), left_x, sy);
% Right key instructions:
DrawFormattedText(w, textProcess(RightKey_text), right_x, sy);
% Probe instructions:
DrawFormattedText(w, textProcess(DURATION_PROBE_TEXT), 'center');
if PHOTODIODE
    drawPhotodiodBlock('on');
end
drawFixation()
[~, stimuliTiming] = Screen('Flip', w, [], 1);
end

