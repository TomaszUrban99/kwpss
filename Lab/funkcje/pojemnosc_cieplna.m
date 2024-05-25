function [C] = pojemnosc_cieplna(cp, rho, objetosc)

% POJEMNOSC_CIEPLNA
%   Wyliczenie pojemności cieplnej danej objętości.
%       -> cp - ciepło właściwe medium znajdującego się w danej objętości
%       -> rho - gęstość medium znajdującego się w danej objętości
%       -> objetosc - objetość medium

C = cp * rho * objetosc;

end