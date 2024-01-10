function fails = isSeparating(codewords,combinations)
% Develve si el conjunto de palabrasCodigo es separable o no
%
% Entrada:
%  palabrasCodigo: conjunto de M palabras código dimensiones (Mxn)
%
% Salida:
%  true si es separable; false en caso contrario


OK = 0;

[M,n] = size(codewords);

[ncomb, ramas] = size(combinations);
fails=0;

for i = 1:ncomb
    
    cuadrupla = [ codewords(combinations(i,1),:);
                  codewords(combinations(i,2),:);
                  codewords(combinations(i,3),:);
                  codewords(combinations(i,4),:)
                ];
  
    if event_OK(cuadrupla) == false

       fails=fails+1;
%      combinations(i,1:4);
    end
    
end  

OK = 1;


end

