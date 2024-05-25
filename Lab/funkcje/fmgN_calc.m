function [fmgN] = fmgN_calc(q_gN, cpw, T_gzN, T_gpN)

% Policzenie przepływu dla pojedynczego pomieszczenia

fmgN = q_gN / ( cpw * ( T_gzN - T_gpN));

end