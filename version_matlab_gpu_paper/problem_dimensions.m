function [n_combin, dim_ram] = problem_dimensions(M)
% Devuelve las dimensiones de la combinatoria de los eventos
%
% Entrada:
%    M: número de palabras código
%
% Salida:
%    n_combinaciones: 1/2*(M c)(M-c c)
%    dim_ramificaciones: combinaciones en las que aparece una palabra 
%        código: n_combinaciones/(1+(M-4)/4)



c = 2;
n_combin = .5 * nchoosek(M, c) * nchoosek(M-c, c);
dim_ram = n_combin/(1+(M-4)/4);

%disp(sprintf("N.º de combinaciones: %d, n.º de ramificaciones: %d", n_combinaciones, dim_ramificaciones  ));

end

