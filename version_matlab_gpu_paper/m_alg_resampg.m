function [Codg,fails_resamp] = m_alg_resampg(Codg, combinations, kern_check2)
% Devuelve si el conjunto de palabrasCodigo es separable o no
%
% Entrada:
%  palabrasCodigo: conjunto de M palabras código dimensiones (Mxn)
%
% Salida:
%  true si es separable; false en caso contrario

[m,n]=size(Codg);
%[ncomb, ramas] = size(combinaciones);
Codg=gpuArray(Codg);
combinationsg=gpuArray(combinations);
[ncombg, ~] = size(combinationsg);
is_separating_g=gpuArray.zeros(ncombg,1,'int32');
kern_check2.ThreadBlockSize=512;
%kern_check2.GridSize=[ceil(ncombg/512)+1,1];
kern_check2.GridSize=[1024,1];
[is_separating_g] = feval(kern_check2,Codg, combinationsg, m,n, ncombg, is_separating_g);
index_fails=find(is_separating_g==0);
%nfails=length(index_fails);
%for i=1:nfallos

      cuadrupla=gpuArray(rand(4,n));
      cuadrupla=int32(cuadrupla>0.5);
      v=combinationsg(index_fails(1),1:4)'+1;
      Codg(v,:)=cuadrupla;
%    end
    
  
[is_separating_g] = feval(kern_check2,Codg, combinationsg, m,n, ncombg, is_separating_g);
fails_resamp = length(find(is_separating_g==0));
%disp(sprintf("Es separable\n"));


end

