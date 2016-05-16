function [onzeros]=switchTime_OnToOff(filename,replicate)


times=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');

counts=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
ts3=1;
n=1;
onevent1(n,ts3)=0;
% onevent1;

%%%%%%% Determining the number of on events and selecting the biggest one:
for t1=2:size(times,2)
%     if t1+1<size(times,2) & counts(times(1,t1),3)>9 & (counts(times(1,t1+1),3)>9 || counts(times(1,t1+2),3)>9)
%     t1
%     c=counts(times(1,t1),3)
    if counts(times(1,t1),3)>4 
%         onts(ts1)=times(t1);
        onevent1(n,ts3)=times(t1);
        ts3=ts3+1;
    else 
        if ts3>1
            n=n+1;
        end
            ts3=1;
    end
%         ts1=ts1+1;
end
% onts;
% onevent1;
if onevent1(1,1)==0
    onzeros=[];
    return
end

for i1=1:size(onevent1,1)
    for i2=1:size(onevent1,2)
        if onevent1(i1,i2)==0
            onzeros(i1)=i2;
            break;
        end
        if i2==size(onevent1,2)
            onzeros(i1)=i2+1;
        end
    end
end
return %%The index of the maximum is the largest cluster number
