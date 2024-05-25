% Układ regulacji automatycznej na modelu
%
%   PROJEKT 4
%   TOMASZ URBAN
%   numer indeksu: 247 428

addpath("funkcje/");
close all;
clear all;

t_sym = 30000;


% --------- PARAMETRY SYMULACJI --------------------

% ----------- set point ----------------------------

    t_wew_SP = 1000;
    T_wew_SP_0 = 20;
    delta_Twew_SP = 1; 

% --------- temperatura wewnętrzna ----------------

    T_wew0 = 20;

% -------- PARAMETRY MODELI ------------------------

% -------- METODA 2-PUNKTOWA -----------------------

        To = 972.2; % [s]
        T = 2431.8; % [s]
        k = 15.55; % [ stopnie Celsjusza * s / m^3]

        % ------------------------------------------
        % PARAMETRY
        %
        %   a = 0.61
        %   L = 970.87

        % a = 0.61;
        % L = 970.87;
      

% Wyliczenie nastaw regulatora PI, metoda dwupunktowa
% Haagglund, PID theory, control, design

% Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

% Model IND (stosowany)
    kp = kp_isa;
    ki = kp * ki_isa;
    kd = 0;

    %Tp = 5.7 * L;

        model_dwupunktowa = tf(k, [T,1]);

% --------------------------------------------------

fig1 = figure('Name','CV');
fig2 = figure('Name', 'PV');
figure_vector = [fig1, fig2];

labels = { 'bez ograniczen', 'nasycenie', 'anty-windup'};

        out1 = sim('Simulink/sim_projekt4_scenariusz1_1.slx',t_sym);
        out2 = sim('Simulink/sim_projekt4_scenariusz1_2.slx',t_sym);
        out3 = sim('Simulink/sim_projekt4_scenariusz1_3.slx',t_sym);

        output_vector = [out1, out2, out3 ];

      simulation_plot_cv_model(output_vector,labels, figure_vector);

