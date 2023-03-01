
% GETINPUT a single iteration of input seeking, returns the RT and address of key pressed
% Input:
% PauseTime: the duration of the pause when pressing the Q key. This needs
% to be passed on as input and is then given back as output. The reason is
% that the getInput is always called when participant don't answer. We
% don't want the pause to be counted as response, so if we don't pass it on, it will be reinitialize everytime! 
% output:
% -------
% key - the identity of the key pressed by the user
% Resp_Time - the RT of the user's key press
% PauseTime - If the pause key is pressed, the duration of the pause is
% recorded to make sure we account for it when starting again!
function [ key, Resp_Time,PauseTime ] = getInput(PauseTime)

global compKbDevice abortKey PauseKey RestartKey RESPONSE_KEY TARGET_KEY WRONG_KEY NO_KEY RESTART_KEY ABORT_KEY upKey
key = NO_KEY;

[KeyIsDown, Resp_Time, Resp1] = KbCheck(compKbDevice);

if KeyIsDown
    if Resp1(abortKey)
        key = ABORT_KEY;
        % cleanExit();
    elseif Resp1(RESPONSE_KEY)
        key = TARGET_KEY;
    elseif Resp1(PauseKey)
        key = NO_KEY; % We don't want the pause to be logged as a response, because it is not a response
        % Loop until the experimenter press the PauseKey again
        while true
            % Here, I wait for the experimenter to answer:
            [PauseEnd, PauseResp, ~] = KbWait(compKbDevice,3);
            % Here, I compute the time between the first pause press
            % and the resuming, to account for the paused time above
            PauseTime = PauseEnd - Resp_Time;
            if PauseResp(PauseKey) % If the experimenter presses the pause key again resume
                break
            elseif PauseResp(RestartKey) % If experimenter presses the restart key after pausing, restart
                key = RESTART_KEY;
                break
            elseif PauseResp(abortKey) % If experimenter presses the restart key after pausing, restart
                key = ABORT_KEY;
                break
            end
        end
    elseif Resp1(RestartKey)
        key = RESTART_KEY;
    else
        key = WRONG_KEY;
    end
end

    if key == NO_KEY
        Resp_Time = [];
    end
end