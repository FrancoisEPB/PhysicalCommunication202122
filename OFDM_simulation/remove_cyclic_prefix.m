function Xr = remove_cyclic_prefix(Xr_prefix,sub_car,N)
%Xr: data stream without prefix
%Xr_prefix: data stream with prefix
%N: number of element in the data stream
%sub_car: number of sub carrier

% remove cyclic prefix of length sub_car/8

Xr = [];
index = 1;
cyclic_pref_size = sub_car/8;

for i=1:N/sub_car
    block = Xr_prefix(index:index+sub_car+cyclic_pref_size-1);
    index = index + sub_car + cyclic_pref_size;
    block_no_prefix = block(cyclic_pref_size+1:end);
    Xr = [Xr block_no_prefix];
    
end