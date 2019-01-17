function convData = fec_enc(inputData,mode_in)
% inputData = round(rand(1,4000));
% mode_in=2;
    if mode_in==2 || mode_in==8
        code_bit0=conv([1 1 1 1] , inputData);    %1st Code Bit
        code_bit1=conv([1 0 1 1] , inputData);    %2nd Code Bit

        code_bit0(code_bit0 == 2)=0;
        code_bit0(code_bit0 == 3)=1;
        code_bit0(code_bit0 == 4)=0;
        code_bit0(code_bit0 == 5)=1;
        code_bit0(code_bit0 == 6)=0;
        code_bit0(code_bit0 == 7)=1;
        code_bit1(code_bit1 == 2)=0;
        code_bit1(code_bit1 == 3)=1;
        code_bit1(code_bit0 == 4)=0;
        code_bit1(code_bit0 == 5)=1;
        code_bit1(code_bit0 == 6)=0;
        code_bit1(code_bit0 == 7)=1;
% Modulating Code Bits using BPSK Modulation
        mod_code_bit0=code_bit0(1:length(inputData));   
        mod_code_bit1=code_bit1(1:length(inputData));
% fprintf('Encoding completed...\n');
        s = zeros(1,2*length(inputData));
        s(1:2:end) =mod_code_bit0(1:1:end);
        s(2:2:end) =mod_code_bit1(1:1:end);
        
        convData = s;
    end
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
%         %CONVCODE Summary of this function goes here
%         %   n = k + r
%         %   k = information bits
%         %   r = extra bits
%         %   R = k/n, R high then the result will be more exactly.
%         %   N = constraint length (memory of N+1 stages)
%         %   k = 1 mean that, each time we send 1 bit.
%         %   N = 2 mean that half-rate constraint length.
%         %   g0(x) = 1 + x^2
%         %   g1(x) = 1 + x + x^2
% 
%         %  s0 s1 s2
%         convData = [];
%         registerMatrix = zeros(1,3);
%         for i=1:length(inputData)
%             b = inputData(i);
%             % shift stageMatrix to the left 1 stage,
%             % then input bit b = s0, s1 = prev s0, s2 = prev s1
%             registerMatrix = [b registerMatrix(1:end-1)];
%             %get current state from register matrix
%             currentState = registerMatrix(2:end);
%             outputResult = ComputeStateTransition(b,currentState);
%             convData = [convData outputResult];
%         end
%     end
% end
% 
% % function output = ComputeStateTransition(b,currentState)
% %     s0 = b;
% %     s1 = currentState(1,1);
% %     s2 = currentState(1,2);
% %     
% %     bit0 = mod(s0+s2,2);
% %     bit1 = mod(s0 + s1 + s2,2);
% %     output = [bit0 bit1];
% % end
% 
% function output = ComputeStateTransition(b,currentState)
%     if b == 0
%         if isequal([0 0], currentState)
%             output =  [0 0];
%         end
%         if isequal([0 1], currentState)
%             output =  [1 1];
%         end
%         if isequal([1 0], currentState)
%             output =  [1 0];
%         end
%         if isequal([1 1], currentState)
%             output =  [0 1];
%         end
%     end
%     if b == 1
%         if isequal([0 0], currentState)
%             output =  [1 1];
%         end
%         if isequal([0 1], currentState)
%             output =  [0 0];
%         end
%         if isequal([1 0], currentState)
%             output =  [0 1];
%         end
%         if isequal([1 1], currentState)
%             output =  [1 0];
%         end
%     end 
% end
