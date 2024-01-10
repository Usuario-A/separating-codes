function [codewords,fails_resamp] = m_alg_resamp(codewords,combinations)
% Devuelve si el conjunto de palabrasCodigo es separable o no
%
% Entrada:
%  palabrasCodigo: conjunto de M palabras código dimensiones (Mxn)
%
% Salida:
%  true si es separable; false en caso contrario


OK = 0;

[M,n] = size(codewords);


[ncomb, ~] = size(combinations);


for i = 1:ncomb
    
    cuadr = [ codewords(combinations(i,1),:);
                  codewords(combinations(i,2),:);
                  codewords(combinations(i,3),:);
                  codewords(combinations(i,4),:)
                ];
  
    if event_OK(cuadr) == false
%         disp(sprintf("no es separable; se corresponde con combinación %d:", i));
%        copiar en otro, resamplear        
%       codigo_aux=Ppalabras_Codig
%       fallos=fallos+1;

      cuadr=rand(4,n);
      cuadr=cuadr>0.5;
      v=combinations(i,1:4)';
      codewords(v,:)=cuadr;
      break;
    end
    
end  

fails_resamp = isSeparating(codewords,combinations);
%disp(sprintf("Es separable\n"));


end

