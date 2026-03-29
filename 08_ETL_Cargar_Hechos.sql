-- Carga de las 4 tablas de hechos mapeando hacia las llaves subrogadas (_sk)

-- 1. Carga hechos: Ausencias
CREATE OR REPLACE FUNCTION rrhh_dw.cargar_hechos_ausencias()
RETURNS void LANGUAGE plpgsql AS 
$$
BEGIN
  INSERT INTO rrhh_dw.hechos_ausencias(fecha, emp_sk, dept_sk, of_sk, tipo_ausencia, dias_totales, justificada)
  SELECT a.fecha_inicio,
         e.emp_sk,
         d.dept_sk,
         o.of_sk,
         a.tipo_ausencia,
         a.dias_totales,
         a.justificada
  FROM oltp.ausencias a
  JOIN rrhh_dw.dim_empleado e ON e.empleado_id = a.empleado_id AND e.vigente = true
  LEFT JOIN rrhh_dw.dim_departamento d ON d.departamento_id = e.departamento_id AND d.vigente = true
  LEFT JOIN rrhh_dw.dim_oficina o ON o.codigo_oficina = e.codigo_oficina AND o.vigente = true
  WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_dw.hechos_ausencias f 
    WHERE f.fecha = a.fecha_inicio AND f.emp_sk = e.emp_sk AND f.tipo_ausencia = a.tipo_ausencia
  );
END;
$$
;

-- 2. Carga hechos: Evaluaciones
CREATE OR REPLACE FUNCTION rrhh_dw.cargar_hechos_evaluaciones()
RETURNS void LANGUAGE plpgsql AS 
$$
BEGIN
  INSERT INTO rrhh_dw.hechos_evaluaciones(fecha, emp_sk, evaluador_emp_sk, calificacion)
  SELECT ev.fecha_evaluacion,
         e.emp_sk,
         evr.emp_sk,
         ev.calificacion
  FROM oltp.evaluaciones ev
  JOIN rrhh_dw.dim_empleado e ON e.empleado_id = ev.empleado_id AND e.vigente = true
  LEFT JOIN rrhh_dw.dim_empleado evr ON evr.empleado_id = ev.evaluador_id AND evr.vigente = true
  WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_dw.hechos_evaluaciones f 
    WHERE f.fecha = ev.fecha_evaluacion AND f.emp_sk = e.emp_sk AND f.calificacion = ev.calificacion
  );
END;
$$
;

-- 3. Carga hechos: Capacitaciones
CREATE OR REPLACE FUNCTION rrhh_dw.cargar_hechos_capacitaciones()
RETURNS void LANGUAGE plpgsql AS 
$$
BEGIN
  INSERT INTO rrhh_dw.hechos_capacitaciones(fecha, emp_sk, cap_sk, estado, calificacion)
  SELECT ec.fecha_completado::date,
         e.emp_sk,
         c.cap_sk,
         ec.estado,
         ec.calificacion
  FROM oltp.empleados_capacitaciones ec
  JOIN rrhh_dw.dim_empleado e ON e.empleado_id = ec.empleado_id AND e.vigente = true
  JOIN rrhh_dw.dim_capacitacion c ON c.capacitacion_id = ec.capacitacion_id AND c.vigente = true
  WHERE ec.fecha_completado IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM rrhh_dw.hechos_capacitaciones f 
      WHERE f.fecha = ec.fecha_completado::date AND f.emp_sk = e.emp_sk AND f.cap_sk = c.cap_sk
    );
END;
$$
;

-- 4. Carga hechos: Movimientos (NUEVO)
CREATE OR REPLACE FUNCTION rrhh_dw.cargar_hechos_movimientos()
RETURNS void LANGUAGE plpgsql AS 
$$
BEGIN
  INSERT INTO rrhh_dw.hechos_movimientos(fecha, emp_sk, dept_sk, of_sk, tipo_movimiento, salario)
  SELECT oe.fecha_contratacion,
         e.emp_sk,
         d.dept_sk,
         o.of_sk,
         'Contratación' AS tipo_movimiento,
         oe.salario_actual
  FROM oltp.empleados oe
  JOIN rrhh_dw.dim_empleado e ON e.empleado_id = oe.empleado_id AND e.vigente = true
  LEFT JOIN rrhh_dw.dim_departamento d ON d.departamento_id = e.departamento_id AND d.vigente = true
  LEFT JOIN rrhh_dw.dim_oficina o ON o.codigo_oficina = e.codigo_oficina AND o.vigente = true
  WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_dw.hechos_movimientos f 
    WHERE f.fecha = oe.fecha_contratacion AND f.emp_sk = e.emp_sk AND f.tipo_movimiento = 'Contratación'
  );
END;
$$
;