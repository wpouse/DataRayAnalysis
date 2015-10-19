function pump_beam_analysis(pump_beam_image, power)
pump_beam = beam_profile(pump_beam_image, power);
max_fluence = pump_beam.max_intensity * pump_beam.power_intensity_ratio *1/(pump_beam.rep_rate*pump_beam.pixel_size^2); %divide by pixel size to get mJ/um^2, currently fluence matrix using mJ/pixelsize^2
fluence_x = pump_beam.fluence_matrix(pump_beam.max_position(1),:); %fluence values for row containing max fluence
fluence_y = pump_beam.fluence_matrix(:,pump_beam.max_position(2)); %fluence values for column containing max fluence

figure
plot(1:length(fluence_x), fluence_x.*1/(pump_beam.pixel_size^2)); %currently x axis in units of pixels
title('x-axis Fluence');
ylabel('Fluence');
xlabel('Position (in pixel #)');


figure
plot(1:length(fluence_y), fluence_y.*1/(pump_beam.pixel_size^2)); %x axis in units of pixels
title('y-axis Fluence');
ylabel('Fluence');
xlabel('Position (in pixel #)');

%Define circle for logical indexing
[rr, cc] = meshgrid(1:length(fluence_x));
radius = (pump_beam.FWHM_x+pump_beam.FWHM_y)/4; %using radius that is average of FWHM in x and y direction (divide by 4 since FWHM is a diameter)
Circle = sqrt((rr-pump_beam.max_position(2)).^2 +(cc-pump_beam.max_position(1)).^2)<= radius;
avg_fluence = mean(pump_beam.fluence_matrix(Circle))*1/(pump_beam.pixel_size^2); %divide by pixel size to get mJ/um^2 

disp('Max fluence is');
disp([num2str(max_fluence), ' mJ/um^2']);
disp('Average fluence in circular cross section around max is');
disp([num2str(avg_fluence), ' mJ/um^2']);