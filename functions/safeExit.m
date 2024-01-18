% SAFEEXIT runs all commands allowing for a safe exit.
function [] = safeExit()

global EYE_TRACKER RESPONSE_BOX response_box_handle

try
    if EYE_TRACKER
        endEyeTracker();
    end
    if  RESPONSE_BOX
        CedrusResponseBox('Open', response_box_handle);
    end

    % Closing everything
    Priority(0);
    sca;
    ShowCursor;
    ListenChar(0);jhhhh
    
catch
    if EYE_TRACKER
        endEyeTracker();
    end
    % Closing everything
    Priority(0);
    sca;
    ShowCursor;
    ListenChar(0);
end
end