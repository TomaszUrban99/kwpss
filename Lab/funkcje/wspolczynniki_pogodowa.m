function [ wsp ] = wspolczynniki_pogodowa(Twew_zad, T_parametry)

%WSPOLCZYNNIK_POGODOWA
%  T_parametry- temperatury Tgz dla Tzew = -20 oraz Tzew = 20


az = ( T_parametry(1) + T_parametry(2) ) / ( 2 * Twew_zad );

bz = ( T_parametry(1) - az * Twew_zad ) / 20;

wsp(1) = az;
wsp(2) = bz;

end