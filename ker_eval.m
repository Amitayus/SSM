function y = ker_eval(X1,X2,ker_param)

N1 = size(X1,2);
N2 = size(X2,2);


if N1 == N2
    y = (exp(-sum((X1-X2).^2,1)*ker_param))';
elseif N1 == 1
    y = (exp(-sum((X1*ones(1,N2)-X2).^2,1)*ker_param))';
elseif N2 == 1
    y = (exp(-sum((X1-X2*ones(1,N1)).^2,1)*ker_param))';
else
    warning('error dimension--')
end

return
