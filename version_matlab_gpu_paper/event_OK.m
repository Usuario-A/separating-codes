function  OK = event_OK(cuadr)

[~,n] = size(cuadr);

OK = false;

for i = 1:n
   if cuadr(1,i)==cuadr(2,i) & cuadr(3,i)==cuadr(4,i) & cuadr(1,i)~=cuadr(3,i) 
       OK = true;
       return;
   end       
end

OK = false;



end

