clear
M=10 %number of words
n=36 % word length
rng(1);


tic


m1=rand(M,n);
code=m1>0.5;
    
combin = gen_all_possibilities(M);
bad_events=isSeparating(code,combin);
if bad_events~=0 
        code_sep_obtained=0;
        iter_samp=0;
        while code_sep_obtained==0
            iter_samp=iter_samp+1
            [code,fails_resamp] = m_alg_resamp(code, combin);
            if fails_resamp==0
                code_sep_obtained=1
            end
            if iter_samp==100
                error('failure, does not converge after 100 iterations')
                code_sep_obtained=-1;
            end    
        end
end 

toc
if code_sep_obtained==1
code
end