function image_matrix_subtracted = background_subtraction(image_matrix)
%Takes as input some intensity matrix, and subtracts background from all
%values (since assuming at edges with no beam there should be 0 intensity)

corner_points = zeros(1,4);
corner_points(1) = image_matrix(1,1);
corner_points(2) = image_matrix(1, end);
corner_points(3) = image_matrix(end, 1);
corner_points(4) = image_matrix(end, end);


avg_intensity = (sum(corner_points) - max(corner_points)/3; %subtract max value for edge case that beam is near corner

image_matrix_subtracted = image_matrix - avg_intensity;

image_matrix_subtracted(image_matrix_subtracted <0) = 0;
