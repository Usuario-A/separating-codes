function [combinaciones, ramificaciones] = gen_all_possibilities(M)
% Genera todas las combinaciones de índices de las M palabras código.
% Cada combinación será una cuadrupla de índices, donde cada índice tendrá
% un rango de 1..M. Asímismo, se entregan las ramificaciones de cada
% palabra código (número de combinación en la que aparece dicha palabra
% código.
%
%
% Entrada:
%   M: número de palabras código
%
% Salida:
%   combinaciones: matriz de n_combinaciones x 4, donde cada entrada 
%      contiene índices de palabras código; cada fila representa una 
%      combinación de 4 palabras código para evaluar la separabilidad
%   ramificaciones: matriz de Mxdim_ramificaciones, donde cada fila (cuyo
%      índice representa a cada palabra código: 1..M) contiene los índices
%      de las dim_ramificaciones combinaciones en las que aparece
%



[n_combinaciones, dim_ramificaciones] = problem_dimensions(M);

ultimo = M;
combinaciones = zeros(n_combinaciones, 4);
ramificaciones = zeros(M, dim_ramificaciones);
cont = ones(M,1);
i=1;

for primero = 1 : ultimo-3
  for segundo = primero+1 : ultimo
      for tercero = primero+1 : ultimo
          if tercero == segundo 
              continue
          end
          for cuarto = tercero + 1 : ultimo
              if cuarto == segundo 
                  continue
              end
              if cuarto == tercero 
                  continue
              end
              combinacion = [primero, segundo, tercero, cuarto];
              combinaciones(i,:) = combinacion;
              ramificaciones(primero, cont(primero)) = i;
              ramificaciones(segundo, cont(segundo)) = i;
              ramificaciones(tercero, cont(tercero)) = i;
              ramificaciones(cuarto,  cont(cuarto )) = i;
              cont(primero) = cont(primero) + 1;
              cont(segundo) = cont(segundo) + 1;
              cont(tercero) = cont(tercero) + 1;
              cont(cuarto ) = cont(cuarto ) + 1;
              i = i+1;
          end
      end
  end
end

if dim_ramificaciones ~= cont(primero)-1
    error('Error en dimensiones calcualdas de ramificaciones');
end

end
