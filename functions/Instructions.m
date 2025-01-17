function [ ] = Instructions(instructions_ptr)
global RightKey LeftKey

% Setting the slide number to 1 to initiate the while loop
InstructionSlideNum = 1;
% displays all instruction screens
while InstructionSlideNum<= length(instructions_ptr) % Looping until we went through all slides:
    % Showing instruction slide
    showInstructions(instructions_ptr(InstructionSlideNum));
    WaitSecs(0.2);
    CorrectKey = 0; % Setting the CorrectKey to 0 to initiate the loop
    while ~CorrectKey % As long as a non-accepted key is pressed, keep on asking
        [~, ~, InstructionsResp] = KbCheck();
        if InstructionsResp(RightKey) % If the participant press the right key, increment by 1 the slide number
            InstructionSlideNum = InstructionSlideNum + 1;
            CorrectKey = 1;
        elseif InstructionsResp(LeftKey) % Else if the participant pressed the left key:
            if InstructionSlideNum == 1 % If we are at slide one, that doesn't work
                CorrectKey = 0;
            else % Otherwise, just go back one slide
                InstructionSlideNum = InstructionSlideNum - 1;
                CorrectKey = 1;
            end
        else
            CorrectKey = 0;
        end
    end
end
end
