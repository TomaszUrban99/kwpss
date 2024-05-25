% KOMPUTEROWO WSPOMAGANE PROJEKTOWANIE SYSTEMÓW STEROWANIA
% LABORATORIUM
% PROJEKT 1
%
%
% Tomasz Urban
% Numer indeksu: 247 428
%
%

addpath("funkcje/");

close all;
clear all;

% Parametry symulacji
    t_sym=30000;
    t_op_tr = 10;

% ***************** STAŁE **********************

% ---- POWIETRZE -----
    cp = 1005; % ciepło właściwe [J/kg]
    rho_p = 1.1225; % gęstość [kg/m^3] 

% ---- WODA ----------
    cpw = 4200; % ciepło właściwe wody [J/kg]
    rho_w = 1000; % gęstość wody [kg/m^3]

% **********************************************

% *********** WARTOŚCI NOMINALNE ***************
    
    % Nominalna temperatura zewnętrzna
    TzewN = -20; 
    % Nominalna temperatura wewnętrzna
    TwewN = 20; 
    % Nominalna temperatura wody wpływającej do grzejnika
    TgzN = 90; 
    % Nominalna temperatura woy wypływającej z grzejnika
    TgpN = 70; 
    % Nominalna moc grzejnika dla pojedynczego pomieszczenia
    qgN = 10000;  
    % Temperatura wody w sieci, woda wpływająca do wymiennika
    TwzN = 130;
    % Temperatura wody wypływająca z wymiennika
    TwpN = 110;
    % Nominalna temperatura wody wypływajacej z wymiennika w
    % kierunku pomieszczeń
    TozN = TgzN;
    % Nominalna temperatury wody wpływającej do wymiennika od 
    % strony pomieszczeń
    TopN = TgpN;
    % Nominalne straty ciepła
    qtN = 0;

% **********************************************

% ************ PARAMETRY MODELU ****************
% ------------ Pomieszczenie 1 -----------------
   
    %   Wymiary pomieszczenia:
    %       1. szerokość
    %       2. długość
    %       3. wysokość
        pom1_dim = [ 3, 3, 2.5];
    %   Objetość pomieszczenia:
        pom1_obj = objetosc_pom(pom1_dim(1), pom1_dim(2), pom1_dim(3));
    
    %   Wymiary grzejnika:
        pom1_grz_dim = [ 0.6, 1.2, 0.125];
    %   Objetość grzejnika:
        pom1_grz_obj = objetosc_pom( ...
            pom1_grz_dim(1), pom1_grz_dim(2), pom1_grz_dim(3));
    
    %   Parametry medium
    %   Ciepło właściwe medium w pomieszczeniu:
        c_1 = cp;
    %   Ciepło właściwe medium w grzejniku:
        cg_1 = cpw;
    %   Gęstość powietrza:
        rho_p1 = rho_p;
    %   Gęstość medium w grzejniku:
        rho_g1 = rho_w;

    %   Pojemność cieplna:
        % Pojemność cieplna pomieszczenia została pomnożona przez 10
        % w celu uwzględnienia pojemności cieplnej ścian
        Cvw = 10 * pojemnosc_cieplna(c_1, rho_p1, pom1_obj); % Pomieszczenie
        Cvg = pojemnosc_cieplna(cg_1, rho_g1, pom1_grz_obj); % Grzejnik

    %   Przenikalności cieplne:
        Kcg = Kcg_calc(qgN, TgpN,TwewN);
        Kcw = Kcw_calc(Kcg, TgpN, TwewN, TzewN);
    
    %   Przepływ w grzejnikach:
        fmg1 = fmgN_calc(qgN, cpw, TgzN, TgpN);
        
% ------------------------------------------------------------

