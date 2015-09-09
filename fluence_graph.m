function fluence_graph(pump_beam_list, probe_beam_list)
%input list of pump beams in scan order, with corresponding probes
beam_numbers = length(pump_beam_list);
if length(probe_beam_list) ~= beam_numbers
    error('Pump and probe list sizes must match')
end
fluences = zeros(beam_numbers);
for n=1:beam_numbers
    fluences(n) = pump_beam_list(n).fluence_at_probe(probe_beam_list(n));
end
figure
plot(1:beam_numbers, fluences)
xlabel('Pump beam number')
ylabel('Fluence at probe (mJ/cm^2)')
    