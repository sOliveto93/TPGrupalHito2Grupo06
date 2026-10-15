USE
`hito2`;

-- Deshabilitar restricciones de claves foráneas para la inserción limpia
SET
FOREIGN_KEY_CHECKS = 0;

-- Limpieza de tablas (opcional para reinicios de prueba)
TRUNCATE TABLE `detalle_pedido`;
TRUNCATE TABLE `pedido`;
TRUNCATE TABLE `plato`;
TRUNCATE TABLE `puesto_desarmable`;
TRUNCATE TABLE `foodtruck`;
TRUNCATE TABLE `cierre_de_caja`;
TRUNCATE TABLE `liquidacion_de_haberes`;
TRUNCATE TABLE `cocinero`;
TRUNCATE TABLE `cajero`;
TRUNCATE TABLE `staff`;
TRUNCATE TABLE `unidad_de_venta`;
TRUNCATE TABLE `usuario_rol`;
TRUNCATE TABLE `usuario`;
TRUNCATE TABLE `festival`;
TRUNCATE TABLE `costos`;

SET
FOREIGN_KEY_CHECKS = 1;


-- =====================================================
-- 1. CARGA DE COSTOS BASE
-- =====================================================
INSERT INTO `costos` (`id`, `costo_por_metro_cuadrado`, `costo_por_minuto_montaje`,
                      `plus_anual_antiguedad`, `plus_ayudante_cocina`, `plus_cocinero`,
                      `plus_electricidad`, `plus_lavaplatos`, `sueldo_base`)
VALUES (1, 500.00, 10.00, 5000.00, 100000.00, 150000.00, 2000.00, 50000.00, 100000.00),
       (2, 500.00, 10.00, 5000.00, 100000.00, 150000.00, 2000.00, 50000.00, 100000.00);

-- =====================================================
-- 2. CARGA DE FESTIVALES
-- =====================================================
INSERT INTO `festival` (`id`, `nombre`, `temporada`, fecha_inicio, `fecha_fin`, `costos_id`)
VALUES (1, 'Festival Gourmet Primavera', 'PRIMAVERA', '2026-10-01', '2026-10-20', 1),
       (2, 'Beer & Food Fest Verano', 'VERANO', '2026-12-01', '2026-12-15', 2);
-- =====================================================
-- 3. CARGA DE USUARIOS (Admin, Responsables y Empleados)
-- Nota: Las contraseñas representan credenciales encriptadas o temporales.
-- =====================================================
INSERT INTO `usuario` (`id`, `username`, `email`, `password`, `enabled`, `created_at`, `updated_at`)
VALUES (1, 'admin', 'admin@gmail.com', '$2a$10$RzFQ8VQWqT.fdjiQEF9QsOOHTxXoVCPYb/NH7i2XKr.oX1k6dlW7G', 1, NOW(), NOW()),
       (2, 'resp_burger', 'carlos@gmail.com', '$2a$10$0tGFv6jvDUX44yPbLkXSDOHuprjaOKfun54NyqamDK.dcsUEYbmUC', 1, NOW(),
        NOW()),
       (3, 'resp_puesto', 'ana@gmail.com', '$2a$10$qnpFjOeyB3sHzlbc8UPNYOvH05V5krzk5KY27XM2PPiXuOk3vl8L2', 1, NOW(),
        NOW()),
       (4, 'juan_cajero', 'nicoperez@gmail.com', '$2a$10$XlRcPD5QEPNYfC98ZRtehubLUhE.hkspQ6oCu3kvgCC0JTLDI9n.O', 1,
        NOW(), NOW()),
       (5, 'maria_chef', 'oscarruina@gmail.com', '$2a$10$EebqSsuNUtcmn0rFjlA0tOdF/9yr6BNN4TFV5yVCPNRwysJjdN8li', 1,
        NOW(), NOW());

-- Rol del Administrador del sistema
INSERT INTO `usuario_rol` (`id`, `usuario_id`, `rol`, `created_at`, `updated_at`)
VALUES (1, 1, 'ADMIN', NOW(), NOW());

-- =====================================================
-- 4. CARGA DE STAFF / PERSONAL
-- =====================================================
INSERT INTO `staff` (`id`, `usuario_id`, `name`, `apelido`, `dni`, `fecha_nac`, `fecha_ingreso`, `activo`, `fecha_baja`,
                     `unidad_venta_id`)
