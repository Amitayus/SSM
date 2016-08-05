function [f_fun, out_pdf, mix_param] = SSMLearningOffline(Z_real, Q, R, sv, kw, ip)
% SSM learning: Offline
% 1. *State-transition function* : parametrized using reproducing kernels
% 2. *Mixing parameters* : found in an unsupervised fashion using MC methods
% 3. *Online* : $p(a|y_{1:k}, k=1,2,\cdots$
% Input:
%   Observations y_{1:k}
%   sv: supprot vectors s_{i}, i=1:N=7
%   kw: kernel width \sigma^2 = 10
%   ip:initial particles

Na = 400;
t = 40;
Np = 100;
N = 7;

% sv = rand(1, 7);
kw = 0.1;
ip = rand(Np, 1);
iw = 1/Np*ones(Np, 1);

a(:, 1) = rand(N, 1);
% INITIALIZE THE METROPOLIS-HASTINGS SAMPLER
% DEFINE PROPOSAL DENSITY
q = @(ac, al) al + sqrt(0.2^2 * diag(ker_eval(ac, al, 0.2))) * randn;

% 产生 Na=400 个 MCMC 点
s = 1;

paly = rand;
while s < Na
    
    % DEFINE PRIOR 
    a_prior = rand(N, 1);
    % sample from proposal
    ac = arrayfun(q, a_prior, a(:, s));
    
    % Calculate the posterior
    x(:, 1) = ip;
    z(:, 1) = x(:, 1);
    w(:, 1) = iw;
    w_n(:, 1) = iw;
    pyk1tokm1(1) = w_n(:, 1)' * z(:, 1);
    
    for k = 2:t

        % TODO: 用重采样后的粒子和权重重新计算
                                 
        for j = 1:Np
            x(j, k) = a(:, s)'*arrayfun(@ker_eval_s2s, sv', x(j,k-1)*ones(N,1), ones(N,1));
            z_update(j, k) = x(j, k);
            w(j, k) = ( 1/sqrt(2*pi*R) ) * exp( -(Z_real(k) - z_update(j,k))^2/(2*R) ); 
        end
        
        w_n(:, k) = w(:, k) / sum(w(:, k));
        
        for j = 1:Np
            resampling_index = find(rand <= cumsum(w_n),1);
            w(j, k) = w_n(resampling_index);
            x(j, k) = x(resampling_index);
        end
        w_n(:, k) = w(:, k) / sum(w(:, k));
        
        pykxk = z_update(:, k);
        pyk1tokm1(k) =  w_n(:, k-1)' * pykxk;
    end
    
    % correction factor
    % cf = prod( (arrayfun(q, a(:, l), ac)) ./ (arrayfun(q, ac, a(:, l))) );
    cf = 1;
 
    pacy = mean(a_prior) .* prod(pyk1tokm1);                 % TODO: a_prior 是标量还是矢量
    % calculate the (correction) acceptance ratio
    A = min([1, pacy / paly * cf]);
    paly = pacy;
    out_pdf(s) = pacy;
    
    s = s+1;
    if rand < A
       a(:, s) = ac;
    else
       a(:, s) = a(s-1);
    end
    
end

% 混合参数的后验估计
mix_param = mean(a, 2)';

f_fun = @(x) mix_param * ker_eval(sv, x, kw);

% f_fun = @(x) 10*sinc(x/7);


end
