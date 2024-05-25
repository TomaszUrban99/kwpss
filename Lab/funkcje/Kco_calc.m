function [Kco] = Kco_calc(T_wp, T_oz, qw)

% Kco- współczynnik
% qw - zapotrzebowanie na moc wszystkich pomieszczen
% suma mocy dla poszczególnych budynków

Kco = qw / (T_wp - T_oz);

end