VALUES (1, 2, 'Carlos', 'Ríos', '30111222', '1985-05-12', '2020-03-01', 1, NULL, NULL),
       (2, 3, 'Ana', 'Martínez', '32333444', '1988-08-20', '2021-06-15', 1, NULL, NULL),
       (3, 4, 'Juan', 'Pérez', '38555666', '1995-02-10', '2022-01-10', 1, NULL, NULL),
       (4, 5, 'María', 'Gómez', '36777888', '1992-11-05', '2021-02-01', 1, NULL, NULL);

-- Subtipos de Empleados
INSERT INTO `cajero` (`id`, `turno`)
VALUES (3, 'MANIANA');
INSERT INTO `cocinero` (`id`, `categoria`)
VALUES (4, 'COCINERO');

-- =====================================================
-- 5. CARGA DE UNIDADES DE VENTA (Food Trucks y Puestos Desarmables)
-- Códigos únicos de 10 caracteres según requerimientos del TP.
-- =====================================================
INSERT INTO `unidad_de_venta` (`id`, `codigo`, `nombre_comercial`, `superficie`, `festival_id`, `responsable_id`)
VALUES (1, 'FTKBURGER1', 'Burger Truck Express', 25.00, 1, 1),
       (2, 'PSTTACOS01', 'Puesto Tacos & Co', 15.00, 1, 2);

-- Asignación de unidades de venta al personal
UPDATE `staff`
SET `unidad_venta_id` = 1
WHERE `id` IN (1, 3, 4);
UPDATE `staff`
SET `unidad_venta_id` = 2
WHERE `id` = 2;

-- Subtipos de Unidades de Venta
INSERT INTO `foodtruck` (`id`, `patente`, `requiere_electricidad`)
VALUES (1, 'AA123CD', 1);
INSERT INTO `puesto_desarmable` (`id`, `cantidad_carpas`, `tiempo_montaje_minutos`)
VALUES (2, 2, 45);

-- =====================================================
-- 6. CARGA DE PLATOS DEL MENÚ
-- =====================================================
INSERT INTO `plato` (`id`, `nombre`, `precio`, `costo`, `activo`, `unidad_venta_id`)
VALUES (1, 'Hamburguesa Doble Queso', 8500.00, 3200.00, 1, 1),
       (2, 'Papas Rústicas', 4000.00, 1200.00, 1, 1),
       (3, 'Taco de Carne x3', 7500.00, 2800.00, 1, 2);

-- =====================================================
-- 7. CARGA DE PEDIDOS Y SUS DETALLES (VENTAS)
-- =====================================================
INSERT INTO `pedido` (`id`, `fecha_hora`, `unidad_venta_id`)
VALUES (1, '2026-10-05 13:30:00', 1),
       (2, '2026-10-05 14:15:00', 1),
       (3, '2026-10-05 20:00:00', 2);

INSERT INTO `detalle_pedido` (`id`, `pedido_id`, `plato_id`, `cantidad`, `precio_unitario`, `subtotal`)
VALUES (1, 1, 1, 2, 8500.00, 17000.00),
       (2, 1, 2, 1, 4000.00, 4000.00),
       (3, 2, 1, 1, 8500.00, 8500.00),
       (4, 3, 3, 3, 7500.00, 22500.00);

-- =====================================================
-- 8. CIERRES DE CAJA Y LIQUIDACIÓN DE HABERES (PRUEBAS DE REPORTES)
-- =====================================================
INSERT INTO `cierre_de_caja` (`id`, `cajero_id`, `festival_id`, `unidad_venta_id`,
                              `fecha_hora_cierre`, `total_sistema`, `total_declarado`, `diferencia`)
VALUES (1, 3, 1, 1,
        '2026-10-05 23:00:00', 29500.00, 29500.00, 0.00);

INSERT INTO `liquidacion_de_haberes` (`id`, `empleado_id`, `festival_id`, `fecha`,
                                      `dias_festival`, `sueldo`, `adicional_aplicado`, `factor_aplicado`, `total`)
VALUES (1, 3, 1, '2026-10-20',
        20, 100000.00, 20000.00, 1.00, 120000.00);