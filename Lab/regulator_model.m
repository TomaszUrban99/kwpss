% Układ regulacji automatycznej na modelu
%
%   TOMASZ URBAN
%   numer indeksu: 247 428

addpath("funkcje/");
close all;
clear all;

t_sym = 30000;


% --------- PARAMETRY SYMULACJI --------------------

% ----------- set point ----------------------------

    t_wew_SP = 0;
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

        out2 = sim('sim_dwupunktowy.slx',t_sym);
        simulation_plot_model('Dwupunktowa',out2); 


% -------- METODA STYCZNEJ -------------------------
        
        To = 743.05; % [s]
        T = 3782.8; % [s]
        k = 15.55; % [ stopnie Celsjusza * s / m^3]

% Wyliczenie nastaw regulatora PI, metoda styczna
% Zwrocic uwage, moze nastapic rozjazd wartosci

% Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

% Model IND (stosowany)
    kp = kp_isa;
    ki = kp * ki_isa;
    kd = 0;

    model_styczna = tf(k,[T,1],'OutputDelay', To);

    out3 = sim('sim_dwupunktowy.slx', t_sym);
    simulation_plot_model('Styczna',out3);
    
% -------- PID-TUNER --------------------------------
            

% --------------------------------------------------

