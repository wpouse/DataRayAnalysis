function [max_intensity, max_position, FWHM_x, FWHM_y, beam_image] = beam_parser(image_file)
%Import DataRay 16bit tiff file and extract parameters of beam
beam_image = double(imread(image_file)); %read image then convert to double in order to allow for decimals/values < 1

max_intensity = max(max(beam_image));
max_position = zeros(1,2);
%max_position(1) = row max_pos(2) = column
[max_position_x, max_position_y] = find(beam_image==max_intensity);

%Only takes first max intensity pixel when multiple pixels have same max intensity, if beam center not very close to max
%could be issue
max_position(1) = max_position_x(1); max_position(2) = max_position_y(1);

half_max = max_intensity/2;

%Extracting values of row and column containing max (ie center)
horiz_lineout = beam_image(max_position(1), :);
vertical_lineout = beam_image(:,max_position(2));

%For both horizontal and vertical lineouts, first find indices of values less than half max
%Then there should be two values closest to center, split into those less
%than center index, and those higher than center index. Max of indices less
%than center index is closest on that side, and min of indices bigger than
%center index is closest on other side. For example c = [1 3 5 7 9 11 10 8
%6 4 2] d=find(c<5.5) d(d<6) max(d(d<6)) outputs of these shows process of whats
%happening.

horiz_indices = find(horiz_lineout<half_max);
horiz_half_max_pos1 = max(horiz_indices(horiz_indices < max_position(1)));
horiz_half_max_pos2 = min(horiz_indices(horiz_indices > max_position(1)));

vertical_indices = find(vertical_lineout<half_max);
vertical_half_max_pos1 = max(vertical_indices(vertical_indices < max_position(2)));
vertical_half_max_pos2 = min(vertical_indices(vertical_indices > max_position(2)));

%Each index is a pixel representing a length
pixel_size = 9.3; %in um

%take average of two pixel distances since not perfectly symmetric
FWHM_x = (abs(max_position(1) - horiz_half_max_pos1) + abs(max_position(1)-horiz_half_max_pos2));
FWHM_y = (abs(max_position(2) - vertical_half_max_pos1) + abs(max_position(2)-vertical_half_max_pos2));

FWHM_x = pixel_size * FWHM_x;
FWHM_y = pixel_size * FWHM_y;