% -------------- Pomieszczenie 2 ----------------------------
   
    %   Wymiary pomieszczenia:
    %       1. szerokość
    %       2. długość
    %       3. wysokość
        pom2_dim = [ 3, 3, 2.5];
    %   Objetość pomieszczenia:
        pom2_obj = objetosc_pom(pom2_dim(1), pom2_dim(2), pom2_dim(3));
    
    %   Wymiary grzejnika:
        pom2_grz_dim = [ 0.6, 1.2, 0.125];
    %   Objetość grzejnika:
        pom2_grz_obj = objetosc_pom( ...
            pom2_grz_dim(1), pom2_grz_dim(2), pom2_grz_dim(3));
    
    %   Parametry medium
    %   Ciepło właściwe medium w pomieszczeniu:
        c_2 = cp;
    %   Ciepło właściwe medium w grzejniku:
        cg_2 = cpw;
    %   Gęstość powietrza:
        rho_p2 = rho_p;
    %   Gęstość medium w grzejniku:
        rho_g2 = rho_w;

    %   Pojemność cieplna:
        % Pojemność cieplna pomieszczenia została pomnożona przez 10
        % w celu uwzględnienia pojemności cieplnej ścian. Docelowo 
        % pojemność cieplna pomieszczenia powinna być tego samego rzędu 
        % co pojemność cieplna grzejników.
        Cvw2 = 10 * pojemnosc_cieplna(c_2, rho_p2, pom2_obj); % Pomieszczenie
        Cvg2 = pojemnosc_cieplna(cg_2, rho_g2, pom2_grz_obj); % Grzejnik
    
    %   Przenikalności cieplne:
        Kcg2 = Kcg_calc(qgN,TgpN,TwewN);
        Kcw2 = Kcw_calc(Kcg2,TgpN,TwewN, TzewN);

    %   Przepływ w grzejnikach:
        fmg2 = fmgN_calc(qgN, cpw, TgzN, TgpN);
        

% ------------------- Wymiennik ciepła -------------------------

    %   Parametry wymiennika ciepła
    %   
    %   Zgodnie z założeniami pojemność cieplna każdej z komór wymiennika:
    %       -> Cvo1 = Cvo2 = Cvg + Cvg2
    %
    %   Pojemności cieplne komór wymiennika ciepła
        Cvo1 = Cvg + Cvg2; % Komora od strony ciepłowni
        Cvo2 = Cvg + Cvg2; % Komora od strony pomieszczeń
    
    %   Przenikalności cieplne:
        Kco = Kco_calc(TwpN,TozN,2*qgN);

    %   Przepływy:
        % Przepływ wymiennik-pomieszczenie
        fmo = fmo_calc(2*qgN,cpw,TozN,TopN);
        % Przepływ wymiennik-ciepłownia
        fmwN = fmw_calc(2*qgN, cpw, TwzN, TwpN);

% ---------------------------------------------------------------

% ******************** WARUNKI POCZĄTKOWE **********************

    % Początkowa temperatura wewnętrzna
    T_wew0 = TwewN;
    % Początkowa temperatura zewnętrzna
    T_zew0 = TzewN;
    % Początkowa temperatura wody wypływającej z grzejnika
    T_gp0 = TgpN;
    % Poczatkowa temperatura wody wypływającej z wymiennika
    % w kierunku ciepłowni
    T_wp0 = TwpN;
    % Początkowa temperatura wody wypływająca z wymiennika
    % w kierunku pomieszczeń
    T_oz0 = TozN;
    % Początkowa temperatura wody wpływająca do grzejnika 
    T_gz0 = TozN;

% ***************************************************************

% *************** PARAMETRY WEJŚĆ *******************************

    % -------- Lista wejść --------------------
    %   
    %   -> Twz - temperatura wody z ciepłowni
    %   -> Tzew - temperatura zewnętrzna
    %   -> fmw - przepływ wody z ciepłowni
    %
    % -----------------------------------------
    
    % ----- Temperatura wody z ciepłowni ---------------
        
        t_Twz = 2000; % Moment skoku
        T_wz0 = TwzN;
        T_wz = TwzN;
    
    % --------------------------------------------------
    
    % --------- Temperatura zewnętrzna -----------------
        
        t_Tzew = 2000;
        T_zew0 = TzewN;
        T_zew = TzewN; % Temperatura zewnętrzna końcowa

    % --------------------------------------------------

    % ------ Przepływ wody z ciepłowni ----------------
        
        t_fmw = 2000; % Moment skoku przepływu
        f_mw0 = fmwN;
        fmw =  fmwN;
    
    % --------------------------------------------------


% ****************************************************************

