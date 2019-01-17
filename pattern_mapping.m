function y = pattern_mapping(x)
%This function is going to map 1-->1100 ;0--->0011;
numBits = length(x);
y=zeros(1,numBits*2);
for i =1:numBits
    if x(i)==1
        y(4*i-3)=1;
        y(4*i-2)=1;
        y(4*i-1)=0;
        y(4*i)=0;
        continue;
    else
        y(4*i-3)=0;
        y(4*i-2)=0;
        y(4*i-1)=1;
        y(4*i)=1;
    end
end