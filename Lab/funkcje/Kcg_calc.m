function [Kcg] = Kcg_calc(q_gN, T_gpN, T_wN)

Kcg = q_gN / ( T_gpN - T_wN );

end