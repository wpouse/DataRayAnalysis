function pump_beam_analysis(pump_beam_image, power, pixel_size)
if nargin<3
    pixel_size = 9.3; %setting default pixel size to 9.3 um
end

normalization = 0; %0 for false, 1 for true
%use this as power input to normalize total energy to 1mJ
if strcmp(power, 'norm')
    power = 1;
    normalization = 1;
end

pump_beam = beam_profile(pump_beam_image, power, pixel_size);

if normalization == 1
    total_energy = sum(sum(pump_beam.fluence_matrix));
    normalization_ratio = 1.0/total_energy;
    pump_beam.fluence_matrix = pump_beam.fluence_matrix * normalization_ratio;
end


max_fluence = pump_beam.max_intensity * pump_beam.power_intensity_ratio *1/(pump_beam.rep_rate*pump_beam.pixel_size^2); %divide by pixel size to get mJ/um^2, currently fluence matrix using mJ/pixelsize^2
fluence_x = pump_beam.fluence_matrix(pump_beam.max_position(1),:); %fluence values for row containing max fluence
fluence_y = pump_beam.fluence_matrix(:,pump_beam.max_position(2)); %fluence values for column containing max fluence

figure
plot(((1:length(fluence_x)).*pump_beam.pixel_size)-pump_beam.pixel_size/2, fluence_x.*1/(pump_beam.pixel_size^2)); 
title('x-axis Fluence');
ylabel('Fluence (mJ/um^2)');
xlabel('Position (um)');


figure
plot(((1:length(fluence_y)).*pump_beam.pixel_size)-pump_beam.pixel_size/2, fluence_y.*1/(pump_beam.pixel_size^2)); 
title('y-axis Fluence');
ylabel('Fluence (mJ/um^2)');
xlabel('Position (um)');

%Define circle for logical indexing
[rr, cc] = meshgrid(1:length(fluence_x), 1:length(fluence_y));
%FWHM is in um so converting to pixel
radius = (pump_beam.FWHM_x+pump_beam.FWHM_y)/(4*pump_beam.pixel_size); %using radius that is average of FWHM in x and y direction (divide by 4 since FWHM is a diameter)
Circle = sqrt((rr-pump_beam.max_position(2)).^2 +(cc-pump_beam.max_position(1)).^2)<= radius;
avg_fluence = mean(pump_beam.fluence_matrix(Circle))*1/(pump_beam.pixel_size^2); %divide by pixel size to get mJ/um^2 

disp('Max fluence is');
disp([num2str(max_fluence), ' mJ/um^2']);
disp('Average fluence in circular cross section around max is');
disp([num2str(avg_fluence), ' mJ/um^2']);