% ================== PARAMETRY SYMULACJI =========================

    t_wew_SP = 5000;
    T_wew_SP_0 = 20;
    delta_Twew_SP = 1;

    % ---------- TEMPERATURA WEWNĘTRZNA --------------------------

            T_wew0 = 20;

% ================== MODELE ======================================

legend_label = [ 'Model', 'Obiekt- Twew1', 'Obiekt- Twew2'];

nastawy = [ 0, 0;
            0, 0;
            0, 0;];

% ************************ STYCZNA *******************************
            
    To = 743.05; % [s]
    T = 3782.8; % [s]
    k = 15.55; % [ stopnie Celsjusza * s / m
    
    % Wyliczenie nastaw regulatora

    % Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

    % Model IND (stosowany)
    kp = kp_isa;
    ki = kp * ki_isa;
    kd = 0;

    nastawy(1,1)=kp;
    nastawy(1,2)=1/ki;

    model_styczna = tf(k, [T,1], 'OutputDelay', To);

    % Symulacja
    out_styczna = sim( 'Simulink/sim_model.slx', 3*t_sym);
    out_obiekt_styczna = sim( 'Simulink/lab1.slx', 3*t_sym);
    
    fig_styczna = figure('Name', 'Obiekt/Styczna');
    figure(fig_styczna);

    plot(out_styczna.tout,out_styczna.output);
    hold on
    plot(out_obiekt_styczna.tout,out_obiekt_styczna.Twew);
    hold on
    plot(out_obiekt_styczna.tout,out_obiekt_styczna.Twew1);
    hold on
    
    title('Porownanie Obiekt/Styczna');
    xlabel('Czas [s]');
    ylabel( 'PV (Model)/ Twew (Obiekt)')

    yyaxis right;
    ylabel('Wskaznik calkowy')

    plot(out_obiekt_styczna.tout,out_obiekt_styczna.wsk_calkowy);

    uchyb_max_styczna = out_obiekt_styczna.uchyb(7050);

    hold on
    legend('Model', 'Obiekt- Twew1', 'Obiekt- Twew2', 'Wskaznik calkowy','Location','southeast');

    exportgraphics(fig_styczna,'Spraw_02/styczna.png');

    fig_styczna_cv = figure('Name','Obiekt/Styczna fmw/CV');
    figure(fig_styczna_cv);

    plot(out_styczna.tout,out_styczna.styczna_cv);
    hold on

    title('Przebieg CV/fmw');
    xlabel('Czas [s]');
    ylabel('URM CV');

    yyaxis right;
    ylabel('fmw');

    plot(out_obiekt_styczna.tout,out_obiekt_styczna.fmw);
    hold on

    legend('URM CV', 'fmw');
    exportgraphics(fig_styczna_cv,'Spraw_02/styczna_cv.png');

% ===================== PID_TUNER ==================================

    kp_isa = 0.29264;
    ki_isa = 0.00027086; % 1/Ti

    kp = kp_isa;
    ki = kp * ki_isa;

    nastawy(2,1)=kp;
    nastawy(2,2)=1/ki;

    % Symulacja 
    out_pid_tuner = sim( 'Simulink/sim_model.slx',3*t_sym);
    out_obiekt_pid_tuner = sim('Simulink/lab1.slx',3*t_sym);

    fig_pid_tuner = figure('Name', 'Obiekt/PID_tuner');
    figure(fig_pid_tuner);

    plot(out_pid_tuner.tout,out_pid_tuner.output);
    hold on
    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.Twew);
    hold on
    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.Twew1);
    hold on

    title('Porownanie Obiekt/PID Tuner');
    xlabel('Czas [s]');
    ylabel( 'PV (Model)/ Twew (Obiekt)')

    yyaxis right;
    ylabel('Wskaznik calkowy')

    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.wsk_calkowy);

    uchyb_max_pid_tuner = out_obiekt_pid_tuner.uchyb(7050);

    hold on
    legend('Model', 'Obiekt- Twew1', 'Obiekt- Twew2', 'Wskaznik calkowy', 'Location','southeast');

    exportgraphics(fig_pid_tuner,'Spraw_02/pid_tuner.png');

    fig_styczna_pid_cv = figure('Name','Obiekt/PID Tuner fmw/CV');
    figure(fig_styczna_pid_cv);

    plot(out_styczna.tout,out_styczna.styczna_cv);
    hold on


    title('Przebieg CV/fmw');
    xlabel('Czas [s]');
    ylabel('URM CV');
    
    yyaxis right;
    ylabel('fmw');

    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.fmw);
    hold on

    legend('URM CV', 'fmw');
    exportgraphics(fig_styczna_pid_cv,'Spraw_02/pid_tuner_cv.png');
            
    
