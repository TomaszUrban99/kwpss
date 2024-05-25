% Układ regulacji automatycznej na modelu
%
%   TOMASZ URBAN
%   numer indeksu: 247 428

addpath("funkcje/");
close all;
clear all;

t_sym = 35000;

% Wyliczenie przeplywu nominalnego
    
    % Nominalna moc grzejnika dla pojedynczego pomieszczenia
    qgN = 10000;  
    % Temperatura wody w sieci, woda wpływająca do wymiennika
    TwzN = 130;
    % ciepło właściwe wody [J/kg]
    cpw = 4200; 
    % Temperatura wody wypływająca z wymiennika
    TwpN = 110;

fmwN = fmw_calc(2*qgN, cpw, TwzN, TwpN);


% --------- PARAMETRY SYMULACJI --------------------

% ----------- set point ----------------------------

    t_oz_0 = 0;
    T_oz_SP_0 = 90;
    delta_T_oz_SP = 0.25; 

% --------- temperatura wewnętrzna ----------------

    t_wew = 0;
    T_oz0 = 90;
    delta_T_wew = 0;

    % -------- METODA 2-PUNKTOWA -----------------------

         To = 93;
    T = 2396; 
    k = 59.08;

        % Model ZN ISA
        kp_isa = 0.9 * T / ( k * To );
        Ti_isa = 3.33 * To;
        ki_isa = 1 / Ti_isa;

        % Model IND (stosowany)
        kp = kp_isa;
        ki = kp * ki_isa;
        kd = 0;


        model_dwupunktowa = tf(k, [T,1], 'OutputDelay', To);
        out = sim('Simulink/sim_dwupunktowy_pogodowa.slx',t_sym);

% --------------------------------------------------
    fig2 = figure('Name','Metoda dwupunktowa');
    figure(fig2);

   
    plot(out.tout,out.output);
    %ylim([19, 22]);
 
    hold on
