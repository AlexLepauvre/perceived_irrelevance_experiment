function [ ] = getPracticeFeedback()
global compKbDevice RestartKey YesKey
global RUN_PRACTICE MaxPracticeHits PracticeHits PracticeFalseAlarms TotalScore practice_aud_score warning_response_order 
global PRACTICE_FEEDBACK_MESSAGES RESTART_PRACTICE_MESSAGE restart_practice_message EXTRA_PRACTICE RESP_ORDER_WARNING_MESSAGE

  
EXTRA_PRACTICE = 0;
while RUN_PRACTICE
    RestartPracticeFlag=1;
     runPractice();
    aud_feedback_message = ['Your auditory score is ', num2str(round(practice_aud_score*100)), '%'];
    if RUN_PRACTICE
        if (isempty(PRACTICE_FEEDBACK_MESSAGES))
            restart_practice_message=sprintf(strcat('Your visual score is ', ' %s\n\n%s\n\\n%s'),strcat(num2str(round(TotalScore)),'%. Very good'),aud_feedback_message,RESTART_PRACTICE_MESSAGE);
        elseif (length(PRACTICE_FEEDBACK_MESSAGES)==1)
            splitted_message=strsplit(PRACTICE_FEEDBACK_MESSAGES{1},{'x'});
            if (isempty(strfind(PRACTICE_FEEDBACK_MESSAGES{1},'missed')))
                restart_practice_message=sprintf(strcat('Your visual score is ', ' %s\n\n%s %s %s \n\n\n %s \n%s'),strcat(num2str(round(TotalScore)),'%'),splitted_message{1},num2str(PracticeFalseAlarms),splitted_message{2},aud_feedback_message,RESTART_PRACTICE_MESSAGE);
            else
                restart_practice_message=sprintf(strcat('Your visual score is ', ' %s\n\n%s %s %s \n\n\n %s \n%s'),strcat(num2str(round(TotalScore)),'%'),splitted_message{1},num2str(MaxPracticeHits-PracticeHits),splitted_message{2},aud_feedback_message,RESTART_PRACTICE_MESSAGE);
            end
        else
            splitted_message1=strsplit(PRACTICE_FEEDBACK_MESSAGES{1},{'x'});
            splitted_message2=strsplit(PRACTICE_FEEDBACK_MESSAGES{2},{'x'});
            restart_practice_message=sprintf(strcat('Your visual score is ', ' %s\n\n%s %s %s \n\n%s %s %s\n\n %s \n%s'),strcat(num2str(round(TotalScore)),'%'),splitted_message1{1},num2str(MaxPracticeHits-PracticeHits),splitted_message1{2},splitted_message2{1},num2str(PracticeFalseAlarms),splitted_message2{2},aud_feedback_message, RESTART_PRACTICE_MESSAGE);
        end

        showMessage(restart_practice_message)
        % Wait for answer
        [~, RestartPracticeResp, ~] =KbWait(compKbDevice,3);

        while RestartPracticeFlag
            if RestartPracticeResp(RestartKey)
                RestartPracticeFlag=0;
                RUN_PRACTICE = 1;
                EXTRA_PRACTICE = 1;
            elseif RestartPracticeResp(YesKey)
                RestartPracticeFlag=0;
                RUN_PRACTICE = 0;
            else
                [~, RestartPracticeResp, ~] =KbWait(compKbDevice,3);
                RestartPracticeFlag=1;
            end
        end
    end


    if warning_response_order == 1
        showMessage(RESP_ORDER_WARNING_MESSAGE)
        WaitSecs(2)
        warning_response_order = 0;
    end

end

showMessage('The practice is over. Well done! \n\n press any key to start the experiment.')
KbWait(compKbDevice,3)

end