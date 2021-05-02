function h_filtrado = filtragem(h)

h_filtrado = zeros(1,36);

h_aumentado = [h(1,34:36), h, h(1:1:3)]

for i=4:length(h_aumentado)
    h_filtrado(i)=(h_aumentado(i-3)+2*h_aumentado(i-2)+2*h_aumentado(i-1)+2*h_aumentado(i)+2*h_aumentado(i+1)+2*h_aumentado(i+2)+2*h_aumentado(i+3))/7
end
    
    