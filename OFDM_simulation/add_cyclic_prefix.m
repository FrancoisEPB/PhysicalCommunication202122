function X_prefix = add_cyclic_prefix(X,sub_car)
%X: data stream
%sub_car: number of sub carrier
%X_prefix: data stream with prefix

% Add cyclic prefix of length sub_car/8

N = size(X);
X_prefix = [];
for i=1:N/sub_car
    block = X(sub_car*(i-1)+1:sub_car*i);
    block_prefix = [block(end-cyclic_pref_size+1:end) block];
    X_prefix = [X_prefix block_prefix];
    
end

end