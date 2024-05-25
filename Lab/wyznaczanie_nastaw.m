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


t_fmw = 0;
fmw_0 = 0;
delta_fmw = 1; %0.5 * fmwN;

% --------- PARAMETRY SYMULACJI --------------------

% ----------- set point ----------------------------

    t_wew_SP = 0;
    T_wew_SP_0 = 0;
    delta_Twew_SP = 0; 

% --------- temperatura wewnętrzna ----------------

    t_wew = 0;
    T_wew0 = 20;
    delta_T_wew = 0;

    % -------- METODA 2-PUNKTOWA -----------------------

        To = 972.2; % [s]
        T = 2431.8; % [s]
        k = 15.55; % [ stopnie Celsjusza * s / m^3]

        model_dwupunktowa = tf(k, [T,1], 'OutputDelay', To);

% --------------------------------------------------

% -------- METODA STYCZNEJ -------------------------
        
        To = 743.05; % [s]
        T = 3782.8; % [s]
        k = 15.55; % [ stopnie Celsjusza * s / m^3]

        model_styczna = tf(k, [T,1], 'OutputDelay', To);

% --------------------------------------------------


    out = sim("modele.slx",t_sym);

    fig1 = figure('Name', 'Metoda stycznej');
    figure(fig1);
    
   
    plot(out.tout,out.met_stycznej);
    %ylim([19,22]);
    
    hold on

    fig2 = figure('Name','Metoda dwupunktowa');
    figure(fig2);

   
    plot(out.tout,out.met_2punktowa);
    %ylim([19, 22]);
 
    hold on
