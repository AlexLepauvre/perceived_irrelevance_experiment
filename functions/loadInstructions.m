% loadInstructions loads all the instructions images from HD.
% output:
% -------
% loads all textures from HD, and puts them into the global textures
% structure (texture_struct) matching the folder structure of the stimuli
% folder

function [instructions_textures] = loadInstructions(instructions_folder, w)

disp('WELCOME TO Instructions')

% path to stimuli folder
instruction_pngs = dir(fullfile(pwd,instructions_folder, '*.png'));
instructions_textures = zeros(size(instructions_folder, 1), 1);
% Loop through each instructions:
for fl = 1:size(instruction_pngs)
    % Load the image:
    [img, ~, ~] = imread(fullfile(instructions_folder, instruction_pngs(fl).name));
    if numel(size(img)) == 2
        img = repmat(img, 1, 1, 3);
    end
    instructions_textures(fl) = Screen('MakeTexture', w, img);
end
end