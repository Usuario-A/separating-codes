function fails = isSeparating_g(Codg, combin, kern_check2)





[m,n]=size(Codg);
%[ncomb, ramas] = size(combinaciones);
fails=0;
Codg=gpuArray(Codg);
combi_gg=gpuArray(combin);
[ncombg, ~] = size(combi_gg);
is_separat_g=gpuArray.zeros(ncombg,1,'int32');
kern_check2.ThreadBlockSize=512;
%maxg=min(65534,ceil(ncombg/512)+1);
%kern_check2.GridSize=[maxg,1];
kern_check2.GridSize=[1024,1];

 [is_separat_g] = feval(kern_check2,Codg, combi_gg, m,n, ncombg, is_separat_g);
 
 fails=ncombg-gather(sum(is_separat_g));


end

