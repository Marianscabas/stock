-- Creación de las 4 tablas de hechos del Data Warehouse

-- 1. Hechos Ausencias
CREATE TABLE IF NOT EXISTS rrhh_dw.hechos_ausencias (
  hecho_id BIGSERIAL PRIMARY KEY,
  fecha DATE,
  emp_sk BIGINT REFERENCES rrhh_dw.dim_empleado(emp_sk),
  dept_sk BIGINT REFERENCES rrhh_dw.dim_departamento(dept_sk), -- Cambiado a SK
  of_sk BIGINT REFERENCES rrhh_dw.dim_oficina(of_sk),         -- Cambiado a SK
  tipo_ausencia VARCHAR(100),
  dias_totales INT,
  justificada BOOLEAN
);

-- 2. Hechos Evaluaciones
CREATE TABLE IF NOT EXISTS rrhh_dw.hechos_evaluaciones (
  hecho_id BIGSERIAL PRIMARY KEY,
  fecha DATE,
  emp_sk BIGINT REFERENCES rrhh_dw.dim_empleado(emp_sk),
  evaluador_emp_sk BIGINT REFERENCES rrhh_dw.dim_empleado(emp_sk),
  calificacion NUMERIC(3,2)
);

-- 3. Hechos Capacitaciones
CREATE TABLE IF NOT EXISTS rrhh_dw.hechos_capacitaciones (
  hecho_id BIGSERIAL PRIMARY KEY,
  fecha DATE,
  emp_sk BIGINT REFERENCES rrhh_dw.dim_empleado(emp_sk),
  cap_sk BIGINT REFERENCES rrhh_dw.dim_capacitacion(cap_sk), -- Cambiado a SK
  estado VARCHAR(50),
  calificacion NUMERIC(5,2)
);

-- 4. Hechos Movimientos / Contrataciones - *Nueva tabla añadida*
CREATE TABLE IF NOT EXISTS rrhh_dw.hechos_movimientos (
  hecho_id BIGSERIAL PRIMARY KEY,
  fecha DATE,
  emp_sk BIGINT REFERENCES rrhh_dw.dim_empleado(emp_sk),
  dept_sk BIGINT REFERENCES rrhh_dw.dim_departamento(dept_sk),
  of_sk BIGINT REFERENCES rrhh_dw.dim_oficina(of_sk),
  tipo_movimiento VARCHAR(50), -- Ej: 'Contratación'
  salario NUMERIC(12,2)
);