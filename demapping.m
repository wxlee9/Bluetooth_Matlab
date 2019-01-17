function y = demapping(x)
%this function is going to demap for 1-->1100 ;0--->0011;
numBits = length(x);
y=zeros(1,numBits/4);
for i = 1:numBits/4
    if xor(x(4*i-3),1)+xor(x(4*i-2),1)+xor(x(4*i-1),0)+xor((4*i),0)<=xor(x(4*i-3),0)+xor(x(4*i-2),0)+xor(x(4*i-1),1)+xor((4*i),1)
        y(i)=1;
        continue;
    else
        y(i)=0;
    end
end
