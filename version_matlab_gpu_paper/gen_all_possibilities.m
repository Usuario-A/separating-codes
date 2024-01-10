function [combinaciones, ramificaciones] = gen_all_possibilities(M)
% Genera todas las combinaciones de �ndices de las M palabras c�digo.
% Cada combinaci�n ser� una cuadrupla de �ndices, donde cada �ndice tendr�
% un rango de 1..M. As�mismo, se entregan las ramificaciones de cada
% palabra c�digo (n�mero de combinaci�n en la que aparece dicha palabra
% c�digo.
%
%
% Entrada:
%   M: n�mero de palabras c�digo
%
% Salida:
%   combinaciones: matriz de n_combinaciones x 4, donde cada entrada 
%      contiene �ndices de palabras c�digo; cada fila representa una 
%      combinaci�n de 4 palabras c�digo para evaluar la separabilidad
%   ramificaciones: matriz de Mxdim_ramificaciones, donde cada fila (cuyo
%      �ndice representa a cada palabra c�digo: 1..M) contiene los �ndices
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
