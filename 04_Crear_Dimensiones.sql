-- Creación de las 5 dimensiones del Data Warehouse con SCD Tipo 2
-- 1. Dimensión Tiempo
CREATE TABLE IF NOT EXISTS rrhh_dw.dim_tiempo (
  fecha DATE PRIMARY KEY,
  dia INT,
  mes INT,
  anio INT,
  nombre_mes VARCHAR(20),
  trimestre INT,
  dia_semana INT,
  nombre_dia VARCHAR(20),
  es_fin_de_semana BOOLEAN
);

-- 2. Dimensión Oficina
CREATE TABLE IF NOT EXISTS rrhh_dw.dim_oficina (
  of_sk SERIAL PRIMARY KEY,
  codigo_oficina VARCHAR(50) NOT NULL,
  nombre VARCHAR(150),
  ciudad VARCHAR(100),
  pais VARCHAR(100),
  fecha_inicio_vigencia TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_fin_vigencia TIMESTAMP WITHOUT TIME ZONE,
  vigente BOOLEAN DEFAULT TRUE
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_oficina_codigo_vigente ON rrhh_dw.dim_oficina(codigo_oficina, vigente) WHERE vigente;

-- 3. Dimensión Departamento
CREATE TABLE IF NOT EXISTS rrhh_dw.dim_departamento (
  dept_sk SERIAL PRIMARY KEY,
  departamento_id VARCHAR(50) NOT NULL,
  nombre VARCHAR(150),
  codigo_oficina VARCHAR(50),
  fecha_inicio_vigencia TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_fin_vigencia TIMESTAMP WITHOUT TIME ZONE,
  vigente BOOLEAN DEFAULT TRUE
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_dept_codigo_vigente ON rrhh_dw.dim_departamento(departamento_id, vigente) WHERE vigente;

-- 4. Dimensión Empleado
CREATE TABLE IF NOT EXISTS rrhh_dw.dim_empleado (
  emp_sk BIGSERIAL PRIMARY KEY,
  empleado_id VARCHAR(20) NOT NULL,
  nombre VARCHAR(100),
  apellidos VARCHAR(100),
  genero VARCHAR(20),
  fecha_nacimiento DATE,
  fecha_contratacion DATE,
  salario_actual NUMERIC(12,2),
  departamento_id VARCHAR(50),
  codigo_oficina VARCHAR(50),
  jefe_id VARCHAR(20),
  fecha_inicio_vigencia TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_fin_vigencia TIMESTAMP WITHOUT TIME ZONE,
  vigente BOOLEAN DEFAULT TRUE
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_emp_id_vigente ON rrhh_dw.dim_empleado(empleado_id, vigente) WHERE vigente;

-- 5. Dimensión Capacitaciones
CREATE TABLE IF NOT EXISTS rrhh_dw.dim_capacitacion (
  cap_sk SERIAL PRIMARY KEY,
  capacitacion_id INT NOT NULL,
  nombre VARCHAR(150),
  proveedor VARCHAR(100),
  costo NUMERIC(10,2),
  fecha_inicio_vigencia TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  fecha_fin_vigencia TIMESTAMP WITHOUT TIME ZONE,
  vigente BOOLEAN DEFAULT TRUE
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_cap_id_vigente ON rrhh_dw.dim_capacitacion(capacitacion_id, vigente) WHERE vigente;