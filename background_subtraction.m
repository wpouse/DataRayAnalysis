function image_matrix_subtracted = background_subtraction(image_matrix)
%Takes as input some intensity matrix, and subtracts background from all
%values (since assuming at edges with no beam there should be 0 intensity)

averaging_distance =15; %# of points around corners to sample

corner_points = zeros(1,4);
corner_points(1) = mean(mean(image_matrix(1:(1+averaging_distance),1:(1+averaging_distance))));
corner_points(2) = mean(mean(image_matrix(1:(1+averaging_distance), (end-averaging_distance):end)));
corner_points(3) = mean(mean(image_matrix((end-averaging_distance):end, 1:(1+averaging_distance))));
corner_points(4) = mean(mean(image_matrix((end-averaging_distance):end, (end-averaging_distance):end)));


avg_intensity = (sum(corner_points) - max(corner_points))/3; %subtract max value for edge case that beam is near corner

image_matrix_subtracted = image_matrix - avg_intensity;

image_matrix_subtracted(image_matrix_subtracted <0) = 0;
