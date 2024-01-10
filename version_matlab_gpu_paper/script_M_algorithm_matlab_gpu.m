clear
rng(1);

kern_check2=parallel.gpu.CUDAKernel('gpu_check_cuad.ptx','gpu_check_cuad.cu');
M=130 %number of words
n=111 % word length
tic

m1=rand(M,n);
code_ini=m1>0.5;
combin = gen_all_possibilities(M);
combint=gpuArray(int32(combin-1));
[ncomb, ramas] = size(combin);

code_ini_gpu=int32(code_ini>0.5); %change from double type to int32
bad_events=isSeparating_g(code_ini_gpu, combint,kern_check2);

if bad_events ~=0

    fails_resamp=0;
    sepcode=0;
    iter_samp=0
    while sepcode==0
        iter_samp=iter_samp+1
        [code_ini_gpu,fails_resamp] = m_alg_resampg(code_ini_gpu, combint,kern_check2);
        if fails_resamp==0
            sepcode=1
            disp('separating code obtained')
        end
        if iter_samp>100
            error('fail, does not converge after 100 iteration')
            sepcode=-1;
        end
    end
end
if sepcode==1
code_output=gather(code_ini_gpu)
end
% if sepcode==1
% sal=isSeparating(code_output, combin) %check with Matlab version
% end
toc

