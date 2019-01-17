function rx_bits = gfsk_demod(tx_data,rx_data)
rx_phase=atan2(imag(rx_data),real(rx_data)); 
% bits = tx_data;
% tx_bits_1 = length(find(bits==1));
% tx_bits_0 = length(find(bits==0));
% llr = log(tx_bits_1/tx_bits_0);
% upSampRate = 2;
    % Unwrap phase              
for i=2:length(rx_phase)
    difference=rx_phase(i)-rx_phase(i-1);
    if difference > pi
        rx_phase(i:end)=rx_phase(i:end)-2*pi;
    elseif difference < -pi
        rx_phase(i:end)=rx_phase(i:end)+2*pi;
    end
end
    
     %  Differential phase Detector
%     sampling_instances=2*8:2:length(rx_phase)-17;
%     sample_values=rx_phase(sampling_instances);
%     sample_values=[0 sample_values];% 0 is the reference phase
%     derivative=diff(sample_values);
%     rx_bits=derivative >0;% received ones and zeros
% sampling_instances=((length(t)-1)/upSampRate)+1:upSampRate:length(rx_phase)-(length(t)-1)/upSampRate; 
% %sampling_instances=1:upSampRate:length(rx_phase);
% sample_values=rx_phase(sampling_instances);
% sample_values=[0 sample_values];% 0 is the reference phase
% derivative=diff(sample_values);
% rx_bits=derivative>0;% received ones and zeros
% rx_bits = double(rx_bits);
sample_values=[0 rx_phase];  % 0 is the reference phase
derivative1=diff(sample_values);
derivative=derivative1(17:2:length(rx_phase)-16);
    rx_bits=derivative>0;% received ones and zeros
%     ber = length(err_num)/numbit
% err_num=find(rx_bits~=bits);
end