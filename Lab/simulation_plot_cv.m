function [] = simulation_plot_cv(nazwa_modelu, output)

% SIMULATION_PLOT_MODEL

fig1 = figure('Name', nazwa_modelu);
figure(fig1);

plot(output.tout, output.dwupunktowa_cv)

hold on

title(nazwa_modelu);

end