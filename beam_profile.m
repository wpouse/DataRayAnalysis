classdef beam_profile
    %Contains properties of beam
    properties
        max_intensity %Data Ray value of highest intensity point
        max_position %[row, col] of highest intensity point
        FWHM_x %FWHM for row containing center
        FWHM_y
        pixel_size %length of each pixel
        probe %if = 1 is probe if =0 pump 
        pump_power %in mW
        beam_image %matrix of intensity values (ie raw input)
        power_intensity_ratio %for given dataray value, corresponding power ie power = intensity * power_intensity_ratio
        fluence_matrix %beam_image*power_intensity_ratio/rep_rate so still per pixel^2 not um^2
        rep_rate %rep rate of chopper needed to get energy per pulse
    end
    methods
        function obj = beam_profile(data_ray_image, pump_power, pixel_size)
            [obj.max_intensity, obj.max_position, obj.FWHM_x, obj.FWHM_y, obj.beam_image] = beam_parser(data_ray_image);
            if nargin<3
                pixel_size = 9.3; % in um
            end
            obj.pixel_size = pixel_size;
            obj.FWHM_x = obj.FWHM_x *obj.pixel_size;
            obj.FWHM_y = obj.FWHM_y *obj.pixel_size;
            obj.rep_rate = 991.3; %in Hz
            
            if (~exist('pump_power', 'var')) %checking if pump_power passed as argument, if not then assume its probe
                obj.pump_power = 0;
                obj.probe = 1;
            else
                obj.pump_power = pump_power;
                obj.probe = 0;
                
                %Summing over all intensities and equating to pump power
                obj.beam_image = background_subtraction(obj.beam_image);%subtracting very rough background (simply average of corners)
                total_intensity = sum(sum(obj.beam_image));
                obj.power_intensity_ratio = obj.pump_power/total_intensity;
                
                obj.fluence_matrix = bsxfun(@times, obj.beam_image, (obj.power_intensity_ratio / obj.rep_rate));
                
                
            end
        end
        function fluence = fluence_at_probe(obj, probe_beam)
            %Input corresponding probe beam for scan and before/after to
            %get fluence of pump at probe center
            if obj.probe == 1
                error('Must be corresponding pump scan')
            end
            
            fluence = obj.fluence_matrix(probe_beam.max_position(1), probe_beam.max_position(2)) * 10^8/(obj.pixel_size^2) ; %multiply by 10^8 (to go from um^-2 to cm^-2 DOUBLE CHECK) anddivide by pixel size to get into energy/cm^2
        end
    end
end
