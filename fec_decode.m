function data_dec = fec_decode(rec_sig_add_no,mode_in)
    if mode_in ==2 || mode_in==8
    
bl = 4000;
N=400;
      y0=zeros(1,bl);
      y1=zeros(1,bl);
      y0(1:1:end) = rec_sig_add_no(1:2:end);
      y1(1:1:end) = rec_sig_add_no(2:2:end);
    for p=1:N:bl                    %Decoding is done individually for each block of length N
        
        distance=zeros(8,N+1);   	%For storing minimum distance for reaching each of the 4 states
        metric=zeros(16,N);         	%For storing Metric corresponding to each of the 8 transitions
        distance(1,1)=0;distance(2,1)=Inf;distance(3,1)=Inf;distance(4,1)=Inf; %Initialization of distances
        distance(5,1)=Inf;distance(6,1)=Inf;distance(7,1)=Inf;distance(8,1)=Inf;
        for i=1:N
            metric(1,i)=norm([0,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 000 to 000
            metric(2,i)=norm([1,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 001 to 000
            metric(3,i)=norm([1,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 010 to 001    
            metric(4,i)=norm([0,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 011 to 001
            metric(5,i)=norm([1,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 100 to 010
            metric(6,i)=norm([0,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 101 to 010
            metric(7,i)=norm([0,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 110 to 011
            metric(8,i)=norm([1,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 111 to 011
            metric(9,i)=norm([1,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 000 to 100
            metric(10,i)=norm([0,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 001 to 100
            metric(11,i)=norm([0,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 010 to 101    
            metric(12,i)=norm([1,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 011 to 101
            metric(13,i)=norm([0,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 100 to 110
            metric(14,i)=norm([1,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 101 to 110
            metric(15,i)=norm([1,0]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 110 to 111
            metric(16,i)=norm([0,1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 111 to 111
            distance(1,i+1)=min(distance(1,i)+metric(1,i),distance(2,i)+metric(2,i));%Minimum distance to reach state 000 at time i
            distance(2,i+1)=min(distance(3,i)+metric(3,i),distance(4,i)+metric(4,i));%Minimum distance to reach state 001 at time i
            distance(3,i+1)=min(distance(5,i)+metric(5,i),distance(6,i)+metric(6,i));%Minimum distance to reach state 010 at time i
            distance(4,i+1)=min(distance(7,i)+metric(7,i),distance(8,i)+metric(8,i));%Minimum distance to reach state 011 at time i     
            distance(5,i+1)=min(distance(1,i)+metric(9,i),distance(2,i)+metric(10,i));%Minimum distance to reach state 100 at time i
            distance(6,i+1)=min(distance(3,i)+metric(11,i),distance(4,i)+metric(12,i));%Minimum distance to reach state 101 at time i
            distance(7,i+1)=min(distance(5,i)+metric(13,i),distance(6,i)+metric(14,i));%Minimum distance to reach state 110 at time i
            distance(8,i+1)=min(distance(7,i)+metric(15,i),distance(8,i)+metric(16,i));%Minimum distance to reach state 111 at time i     
        end
    
        [~,state]=min(distance(:,N+1)); %For the final stage pick the state corresponding to minimum weight
    
        %Starting from the final stage using the state, distances of previous stage and metric,
        %decoding the previous state and the corresponding Code bit
        for j=N:-1:1
            [state,decoded_bit]=prev_stage(state,distance(:,j),metric(:,j));
            data_dec(j+p-1)=decoded_bit; %Storing the decoded bit in decode_bit_final vector
        end
    end             %Decoding for one block ends here
      else 
        data_dec=rec_sig_add_no;
    end
end
    function [prev_state,decoded_bit]=prev_stage(curr_state,distance_prev,metric)
    if(curr_state==1)
        if(distance_prev(1)+metric(1) <= distance_prev(2)+metric(2))
            prev_state=1;decoded_bit=0;
        else
            prev_state=2;decoded_bit=0;
        end
    end
    
    if(curr_state==2)
        if(distance_prev(3)+metric(3) <= distance_prev(4)+metric(4))
            prev_state=3;decoded_bit=0;
        else
            prev_state=4;decoded_bit=0;
        end
    end
    
    if(curr_state==3)
        if(distance_prev(5)+metric(5) <= distance_prev(6)+metric(6))
            prev_state=5;decoded_bit=0;
        else
            prev_state=6;decoded_bit=0;
        end
    end
    
    if(curr_state==4)
        if(distance_prev(7)+metric(7) <= distance_prev(8)+metric(8))
            prev_state=7;decoded_bit=0;
        else
            prev_state=8;decoded_bit=0;
        end
    end
     if(curr_state==5)
        if(distance_prev(1)+metric(9) <= distance_prev(2)+metric(10))
            prev_state=1;decoded_bit=1;
        else
            prev_state=2;decoded_bit=1;
        end
    end
    
    if(curr_state==6)
        if(distance_prev(3)+metric(11) <= distance_prev(4)+metric(12))
            prev_state=3;decoded_bit=1;
        else
            prev_state=4;decoded_bit=1;
        end
    end
    
    if(curr_state==7)
        if(distance_prev(5)+metric(13) <= distance_prev(6)+metric(14))
            prev_state=5;decoded_bit=1;
        else
            prev_state=6;decoded_bit=1;
        end
    end
    
    if(curr_state==8)
        if(distance_prev(7)+metric(15) <= distance_prev(8)+metric(16))
            prev_state=7;decoded_bit=1;
        else
            prev_state=8;decoded_bit=1;
        end
    end

end