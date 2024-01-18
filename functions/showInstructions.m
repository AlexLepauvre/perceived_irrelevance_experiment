
%SHOWINSTRUCTIONS - presents the instructions slide
% input:
% ------
% background - the pointer to the instructions image

function [ ] = showInstructions(ptr)

    global gray w ScreenWidth ScreenHeight PHOTODIODE;
    Screen('FillRect', w, gray);

    % Draw instructions:
    Screen('DrawTexture',w, ptr, [], [0 0 ScreenWidth ScreenHeight]);
    if PHOTODIODE
            drawPhotodiodBlock('off')
    end
    % Show the instructions:
    Screen('Flip', w);
end
