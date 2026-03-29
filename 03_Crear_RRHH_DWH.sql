CREATE SCHEMA IF NOT EXISTS rrhh_dw;

CREATE TABLE IF NOT EXISTS rrhh_dw.etl_control (
    ejecucion_id SERIAL PRIMARY KEY,
    proceso VARCHAR(100),
    fecha_ejecucion TIMESTAMP DEFAULT now(),
    filas_afectadas INT
);