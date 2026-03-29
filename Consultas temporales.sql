
SELECT rrhh_dw.cargar_hechos_ausencias();
SELECT rrhh_dw.cargar_hechos_evaluaciones();
SELECT rrhh_dw.cargar_hechos_capacitaciones();
SELECT rrhh_dw.cargar_hechos_movimientos();
SELECT rrhh_dw.scd2_upsert_capacitaciones();

SELECT * FROM rrhh_dw.dim_oficina;
SELECT * FROM rrhh_dw.dim_empleado;
SELECT * FROM rrhh_dw.dim_departamento;

SELECT * FROM oltp.oficinas;
SELECT * FROM oltp.departamentos;
SELECT * FROM oltp.ausencias;

-- 1. Revisar las nuevas dimensiones
SELECT * FROM rrhh_dw.dim_capacitacion;

-- 2. Revisar los hechos (Verás que ahora todo son puros números (IDs) apuntando a las dimensiones)
SELECT * FROM rrhh_dw.hechos_ausencias;
SELECT * FROM rrhh_dw.hechos_evaluaciones;
SELECT * FROM rrhh_dw.hechos_capacitaciones;
SELECT * FROM rrhh_dw.hechos_movimientos;