% ************************ 2 - punktowa *******************************

    To = 972.2;
    T = 2431.8; 
    k = 15.55;

    % Wyliczenie nastaw regulatora

    % Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

    % Model IND (stosowany)
    kp = kp_isa;
    ki = kp * ki_isa;
    kd = 0;

     nastawy(3,1)=kp;
    nastawy(3,2)=1/ki;

    model_dwupunktowa = tf(k, [T,1],'OutputDelay',To);

    % Symulacja
    out_dwupunktowa = sim( 'Simulink/sim_dwupunktowy.slx', 3*t_sym);
    out_obiekt_dwupunktowa = sim( 'Simulink/lab1.slx', 3*t_sym);

    fig_2punkt = figure('Name', 'Obiekt/Dwupunktowa');
    figure(fig_2punkt);

    plot(out_dwupunktowa.tout,out_dwupunktowa.output);
    hold on
    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.Twew);
    hold on
    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.Twew1);
    hold on

    title('Porownanie Obiekt/Dwupunktowa');
    xlabel('Czas [s]');
    ylabel( 'PV (Model)/ Twew (Obiekt)')

    yyaxis right;
    ylabel('Wskaznik calkowy')

    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.wsk_calkowy);

    uchyb_dwupunktowa = out_obiekt_dwupunktowa.uchyb(3100);
    
    hold on
    legend('Model', 'Obiekt- Twew1', 'Obiekt- Twew2', 'Wskaznik calkowy', 'Location','southeast');

    exportgraphics(fig_2punkt,'Spraw_02/dwupunktowa.png');

    fig_dwupunktowa_cv = figure('Name','Obiekt/dwupunktowa fmw/CV');
    figure(fig_dwupunktowa_cv);

   
    plot(out_dwupunktowa.tout,out_dwupunktowa.dwupunktowa_cv);
    
    title('Przebieg CV/fmw');
    xlabel('Czas [s]');
    ylabel('URM CV');

    hold on

    yyaxis right;
    ylabel('fmw');

    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.fmw);
    hold on

    legend('URM CV', 'fmw');
    exportgraphics(fig_dwupunktowa_cv,'Spraw_02/dwupunktowa_cv.png');

    % ==================== POROWNANIE URO ================================

    porownanie_uro = figure('Name','porownanie_uro');
    figure(porownanie_uro);

    plot(out_obiekt_styczna.tout,out_obiekt_styczna.Twew);
    hold on
 
    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.Twew);
    hold on
   
    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.Twew);
    hold on

    legend('ZN metoda styczna', 'ZN metoda dwupunktowa', 'ZN PID Tuner');
    title('Porownanie URO, Twew');
    xlabel('Czas [s]');
    ylabel('Twew');

    exportgraphics(porownanie_uro,'Spraw_02/Twew_uro.png'); 

    porownanie_uro_fmw = figure('Name','porowanie_uro_fmw');
    figure(porownanie_uro_fmw);

    plot(out_obiekt_styczna.tout,out_obiekt_styczna.fmw);
    hold on
    plot(out_obiekt_pid_tuner.tout,out_obiekt_pid_tuner.fmw);
    hold on
    plot(out_obiekt_dwupunktowa.tout,out_obiekt_dwupunktowa.fmw);
    hold on

    legend('Metoda styczna', 'PID Tuner', 'Metoda dwupunktowa');
    title('Porownanie URO, fmw');
    xlabel('Czas [s]');
    ylabel('fmw');

    exportgraphics(porownanie_uro_fmw,'Spraw_02/fmw_uro.png');





    %legend('Temperatura wyplywajaca z wymiennika', 'Temperatura wewnatrz pomieszczenia');