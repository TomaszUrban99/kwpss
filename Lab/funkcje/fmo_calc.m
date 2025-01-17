function [fmo] = fmo_calc( qwN, cpw, Toz, Top)

% fmo_calc- wyliczenie wypływu wody z wymiennika ciepła
%   
%   -> cpw- ciepło właściwe medium
%   -> Toz- temperatura wypływająca z wymiennika w kierunku
%           pomieszczeń
%   -> Top- temperatura wpływająca do wymiennika z kierunku
%           pomieszczeń

fmo = qwN / ( cpw * ( Toz - Top ));

end