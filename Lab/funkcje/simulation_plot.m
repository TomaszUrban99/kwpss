function [out] = simulation_plot(nazwa_wykresu,czas_symulacji)

%SIMULATION_PLOT 
%   Detailed explanation goes here

hold on;

fig1 = figure('Name',nazwa_wykresu);
figure(fig1);

hold on;

% Przeprowadzenie symulacji
out = sim('lab1.slx', czas_symulacji);

subplot(2,1,1);

temperatury = [ "Pomieszczenie 1", "Pomieszczenie 2"];

title('Temperatura wewnętrzna')
xlabel('Czas [s]'); 
ylabel('Temperatura [st. Celsjusza]')

hold on;

plot(out.tout,out.Twew);

hold on

plot(out.tout,out.Twew1);

legend(temperatury);

subplot(2,1,2);

plot(out.tout,out.Top);

hold on;

title('Top')
xlabel('Czas [s]');
ylabel('Temperatura [st. Celsjusza]')

exportgraphics(fig1,'Spraw_02/'+nazwa_wykresu+'.jpg');

fig2 = figure('Name', nazwa_wykresu + " tylko Twew");
figure(fig2);

plot(out.tout,out.Twew);
hold on
plot(out.tout,out.Twew1);
hold on

title('Temperatura wewnętrzna')
xlabel('Czas [s]');
ylabel('Temperatura [st. Celsjusza]');

legend(temperatury,'Location','southeast');

exportgraphics(fig2,'Spraw_02/'+nazwa_wykresu+ 'tylko_Twew.jpg');

end