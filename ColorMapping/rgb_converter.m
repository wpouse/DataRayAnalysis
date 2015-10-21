function intensity = rgb_converter(rgb)
%input RGB color (R G B) and outputs the corresponding intensity value
%defined by DataRay monochromatic colorscale. The grayscale RGB values are
%just linear (0 0 0) (1 1 1) (2 2 2)...(255 255 255) so can just use the
%numer as the intensity representation. Problem is normally output DataRay
%as 16bit tiff but here get 8bit max so can only represent 255 different
%intensity values
rgb_scale = double(imread('RGBscale.bmp'));
gray_scale = double(imread('intensity_scale.bmp'));

%Finding R, G, B rows with rgb we want then calculating intersection to get
%row
r_indices = find(rgb_scale(:,1,1) == rgb(1));
g_indices = find(rgb_scale(:,1,2) == rgb(2));
b_indices = find(rgb_scale(:,1,3) == rgb(3));

row_index = intersect(b_indices, intersect(r_indices, g_indices));
i = 1;
while isempty(row_index)
    r_indices = find(rgb_scale(:,1,1) == rgb(1));
    g_indices = find(rgb_scale(:,1,2) == rgb(2));
    b_indices = find(rgb_scale(:,1,3) == (rgb(3)+1));
    i = i+1;
    find(rgb_scale(:,1,3) - rgb(3)) <= 2

    row_index = intersect(b_indices, intersect(r_indices, g_indices));


intensity_rgb = gray_scale(row_index,1,:);
disp(intensity_rgb)
intensity_rgb = reshape(intensity_rgb, [1, 3]); %reshape so in [r g b] format

intensity = intensity_rgb(1); %since r=g=b for grayscale 
