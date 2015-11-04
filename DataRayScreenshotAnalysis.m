function DataRayScreenshotAnalysis(screenshot, pump_power, FWMH_x_screenshot, pixel_sizein)
%assume screenshot is cropped to only be image region, FWHM_x screenshot is
%FWHM given in screenshot and used to calibrate pixel size
image_matrix = imread(screenshot);
x_length = length(image_matrix(:,1,1));
y_length = length(image_matrix(1,:,1));
intensity_matrix = zeros(x_length, y_length);

rgb_scale = imread('rgb_scale_photoshop.bmp'); %use as inputs to rgb converter so matlab doesn't have to reread each image for each function call
gray_scale = imread('intensity_scale_photoshop.bmp');

%loop through each x,y coordinate extract [r g b] value. Pass rgb into
%converter which outputs intensity and set that as intensity matrix element
for i = 1:x_length
    for j = 1:y_length
        intensity_matrix(i,j) = rgb_converter(reshape(image_matrix(i,j,:), [1, 3]), rgb_scale, gray_scale);
    end
end

intensity_matrix = uint8(intensity_matrix); %intensity matrix was originally a double and when writing to image tiff assumes uint8 otherwise it converts by normalizing to 255
imwrite(intensity_matrix, 'temp_intensity_matrix_from_screenshot.tiff');

[max_intensity, max_position, FWHM_x, FWHM_y, beam_image] = beam_parser('temp_intensity_matrix_from_screenshot.tiff');

pixel_size = FWMH_x_screenshot/FWHM_x;
pixel_size = pixel_sizein;
FWHM_x_calc = pixel_size*FWHM_x
pump_beam_analysis('temp_intensity_matrix_from_screenshot.tiff', pump_power, pixel_size)
