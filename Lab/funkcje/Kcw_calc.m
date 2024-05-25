function [Kcw] = Kcw_calc(Kcg, Tgp, Twew, Tzew )

% Kcw_calc


Kcw = Kcg * ( Tgp - Twew ) / ( Twew - Tzew );

end