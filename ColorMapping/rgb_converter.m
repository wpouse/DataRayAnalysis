function intensity = rgb_converter(rgb, rgb_scale, gray_scale)
%input RGB color (R G B) and outputs the corresponding intensity value
%defined by DataRay monochromatic colorscale. The grayscale RGB values are
%just linear (0 0 0) (1 1 1) (2 2 2)...(255 255 255) so can just use the
%numer as the intensity representation. Problem is normally output DataRay
%as 16bit tiff but here get 8bit max so can only represent 255 different
%intensity values
%{
rgb_scale = imread('RGBscale.bmp');
gray_scale = imread('intensity_scale.bmp');
%}

%%
%Section to try to make rgb converter more efficient using entire matrix at
%once 
%{
dimensions = size(rgb);
intensity_matrix = zeros(dimensions(1), dimensions(2));
%}


%%
%Finding R, G, B rows with rgb we want then calculating intersection to get
%row
r_scale = abs(rgb_scale(:,1,1) - rgb(1));
g_scale = abs(rgb_scale(:,1,2) - rgb(2));
b_scale = abs(rgb_scale(:,1,3) - rgb(3));

r_indices = find(r_scale == min(r_scale));
g_indices = find(g_scale == min(g_scale));
b_indices = find(b_scale == min(b_scale));
color_distance = r_scale.^2 +g_scale.^2 + b_scale.^2;
row_index = find(color_distance == min(color_distance));
%row_index = intersect(b_indices, intersect(r_indices, g_indices));

%{
i = 1;
while isempty(row_index)
    r_indices = find(r_scale <= i);
    g_indices = find(g_scale <=i);
    b_indices = find(b_scale <=i);

    row_index = intersect(b_indices, intersect(r_indices, g_indices));
    i = i+1;
end

middle_index = round(length(row_index)/2); %take middle index since thats probably closest value
row_index = row_index(middle_index);
%}
intensity_rgb = gray_scale(row_index,1,:);

intensity_rgb = reshape(intensity_rgb, [1, 3]); %reshape so in [r g b] format

intensity = intensity_rgb(1); %since r=g=b for grayscale 
