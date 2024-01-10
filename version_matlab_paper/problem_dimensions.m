function [n_combin, dim_ram] = problem_dimensions(M)
% Devuelve las dimensiones de la combinatoria de los eventos
%
% Entrada:
%    M: n�mero de palabras c�digo
%
% Salida:
%    n_combinaciones: 1/2*(M c)(M-c c)
%    dim_ramificaciones: combinaciones en las que aparece una palabra 
%        c�digo: n_combinaciones/(1+(M-4)/4)



c = 2;
n_combin = .5 * nchoosek(M, c) * nchoosek(M-c, c);
dim_ram = n_combin/(1+(M-4)/4);

%disp(sprintf("N.� de combinaciones: %d, n.� de ramificaciones: %d", n_combinaciones, dim_ramificaciones  ));

end

