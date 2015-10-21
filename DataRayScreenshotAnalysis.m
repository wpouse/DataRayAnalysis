function DataRayScreenshotAnalysis(screenshot, pump_power)
%assume screenshot is cropped to only be image region
image_matrix = imread(screenshot);
x_length = length(image_matrix(:,1,1));
y_length = length(image_matrix(1,:,1));
intensity_matrix = zeros(x_length, y_length);

%loop through each x,y coordinate extract [r g b] value. Pass rgb into
%converter which outputs intensity and set that as intensity matrix element
for i = 1:x_length
    for j = 1:y_length
        intensity_matrix(i,j) = rgb_converter(reshape(image_matrix(i,j,:), [1, 3]));
    end
end

pump_beam_analysis(intensity_matrix, pump_power)
