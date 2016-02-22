function avg_fluence = average_fluence_at_radius(pump_beam, radius)
%gives average fluence of a pump beam at radius (in um) away from the
%center (peak)
r = radius/pump_beam.pixel_size; %r is radius in pixels


fluence_x = pump_beam.fluence_matrix(pump_beam.max_position(1),:); %fluence values for row containing max fluence
fluence_y = pump_beam.fluence_matrix(:,pump_beam.max_position(2)); %fluence values for column containing max fluence

%Define circle for logical indexing
[rr, cc] = meshgrid(1:length(fluence_x), 1:length(fluence_y));
%FWHM is in um so converting to pixel

%define circle as points within radius+1 and above radius-1 
Circle = sqrt((rr-pump_beam.max_position(2)).^2 +(cc-pump_beam.max_position(1)).^2)<= r+1 ...
    & sqrt((rr-pump_beam.max_position(2)).^2 +(cc-pump_beam.max_position(1)).^2)>= r-1;
avg_fluence = mean(pump_beam.fluence_matrix(Circle))*1/(pump_beam.pixel_size^2); %divide by pixel size to get mJ/um^2 