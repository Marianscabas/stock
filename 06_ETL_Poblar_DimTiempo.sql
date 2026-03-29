-- Procedimiento para generar y poblar la dimensión de tiempo (Dim_Tiempo)

-- Procedimiento que puebla dim_tiempo entre dos fechas (nombres en español)
CREATE OR REPLACE FUNCTION rrhh_dw.poblar_dim_tiempo(p_inicio DATE, p_fin DATE)
RETURNS void LANGUAGE plpgsql AS 
$$
DECLARE
  d DATE := p_inicio;
BEGIN
  IF p_fin < p_inicio THEN
    RAISE EXCEPTION 'p_fin debe ser mayor o igual a p_inicio';
  END IF;
  
  WHILE d <= p_fin LOOP
    INSERT INTO rrhh_dw.dim_tiempo(fecha, dia, mes, anio, nombre_mes, trimestre, dia_semana, nombre_dia, es_fin_de_semana)
    VALUES (
      d,
      EXTRACT(DAY FROM d)::int,
      EXTRACT(MONTH FROM d)::int,
      EXTRACT(YEAR FROM d)::int,
      to_char(d,'Month'),
      EXTRACT(QUARTER FROM d)::int,
      EXTRACT(ISODOW FROM d)::int,
      to_char(d,'Day'),
      (EXTRACT(ISODOW FROM d) IN (6,7))
    ) ON CONFLICT (fecha) DO NOTHING;
    
    d := d + INTERVAL '1 day';
  END LOOP;
END;
$$
;

-- Ejemplo de uso (esto lo ejecutarás cuando llames a tus consultas finales):
-- SELECT rrhh_dw.poblar_dim_tiempo('2020-01-01','2030-12-31');