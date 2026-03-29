-- Procedimientos SCD Tipo 2 para las 4 dimensiones principales

-- 1. Función SCD2: Oficinas
CREATE OR REPLACE FUNCTION rrhh_dw.scd2_upsert_oficinas()
RETURNS void LANGUAGE plpgsql AS 
$$
DECLARE
  r RECORD;
  existing RECORD;
BEGIN
  FOR r IN SELECT * FROM oltp.oficinas LOOP
    SELECT * INTO existing FROM rrhh_dw.dim_oficina WHERE codigo_oficina = r.codigo_oficina AND vigente = true LIMIT 1;
    IF NOT FOUND THEN
      INSERT INTO rrhh_dw.dim_oficina(codigo_oficina, nombre, ciudad, pais) VALUES (r.codigo_oficina, r.nombre, r.ciudad, r.pais);
    ELSE
      IF existing.nombre IS DISTINCT FROM r.nombre OR existing.ciudad IS DISTINCT FROM r.ciudad OR existing.pais IS DISTINCT FROM r.pais THEN
        UPDATE rrhh_dw.dim_oficina SET fecha_fin_vigencia = now(), vigente = false WHERE of_sk = existing.of_sk;
        INSERT INTO rrhh_dw.dim_oficina(codigo_oficina, nombre, ciudad, pais) VALUES (r.codigo_oficina, r.nombre, r.ciudad, r.pais);
      END IF;
    END IF;
  END LOOP;
END;
$$
;

-- 2. Función SCD2: Departamentos
CREATE OR REPLACE FUNCTION rrhh_dw.scd2_upsert_departamentos()
RETURNS void LANGUAGE plpgsql AS 
$$
DECLARE
  r RECORD;
  existing RECORD;
BEGIN
  FOR r IN SELECT d.* FROM oltp.departamentos d LOOP
    SELECT * INTO existing FROM rrhh_dw.dim_departamento WHERE departamento_id = r.departamento_id AND vigente = true LIMIT 1;
    IF NOT FOUND THEN
      INSERT INTO rrhh_dw.dim_departamento(departamento_id, nombre, codigo_oficina) VALUES (r.departamento_id, r.nombre, r.codigo_oficina);
    ELSE
      IF existing.nombre IS DISTINCT FROM r.nombre OR existing.codigo_oficina IS DISTINCT FROM r.codigo_oficina THEN
        UPDATE rrhh_dw.dim_departamento SET fecha_fin_vigencia = now(), vigente = false WHERE dept_sk = existing.dept_sk;
        INSERT INTO rrhh_dw.dim_departamento(departamento_id, nombre, codigo_oficina) VALUES (r.departamento_id, r.nombre, r.codigo_oficina);
      END IF;
    END IF;
  END LOOP;
END;
$$
;

-- 3. Función SCD2: Empleados
CREATE OR REPLACE FUNCTION rrhh_dw.scd2_upsert_empleados()
RETURNS void LANGUAGE plpgsql AS 
$$
DECLARE
  r RECORD;
  existing RECORD;
BEGIN
  FOR r IN SELECT e.* FROM oltp.empleados e LOOP
    SELECT * INTO existing FROM rrhh_dw.dim_empleado WHERE empleado_id = r.empleado_id AND vigente = true LIMIT 1;
    IF NOT FOUND THEN
      INSERT INTO rrhh_dw.dim_empleado(empleado_id, nombre, apellidos, genero, fecha_nacimiento, fecha_contratacion, salario_actual, departamento_id, codigo_oficina, jefe_id)
      VALUES (r.empleado_id, r.nombre, r.apellidos, r.genero, r.fecha_nacimiento, r.fecha_contratacion, r.salario_actual, r.departamento_id, r.codigo_oficina, r.jefe_id);
    ELSE
      IF existing.nombre IS DISTINCT FROM r.nombre OR existing.apellidos IS DISTINCT FROM r.apellidos OR
         existing.salario_actual IS DISTINCT FROM r.salario_actual OR existing.departamento_id IS DISTINCT FROM r.departamento_id OR
         existing.codigo_oficina IS DISTINCT FROM r.codigo_oficina OR existing.jefe_id IS DISTINCT FROM r.jefe_id THEN
        UPDATE rrhh_dw.dim_empleado SET fecha_fin_vigencia = now(), vigente = false WHERE emp_sk = existing.emp_sk;
        INSERT INTO rrhh_dw.dim_empleado(empleado_id, nombre, apellidos, genero, fecha_nacimiento, fecha_contratacion, salario_actual, departamento_id, codigo_oficina, jefe_id)
        VALUES (r.empleado_id, r.nombre, r.apellidos, r.genero, r.fecha_nacimiento, r.fecha_contratacion, r.salario_actual, r.departamento_id, r.codigo_oficina, r.jefe_id);
      END IF;
    END IF;
  END LOOP;
END;
$$
;

-- 4. Función SCD2: Capacitaciones (Nuevo ETL)
CREATE OR REPLACE FUNCTION rrhh_dw.scd2_upsert_capacitaciones()
RETURNS void LANGUAGE plpgsql AS 
$$
DECLARE
  r RECORD;
  existing RECORD;
BEGIN
  FOR r IN SELECT * FROM oltp.capacitaciones LOOP
    SELECT * INTO existing FROM rrhh_dw.dim_capacitacion WHERE capacitacion_id = r.capacitacion_id AND vigente = true LIMIT 1;
    IF NOT FOUND THEN
      INSERT INTO rrhh_dw.dim_capacitacion(capacitacion_id, nombre, proveedor, costo) VALUES (r.capacitacion_id, r.nombre, r.proveedor, r.costo);
    ELSE
      IF existing.nombre IS DISTINCT FROM r.nombre OR existing.proveedor IS DISTINCT FROM r.proveedor OR existing.costo IS DISTINCT FROM r.costo THEN
        UPDATE rrhh_dw.dim_capacitacion SET fecha_fin_vigencia = now(), vigente = false WHERE cap_sk = existing.cap_sk;
        INSERT INTO rrhh_dw.dim_capacitacion(capacitacion_id, nombre, proveedor, costo) VALUES (r.capacitacion_id, r.nombre, r.proveedor, r.costo);
      END IF;
    END IF;
  END LOOP;
END;
$$
;