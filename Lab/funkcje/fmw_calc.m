function [fmw] = fmw_calc( qw, cpw, Twz, Twp )

% Policzenie przeplywu dla wymiennika ciepla
% cpw fmw ( Twz - Twp ) = Kco (Twp - Toz) = qw
% qw - calkowita moc wymiennika 
% ( suma mocy dla poszczegolnych pomieszczen )

fmw = qw / ( cpw * ( Twz - Twp ) );

end