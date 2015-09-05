function distance = beam_distance(beam1, beam2)
%assumes same pixel size for both beams
distance = beam1.pixel_size*norm(beam1.max_position - beam2.max_position);