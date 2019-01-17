clear; close all;
clc;
% hold on
%% coding decoding parameter
% mode:s = 2 or s = 8;
% SH:soft SH :1 or hard SH =:0;
% NcoH:noncoherent:0 or coherent:1
numBits1 = 4000;
mode = 8; % 1 or 2 or 8  mode
upSampRate = 2;% up sampling rate
t = -8:1/upSampRate:8;  % -8:0.5:8
B = 0.5; T = 1; h = 0.5;
snrDb1 = -4; %?
snrDb2 = 10; %?
snrDb = snrDb1:2:snrDb2;
numSnrPt = length(snrDb);
%ad = [1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,1,0,1,1,1,1,1,0,1,1,0,1,0,1,1,0,];
numchanLoop = 1;
for k = 1:numchanLoop
    payload = round(rand(1,numBits1)); % 400
    if mode == 1
        packet = payload;
       % payload = [ad,payload];
    elseif mode == 2
        packet = fec_enc(payload,mode);
        %coded_ad = fec_enc(ad,mode);
    elseif mode == 8
        payload1 = fec_enc(payload,mode);
        packet = pattern_mapping(payload1);

    end
    %  packet = pkt_gen(2,'ac',pld);

    %%% modul demodul parameter
    numBits = length(packet);
    s1 = gfsk_modulation(upSampRate,packet,h,B,T,t);%gfsk modulation
%     if mode == 2
%         mod_ad = gfsk_modulation(upSampRate,coded_ad,h,B,T,t);
%     elseif mode ==8
%         mod_ad = gfsk_modulation(upSampRate,mpd_aa,h,B,T,t);
%     elseif mode == 1
%         mod_ad = gfsk_modulation(upSampRate,ad,h,B,T,t);
%     end
    nt = zeros(1,100);
    s = [nt,s1];
    sigLen = length(s);
    %%% noise
    BER = zeros(1,numSnrPt);
    for mm = 1:numSnrPt
        noise = (randn(1,sigLen)+1j*randn(1,sigLen))*db2mag(-snrDb(mm))/sqrt(2)*sqrt(upSampRate);
        rcvSig = s+noise;
        startPt = detector_synch(rcvSig);
%         rcvData = rcvSig(startPt:end);
        demodBits = gfsk_demod(s1,startPt);
        if mode==8
            dmp_data = demapping(demodBits);
            data = fec_decode(dmp_data,mode);%
        else
             data = fec_decode(demodBits,mode);
        end

        BER(mm) = BER(mm)+sum(data~=payload)/numBits/numchanLoop;
        ber = length(find(data~=payload))/numBits/numchanLoop
    end
end
semilogy(snrDb,BER)
