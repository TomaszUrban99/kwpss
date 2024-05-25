% KOMPUTEROWO WSPOMAGANE PROJEKTOWANIE SYSTEMÓW STEROWANIA
% LABORATORIUM
% PROJEKT 1
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
        
        t_fmw = 0; % Moment skoku przepływu
        fmw_0 = fmwN;
        deltafmw = 0.1 * fmwN;
    
    % --------------------------------------------------

    % ------- Przepływ pomieszczenie 1 -----------------

        t_fmg1 = 2000; % Moment skoku
        fmg1_0 = fmg1;
        deltafmg1 = 0;

    % --------------------------------------------------

    % ------- Przepływ pomieszczenie 2 -----------------

        t_fmg2 = 2000; % Moment skoku
        fmg2_0 = fmg2;
        deltafmg2 = 0;
        
    % --------------------------------------------------

    % ----- Zapotrzebowanie na moc, pomieszczenie 1 ---

        t_qt1 = 2000;
        qt1_0 = 0;
        delta_qt1 = 0;
     
    % ------ Zapotrzebowanie na moc, pomieszczenie 2 --
        
        t_qt2 = 2000;
        qt2_0 = 0;
        delta_qt2 = 0;

% ****************************************************************

% ================== PARAMETRY SYMULACJI =========================

    t_wew_SP = 5000;
    T_wew_SP_0 = 20;
    delta_Twew_SP = 1;

    % ---------- TEMPERATURA WEWNĘTRZNA --------------------------

            T_wew0 = 20;

% ================== MODELE ======================================

T_parametry = [ 130, 20];
T_parametry_2 = [ 90, 20];

% ================== NASTAWY REGULATORA =========================

% ----------- POGODOWA ------------------------------------------

    To = 93;
    T = 2396; 
    k = 59.08;

    % Wyliczenie nastaw regulatora

    % Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

    % Model IND (stosowany)
    kp = kp_isa;
    ki = kp * ki_isa;
    kd = 0;

% ------------ BEZPOŚREDNIA ------------------------------------

    To = 972.2;
    T = 2431.8; 
    k = 15.55;

    % Wyliczenie nastaw regulatora

    % Model ZN ISA
    kp_isa = 0.9 * T / ( k * To );
    Ti_isa = 3.33 * To;
    ki_isa = 1 / Ti_isa;

    % Model IND (stosowany)
    kp2 = kp_isa;
    ki2 = kp2 * ki_isa;
    kd2 = 0;

wsp = wspolczynniki_pogodowa(T_wew_SP_0,T_parametry);
az = wsp(1);
bz = wsp(2);

wsp2 = wspolczynniki_pogodowa(T_wew_SP_0, T_parametry_2);
ao = wsp2(1);
bo = wsp2(2);

% =========== SCENATIUSZ BADAN ======================

% --------- UTWORZENIE FIGURE -----------------------

fig_cv_1 = figure('Name','CV_skok_reg');
fig_twew_1 = figure('Name','Twew_skok_reg');

fig_cv_2 = figure('Name','CV_skok_tzew');
fig_twew_2 = figure('Name','Twew_skok_tzew');

fig_cv_3 = figure('Name','CV_skok_qd');
fig_twew_3 = figure('Name','Twew_skok_qd');

fig_cv_4 = figure('Name','CV_skok_fmg');
fig_twew_4 = figure('Name','Twew_skok_fmg');

% ---------- SKOK SP NA REGULATORZE -----------------

    fmg1_0 = fmg1;
    T_zew0 = -20;
    T_wew_SP_0 = 20;

    % skok

    t_wew_SP = 2000;
    
    delta_Twew_SP = 1;
    delta_Tzew = 0;
    deltafmg1 = 0;

    out_pogodowa1 = sim('Simulink/sim_pogodowa.slx',t_sym);
    out_standard1 = sim('Simulink/lab1.slx',t_sym);

% ---------- SKOK TZEW ------------------------------

    t_Tzew = 2000;
    
    delta_Twew_SP = 0;
    delta_Tzew = 1;
    deltafmg1 = 0;

    out_pogodowa2 = sim('Simulink/sim_pogodowa.slx',1.5 * t_sym);
    out_standard2 = sim('Simulink/lab1.slx',1.5 * t_sym);

% ---------- SKOK QD U 1 ODBIORCY -------------------

    t_qt1 = 2000;

    delta_Twew_SP = 0;
    delta_Tzew = 0;
    deltafmg1 = 0;
    delta_qt1 = 1000;
    

    out_pogodowa3 = sim('Simulink/sim_pogodowa.slx',t_sym);
    out_standard3 = sim('Simulink/lab1.slx',t_sym); 

% ---------- SKOK FMG U 1 ODBIORCY ------------------

    t_fmg1 = 2000;

    delta_Twew_SP = 0;
    delta_Tzew = 0;
    deltafmg1 = 0.1 * fmg1_0;
    delta_qt1 = 0;

    out_pogodowa4 = sim('Simulink/sim_pogodowa.slx',1.5 * t_sym);
    out_standard4 = sim('Simulink/lab1.slx',1.5 * t_sym);

% ---------- PLOT -----------------------------------

% VECTORS 
    
    figures_cv = [ fig_cv_1, fig_cv_2, fig_cv_3, fig_cv_4 ];
    figures_pv = [ fig_twew_1, fig_twew_2, fig_twew_3, fig_twew_4];
    
    out_pogodowa = [  out_pogodowa1, out_pogodowa2, out_pogodowa3, out_pogodowa4];
    out_standardowa = [ out_standard1, out_standard2,out_standard3, out_standard4];

    labels = [ 1, 2, 3, 4];

    % -------------------------------------------------------------------------

    for i=1:length(figures_cv)

        % ---------------- CV ----------------------------------

            figure(figures_cv(i));

            plot(out_pogodowa(i).tout, out_pogodowa(i).CV );
            hold on

            plot(out_standardowa(i).tout, out_standardowa(i).CV);
            hold on

            title('PRZEBIEG CV');
            xlabel('CZAS [s]');
            ylabel('PRZEPLYW, M^3/S');

            legend('CV- pogodowa', 'CV- bezpośrednia');

            name_string = strcat('Spraw_03/',string(i),'_cv','.png');
            exportgraphics(figures_cv(i),name_string);

        % ----------------- PV ---------------------------------

            figure(figures_pv(i));

            plot(out_pogodowa(i).tout, out_pogodowa(i).Twew );
            hold on

            plot(out_pogodowa(i).tout, out_pogodowa(i).Twew1 );
            hold on
        
            plot(out_standardowa(i).tout, out_standardowa(i).Twew);
            hold on

            plot(out_standardowa(i).tout, out_standardowa(i).Twew1);
            hold on

            title('PRZEBIEG TWEW');
            xlabel('CZAS [s]');
            ylabel('TEMP, C');

            legend('Pomieszczenie 1, pogodowa', 'Pomieszczenie 2, pogodowa', ...
                'Pomieszczenie 1, bezposrednia', 'Pomieszczenie 2, bezposrednia');

            name_string_pv = strcat('Spraw_03/', string(i),'_pv','.png');
            exportgraphics(figures_pv(i),name_string_pv);

        
    end

