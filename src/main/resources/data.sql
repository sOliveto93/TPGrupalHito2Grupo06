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
TRUNCATE TABLE `historial_unidad`;
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
VALUES  (1, 450.00,  8.00,  4000.00,  80000.00, 120000.00, 1500.00, 40000.00,  90000.00),
    (2, 500.00, 10.00,  5000.00,  90000.00, 135000.00, 1800.00, 45000.00, 100000.00),
    (3, 550.00, 12.00,  6000.00, 100000.00, 150000.00, 2000.00, 50000.00, 110000.00),
    (4, 600.00, 14.00,  7000.00, 110000.00, 165000.00, 2200.00, 55000.00, 120000.00),
    (5, 650.00, 16.00,  8000.00, 120000.00, 180000.00, 2500.00, 60000.00, 130000.00),
    (6, 700.00, 18.00,  9000.00, 130000.00, 195000.00, 2800.00, 65000.00, 140000.00);

-- =====================================================
-- 2. CARGA DE FESTIVALES
-- =====================================================
INSERT INTO `festival` (`id`, `nombre`, `temporada`, `fecha_inicio`, `fecha_fin`, `costos_id`)
VALUES  (1, 'Festival Gourmet Primavera', 'PRIMAVERA', '2026-08-01', '2026-09-10', 1),
        (2, 'Beer & Food Fest Verano',   'VERANO',    '2026-10-15', '2026-11-15', 2),
        (3, 'Sabores de Otoño',          'OTONIO',    '2026-11-20', '2026-12-15', 3),
        (4, 'Festival del Invierno',     'INVIERNO',  '2027-05-10', '2027-06-30', 4),
        (5, 'Buenos Aires Street Food',  'VERANO',    '2027-01-10', '2027-02-10', 5),
        (6, 'Sabores Fest',              'VERANO',    '2027-03-01', '2027-04-01', 6);
-- =====================================================
-- 3. CARGA DE USUARIOS (Admin, Responsables y Empleados)
-- Nota: Las contraseñas representan credenciales encriptadas o temporales.
-- =====================================================
INSERT INTO `usuario` (`id`, `username`, `email`, `password`, `enabled`, `created_at`, `updated_at`)
VALUES (1, 'admin', 'admin@gmail.com', '$2a$10$RzFQ8VQWqT.fdjiQEF9QsOOHTxXoVCPYb/NH7i2XKr.oX1k6dlW7G', 1, NOW(), NOW()),
       (2, 'carlos', 'carlos@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(),
        NOW()),
       (3, 'ana', 'ana@gmail.com', '$2a$10$rIS5FuCO1WNim36pDg.l.uLUhnqpADWjZM/sp1v8azwiG5z2h2Fjq', 1, NOW(),
        NOW()),
       (4, 'nico', 'nicoperez@gmail.com', '$2a$10$cENPqtKpKgykc8ns6gdhbe8RxWDJO2qJfSrJ.xLdRDrtPzmdhpsjm', 1,
        NOW(), NOW()),
       (5, 'oscar', 'oscarruina@gmail.com', '$2a$10$vqLPPp.UsUIz5FgKJmgxjOU5VziUIARlkuBNLJO/Hj415vUFIHlly', 1,
        NOW(), NOW()),
        (6,'lucasfernandez','lucasfernandez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(7,'martinrodriguez','martinrodriguez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(8,'valentinagomez','valentinagomez@gmail.com','$2a$10$oQ6SN6cUbY1yZ/q2iSsosuJtQfSOvDgurrm/AJjsqZztDyaG8Qz1a',1,NOW(),NOW()),
(9,'sofiaMartinez','sofiamartinez@gmail.com','$2a$10$d8iTixyiE/I9/ftsUctiwOmpfhavAL291NJvFTllTbgy9L9IKWXHC',1,NOW(),NOW()),
(10,'facundolopez','facundolopez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(11,'camilaromero','camilaromero@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(12,'tomasdiaz','tomasdiaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(13,'florenciatorres','florenciatorres@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(14,'nicolasacosta','nicolasacosta@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(15,'julietasuarez','julietasuarez@gmail.com','$2a$10$S0qV0d86WwtOcgGEMoxupOHRRAPJIBaawTn7tJJpC2gfuwhkjb2/W',1,NOW(),NOW()),
(16,'mateosilva','mateosilva@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(17,'agustinromero','agustinromero@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(18,'martinaflores','martinaflores@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(19,'santiagomendez','santiagomendez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(20,'milagroscastro','milagroscastro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(21, 'ayudanteCocina1', 'ayudanteCocina1@gmail.com', '$2a$10$R22RocfHjczVQQhlWidXs.miyU3hDvb2Imwm9UOPtCyu1LyuSNqTq', 1, NOW(), NOW()),
(22,'abrilnavarro','abrilnavarro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(23,'joaquinpereyra','joaquinpereyra@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(24,'raul','raul@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(25,'franciscovargas','franciscovargas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(26,'emiliapaz','emiliapaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(27,'micaela','micaela@gmail.com','$2a$10$FBid1DnXmpq2U3inPf4Pl.FScdumDHIkVJJ9.ZB63MUTtSeaDZEdy',1,NOW(),NOW()),
(28,'renatamolina','renatamolina@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(29,'brunocabrera','brunocabrera@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(30, 'empleado30', 'empleado30@gmail.com', 'COPIAR_HASH_PASSWORD_EXISTENTE', 1, NOW(), NOW()),
(31, 'empleado31', 'empleado31@gmail.com', 'COPIAR_HASH_PASSWORD_EXISTENTE', 1, NOW(), NOW()),
(32, 'empleado32', 'empleado32@gmail.com', 'COPIAR_HASH_PASSWORD_EXISTENTE', 1, NOW(), NOW());
-- Rol del Administrador del sistema
INSERT INTO `usuario_rol` (`id`, `usuario_id`, `rol`, `created_at`, `updated_at`)
VALUES (1, 1, 'ROLE_ADMINISTRADOR', NOW(), NOW()),
       (2, 2, 'ROLE_RESPONSABLE', NOW(), NOW()),
       (3, 3, 'ROLE_RESPONSABLE', NOW(), NOW()),
       (4, 4, 'ROLE_RESPONSABLE', NOW(), NOW()),
       (5, 5, 'ROLE_RESPONSABLE', NOW(), NOW()),
       (6,6,'ROLE_RESPONSABLE',NOW(),NOW()),
       (7,7,'ROLE_RESPONSABLE',NOW(),NOW()),
       (8,8,'ROLE_EMPLEADO',NOW(),NOW()),
        (9,9,'ROLE_EMPLEADO',NOW(),NOW()),
        (10,10,'ROLE_EMPLEADO',NOW(),NOW()),
        (11,11,'ROLE_EMPLEADO',NOW(),NOW()),
        (12,12,'ROLE_EMPLEADO',NOW(),NOW()),
        (13,13,'ROLE_EMPLEADO',NOW(),NOW()),
        (14,14,'ROLE_EMPLEADO',NOW(),NOW()),
        (15,15,'ROLE_EMPLEADO',NOW(),NOW()),
        (16,16,'ROLE_EMPLEADO',NOW(),NOW()),
        (17,17,'ROLE_EMPLEADO',NOW(),NOW()),
        (18,18,'ROLE_EMPLEADO',NOW(),NOW()),
        (19,19,'ROLE_EMPLEADO',NOW(),NOW()),
        (20,20,'ROLE_EMPLEADO',NOW(),NOW()),
        (21, 21, 'ROLE_EMPLEADO', NOW(), NOW()),
        (22, 22, 'ROLE_EMPLEADO', NOW(), NOW()),
        (23, 23, 'ROLE_EMPLEADO', NOW(), NOW()),
        (24, 24, 'ROLE_EMPLEADO', NOW(), NOW()),
        (25, 25, 'ROLE_EMPLEADO', NOW(), NOW()),
        (26, 26, 'ROLE_EMPLEADO', NOW(), NOW()),
        (27, 27, 'ROLE_EMPLEADO', NOW(), NOW()),
        (28, 28, 'ROLE_EMPLEADO', NOW(), NOW()),
        (29, 29, 'ROLE_EMPLEADO', NOW(), NOW()),
        (30, 30, 'ROLE_EMPLEADO', NOW(), NOW()),
        (31, 31, 'ROLE_EMPLEADO', NOW(), NOW()),
        (32, 32, 'ROLE_EMPLEADO', NOW(), NOW());

-- =====================================================
-- 4. CARGA DE STAFF / PERSONAL
-- =====================================================
INSERT INTO `staff` (`id`, `usuario_id`, `name`, `apellido`, `dni`, `fecha_nac`, `fecha_ingreso`, `activo`, `fecha_baja`, `unidad_venta_id`)
VALUES
(2, 2, 'Carlos', 'Ríos', '30111222', '1985-05-12', '2026-08-01', 1, NULL, NULL),
(3, 3, 'Ana', 'Martínez', '32333444', '1988-08-20', '2026-08-01', 1, NULL, NULL),
(4, 4, 'Juan', 'Pérez', '38555666', '1995-02-10', '2026-08-01', 1, NULL, NULL),
(5, 5, 'María', 'Gómez', '36777888', '1992-11-05', '2026-08-01', 1, NULL, NULL),
(6, 6, 'Lucas', 'Fernández', '80000001', '1990-01-01', '2026-08-01', 1, NULL, NULL),
(7, 7, 'Martín', 'Rodríguez', '81000001', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(8, 8, 'Valentina', 'Gómez', '82000001', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(9, 9, 'Sofía', 'Martínez', '80000002', '1990-01-01', '2026-08-01', 1, NULL, NULL),
(10, 10, 'Facundo', 'López', '81000002', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(11, 11, 'Camila', 'Romero', '82000002', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(12, 12, 'Tomás', 'Díaz', '80000003', '1990-01-01', '2026-08-01', 1, NULL, NULL),
(13, 13, 'Florencia', 'Torres', '81000003', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(14, 14, 'Nicolás', 'Acosta', '82000003', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(15, 15, 'Julieta', 'Suárez', '80000004', '1990-01-01', '2026-08-01', 1, NULL, NULL),
(16, 16, 'Mateo', 'Silva', '81000004', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(17, 17, 'Agustín', 'Romero', '82000004', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(18, 18, 'Martina', 'Flores', '80000005', '1990-01-01', '2026-08-01', 1, NULL, NULL),
(19, 19, 'Santiago', 'Méndez', '81000005', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(20, 20, 'Milagros', 'Castro', '82000005', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(21, 21, 'empleado21', 'empleado21', '83200005', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(22, 22, 'Abril', 'Navarro', '81000006', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(23, 23, 'Joaquín', 'Pereyra', '82000506', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(24, 24, 'raul', 'gomez', '82003006', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(25, 25, 'Francisco', 'Vargas', '81000007', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(26, 26, 'Emilia', 'Paz', '82000207', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(27, 27, 'micaela', 'fernandez', '82010207', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(28, 28, 'Renata', 'Molina', '81000008', '1995-01-01', '2026-08-01', 1, NULL, NULL),
(29, 29, 'Bruno', 'Cabrera', '82000008', '1992-01-01', '2026-08-01', 1, NULL, NULL),
(30, 30, 'Empleado', 'Veintiuno', '41000021', '1998-01-21', '2026-08-01', 1, NULL, NULL),
(31, 31, 'Empleado', 'empeleado', '41000024', '1998-04-24', '2026-08-01', 1, NULL, NULL),
(32, 32, 'Empleado', 'empeleado', '41000027', '1998-07-27', '2026-08-01', 1, NULL, NULL);



-- =====================================================
-- SUBTIPOS DE EMPLEADOS
-- =====================================================
INSERT INTO `cajero` (`id`, `turno`)
VALUES
    (8,  'MANIANA'),
    (9,  'TARDE'),
    (10, 'NOCHE'),
    (11, 'MANIANA'),
    (12, 'TARDE'),
    (13, 'NOCHE'),
    (14, 'MANIANA');


-- 4 cocineros
-- 3 ayudantes de cocina
-- 3 lavaplatos
INSERT INTO `cocinero` (`id`, `categoria`)
VALUES
    (15,  'COCINERO'),
    (16,  'COCINERO'),
    (17,  'COCINERO'),
    (18, 'COCINERO'),
    (19, 'COCINERO'),
    (20, 'COCINERO'),

    (21, 'AYUDANTE_COCINA'),
    (22, 'AYUDANTE_COCINA'),
    (23, 'AYUDANTE_COCINA'),
    (24, 'AYUDANTE_COCINA'),
    (25, 'AYUDANTE_COCINA'),
    (26, 'AYUDANTE_COCINA'),
    
    (27, 'LAVAPLATOS'),
    (28,'LAVAPLATOS'),
    (29, 'LAVAPLATOS'),
    (30,'LAVAPLATOS'),
    (31, 'LAVAPLATOS'),
    (32, 'LAVAPLATOS');


-- =====================================================
-- 5. CARGA DE UNIDADES DE VENTA (Food Trucks y Puestos Desarmables)
-- Códigos únicos de 10 caracteres según requerimientos del TP.
-- =====================================================
-- Responsables: un responsable por unidad.
INSERT INTO unidad_de_venta
    (id, codigo, nombre_comercial, superficie, festival_id, responsable_id,caja_abierta)
VALUES
    (1,  'FT00000001', 'Panchos Truck',        25.00, 1, 2,TRUE),
    (2,  'PD00000001', 'Puesto de Tacos',      15.00, 1, 3,TRUE),
    (3,  'FT00000002', 'Burger Truck',          25.00, 1, 4,TRUE),
    (4,  'PD00000002', 'Puesto de Tacos',      15.00, 1, 5,TRUE),
    (5,  'FT00000003', 'Pizza al Paso',         20.00, 1, 6,TRUE),
    (6,  'PD00000003', 'Puesto de Empanadas',   12.00, 1, 7,TRUE),
    (8,  'FT00000004', 'Burger Fest',           25.00, 2, 2,TRUE),
    (9,  'PD00000004', 'Tacos Fest',            15.00, 2, 3,TRUE),
    (10, 'FT00000005', 'Pizza Fest',            20.00, 2, 4,TRUE),
    (11, 'PD00000005', 'Empanadas Fest',        12.00, 2, 5,TRUE),
    (12, 'FT00000006', 'Gourmet Fest',          22.00, 2, 6,TRUE),
    (13, 'FT00000007', 'Burger de Otoño',       25.00, 3, 7,TRUE),
    (14, 'PD00000006', 'Tacos de Otoño',        15.00, 3, 2,TRUE),
    (15, 'FT00000008', 'Pizza de Otoño',        20.00, 3, 3,TRUE),
    (16, 'PD00000007', 'Empanadas de Otoño',    12.00, 3, 4,TRUE),
    (17, 'FT00000009', 'Sabores Gourmet',       22.00, 3, 5,TRUE),
    (18, 'FT00000010', 'Burger de Invierno',    25.00, 4, 6,TRUE),
    (19, 'PD00000008', 'Tacos de Invierno',     15.00, 4, 7,TRUE),
    (20, 'FT00000011', 'Pizza de Invierno',     20.00, 4, 2,TRUE),
    (21, 'PD00000009', 'Empanadas Calientes',   12.00, 4, 3,TRUE),
    (22, 'FT00000012', 'Gourmet de Invierno',   22.00, 4, 4,TRUE),
    (23, 'FT00000013', 'Street Burger',         25.00, 5, 5,TRUE),
    (24, 'PD00000010', 'Street Tacos',          15.00, 5, 6,TRUE),
    (25, 'FT00000014', 'Street Pizza',          20.00, 5, 7,TRUE),
    (26, 'PD00000011', 'Street Empanadas',      12.00, 5, 2,TRUE),
    (27, 'FT00000015', 'Street Gourmet',        22.00, 5, 3,TRUE),
    (28, 'FT00000016', 'Sabores Burger',        25.00, 6, 4,TRUE),
    (29, 'PD00000012', 'Sabores Tacos',         15.00, 6, 5,TRUE),
    (30, 'FT00000017', 'Sabores Pizza',         20.00, 6, 6,TRUE),
    (31, 'PD00000013', 'Sabores Empanadas',     12.00, 6, 7,TRUE),
    (32, 'FT00000018', 'Sabores Gourmet',       22.00, 6, 2,TRUE);

-- Subtipos de las nuevas unidades: Food Trucks
INSERT INTO `foodtruck` (`id`, `patente`, `requiere_electricidad`)
VALUES
    (1,'AB123ZE', 1),
    (3,  'AB123CD', 1),
    (5,  'AC123DE', 1),
    (8,  'AE123FG', 1),
    (10, 'AF123GH', 1),
    (12, 'AG123HJ', 0),
    (13, 'AH123JK', 1),
    (15, 'AJ123KL', 1),
    (17, 'AK123LM', 0),
    (18, 'AL123MN', 1),
    (20, 'AM123NP', 1),
    (22, 'AN123PQ', 0),
    (23, 'AP123QR', 1),
    (25, 'AQ123RS', 1),
    (27, 'AR123ST', 0),
    (28, 'AS123TU', 1),
    (30, 'AT123UV', 1),
    (32, 'AU123VW', 0);

-- Subtipos de las nuevas unidades: Puestos Desarmables
INSERT INTO `puesto_desarmable` (`id`, `cantidad_carpas`, `tiempo_montaje_minutos`)
VALUES
        (2,  1, 15),
    (4,  2, 45),
    (6,  3, 60),
    (9,  2, 40),
    (11, 3, 55),
    (14, 2, 45),
    (16, 3, 60),
    (19, 2, 40),
    (21, 3, 55),
    (24, 2, 45),
    (26, 3, 60),
    (29, 2, 40),
    (31, 3, 55);
-- =====================================================
-- 6. CARGA DE PLATOS DEL MENÚ
-- =====================================================
INSERT INTO `plato` (`id`, `nombre`, `precio`, `costo`, `activo`, `unidad_venta_id`)
VALUES 
        -- Unidad 1:
        (1, 'Hamburguesa Doble Queso', 8500.00, 3200.00, 1, 1),
       (2, 'Papas Rústicas', 4000.00, 1200.00, 1, 1),
       (3, 'Taco de Carne x3', 7500.00, 2800.00, 1, 1),
                
        -- Unidad 2: tacos
        (4,'Quesadillas de Pollo', 6800.00, 2600.00, TRUE, 2),
        (5,'Nachos con Cheddar', 5200.00, 1900.00, TRUE, 2),
        (6,'Burrito de Carne', 7900.00, 3100.00, TRUE, 2),

        -- Unidad 3: pizzas y empanadas
        (7,'Pizza Muzarella', 9000.00, 3800.00, TRUE, 3),
        (8,'Pizza Especial', 11500.00, 4900.00, TRUE, 3),
        (9,'Empanadas de Carne x3', 6000.00, 2400.00, TRUE, 3),

        -- Unidad 4: parrilla
        (10,'Choripan Completo', 6500.00, 2700.00, TRUE, 4),
        (11,'Sandwich de Bondiola', 8500.00, 3600.00, TRUE, 4),
        (12,'Provoleta', 5800.00, 2300.00, TRUE, 4),

        -- Unidad 5: opciones vegetarianas
        (13,'Hamburguesa Vegetariana', 7800.00, 3000.00, TRUE, 5),
        (14,'Wrap de Vegetales', 6200.00, 2200.00, TRUE, 5),
        (15,'Ensalada Gourmet', 5900.00, 2100.00, TRUE, 5),

        -- Unidad 6: postres
        (16,'Brownie con Helado', 4800.00, 1700.00, TRUE, 6),
        (17,'Cheesecake', 4200.00, 1500.00, TRUE, 6),
        (18,'Café con Medialunas', 3500.00, 1200.00, TRUE, 6),

-- completamos
    (22, 'Hamburguesa BBQ', 9200.00, 3500.00, TRUE, 1),
    (23, 'Papas con Cheddar', 4800.00, 1600.00, TRUE, 1),

    -- Unidad 2: completar 5 platos
    (24, 'Tacos de Pollo x3', 7200.00, 2700.00, TRUE, 2),
    (25, 'Guacamole con Nachos', 5500.00, 2000.00, TRUE, 2),

    -- Unidad 3: completar 5 platos
    (26, 'Pizza Napolitana', 9800.00, 4100.00, TRUE, 3),
    (27, 'Empanadas de Jamón y Queso x3', 5800.00, 2200.00, TRUE, 3),

    -- Unidad 4: completar 5 platos
    (28, 'Vacío al Pan', 9500.00, 4000.00, TRUE, 4),
    (29, 'Papas Fritas', 4200.00, 1400.00, TRUE, 4),

    -- Unidad 5: completar 5 platos
    (30, 'Tarta de Verduras', 5500.00, 1900.00, TRUE, 5),
    (31, 'Bastones de Mozzarella', 5700.00, 2100.00, TRUE, 5),

    -- Unidad 6: completar 5 platos
    (32, 'Churros con Dulce de Leche', 3900.00, 1300.00, TRUE, 6),
    (33, 'Helado Artesanal', 4500.00, 1600.00, TRUE, 6),

    -- Unidad 8
    (36, 'Hamburguesa Clásica', 8000.00, 3000.00, TRUE, 8),
    (37, 'Papas Fritas', 4000.00, 1200.00, TRUE, 8),
    (38, 'Hamburguesa Doble', 9500.00, 3700.00, TRUE, 8),
    (39, 'Nuggets de Pollo', 5200.00, 1900.00, TRUE, 8),
    (40, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 8),

    -- Unidad 9
    (41, 'Tacos de Carne x3', 7500.00, 2800.00, TRUE, 9),
    (42, 'Quesadillas de Queso', 6200.00, 2300.00, TRUE, 9),
    (43, 'Burrito de Pollo', 7800.00, 3000.00, TRUE, 9),
    (44, 'Nachos con Guacamole', 5600.00, 2000.00, TRUE, 9),
    (45, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 9),

    -- Unidad 10
    (46, 'Pizza Muzarella', 9000.00, 3800.00, TRUE, 10),
    (47, 'Pizza Napolitana', 9800.00, 4100.00, TRUE, 10),
    (48, 'Empanadas de Carne x3', 6000.00, 2400.00, TRUE, 10),
    (49, 'Fugazzeta', 10500.00, 4500.00, TRUE, 10),
    (50, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 10),

    -- Unidad 11
    (51, 'Choripan Completo', 6500.00, 2700.00, TRUE, 11),
    (52, 'Sandwich de Bondiola', 8500.00, 3600.00, TRUE, 11),
    (53, 'Vacío al Pan', 9500.00, 4000.00, TRUE, 11),
    (54, 'Provoleta', 5800.00, 2300.00, TRUE, 11),
    (55, 'Papas Fritas', 4200.00, 1400.00, TRUE, 11),

    -- Unidad 12
    (56, 'Hamburguesa Vegetariana', 7800.00, 3000.00, TRUE, 12),
    (57, 'Wrap de Vegetales', 6200.00, 2200.00, TRUE, 12),
    (58, 'Ensalada Gourmet', 5900.00, 2100.00, TRUE, 12),
    (59, 'Tarta de Verduras', 5500.00, 1900.00, TRUE, 12),
    (60, 'Limonada Casera', 2800.00, 700.00, TRUE, 12),

    -- Unidad 13
    (61, 'Brownie con Helado', 4800.00, 1700.00, TRUE, 13),
    (62, 'Cheesecake', 4200.00, 1500.00, TRUE, 13),
    (63, 'Churros con Dulce de Leche', 3900.00, 1300.00, TRUE, 13),
    (64, 'Café con Medialunas', 3500.00, 1200.00, TRUE, 13),
    (65, 'Helado Artesanal', 4500.00, 1600.00, TRUE, 13),

    -- Unidad 14
    (66, 'Limonada Casera', 2800.00, 700.00, TRUE, 14),
    (67, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 14),
    (68, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 14),
    (69, 'Limonada con Menta', 3200.00, 900.00, TRUE, 14),
    (70, 'Combo Hamburguesa y Bebida', 10500.00, 4200.00, TRUE, 14),

    -- Unidad 15
    (71, 'Hamburguesa BBQ', 9200.00, 3500.00, TRUE, 15),
    (72, 'Papas con Cheddar', 4800.00, 1600.00, TRUE, 15),
    (73, 'Nuggets de Pollo', 5200.00, 1900.00, TRUE, 15),
    (74, 'Hamburguesa Doble', 9500.00, 3700.00, TRUE, 15),
    (75, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 15),

    -- Unidad 16
    (76, 'Tacos de Pollo x3', 7200.00, 2700.00, TRUE, 16),
    (77, 'Quesadillas de Pollo', 6800.00, 2600.00, TRUE, 16),
    (78, 'Burrito de Carne', 7900.00, 3100.00, TRUE, 16),
    (79, 'Nachos con Cheddar', 5200.00, 1900.00, TRUE, 16),
    (80, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 16),

    -- Unidad 17
    (81, 'Pizza Especial', 11500.00, 4900.00, TRUE, 17),
    (82, 'Pizza Muzarella', 9000.00, 3800.00, TRUE, 17),
    (83, 'Empanadas de Jamón y Queso x3', 5800.00, 2200.00, TRUE, 17),
    (84, 'Pizza Napolitana', 9800.00, 4100.00, TRUE, 17),
    (85, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 17),

    -- Unidad 18
    (86, 'Choripan Completo', 6500.00, 2700.00, TRUE, 18),
    (87, 'Sandwich de Bondiola', 8500.00, 3600.00, TRUE, 18),
    (88, 'Vacío al Pan', 9500.00, 4000.00, TRUE, 18),
    (89, 'Provoleta', 5800.00, 2300.00, TRUE, 18),
    (90, 'Papas Fritas', 4200.00, 1400.00, TRUE, 18),

    -- Unidad 19
    (91, 'Hamburguesa Vegetariana', 7800.00, 3000.00, TRUE, 19),
    (92, 'Wrap de Vegetales', 6200.00, 2200.00, TRUE, 19),
    (93, 'Ensalada Gourmet', 5900.00, 2100.00, TRUE, 19),
    (94, 'Tarta de Verduras', 5500.00, 1900.00, TRUE, 19),
    (95, 'Limonada Casera', 2800.00, 700.00, TRUE, 19),

    -- Unidad 20
    (96, 'Brownie con Helado', 4800.00, 1700.00, TRUE, 20),
    (97, 'Cheesecake', 4200.00, 1500.00, TRUE, 20),
    (98, 'Churros con Dulce de Leche', 3900.00, 1300.00, TRUE, 20),
    (99, 'Café con Medialunas', 3500.00, 1200.00, TRUE, 20),
    (100, 'Helado Artesanal', 4500.00, 1600.00, TRUE, 20),

    -- Unidad 21
    (101, 'Limonada Casera', 2800.00, 700.00, TRUE, 21),
    (102, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 21),
    (103, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 21),
    (104, 'Limonada con Menta', 3200.00, 900.00, TRUE, 21),
    (105, 'Combo Hamburguesa y Bebida', 10500.00, 4200.00, TRUE, 21),

    -- Unidad 22
    (106, 'Hamburguesa BBQ', 9200.00, 3500.00, TRUE, 22),
    (107, 'Papas con Cheddar', 4800.00, 1600.00, TRUE, 22),
    (108, 'Nuggets de Pollo', 5200.00, 1900.00, TRUE, 22),
    (109, 'Hamburguesa Doble', 9500.00, 3700.00, TRUE, 22),
    (110, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 22),

    -- Unidad 23
    (111, 'Tacos de Carne x3', 7500.00, 2800.00, TRUE, 23),
    (112, 'Quesadillas de Queso', 6200.00, 2300.00, TRUE, 23),
    (113, 'Burrito de Pollo', 7800.00, 3000.00, TRUE, 23),
    (114, 'Nachos con Guacamole', 5600.00, 2000.00, TRUE, 23),
    (115, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 23),

    -- Unidad 24
    (116, 'Pizza Muzarella', 9000.00, 3800.00, TRUE, 24),
    (117, 'Pizza Napolitana', 9800.00, 4100.00, TRUE, 24),
    (118, 'Empanadas de Carne x3', 6000.00, 2400.00, TRUE, 24),
    (119, 'Fugazzeta', 10500.00, 4500.00, TRUE, 24),
    (120, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 24),

    -- Unidad 25
    (121, 'Choripan Completo', 6500.00, 2700.00, TRUE, 25),
    (122, 'Sandwich de Bondiola', 8500.00, 3600.00, TRUE, 25),
    (123, 'Vacío al Pan', 9500.00, 4000.00, TRUE, 25),
    (124, 'Provoleta', 5800.00, 2300.00, TRUE, 25),
    (125, 'Papas Fritas', 4200.00, 1400.00, TRUE, 25),

    -- Unidad 26
    (126, 'Hamburguesa Vegetariana', 7800.00, 3000.00, TRUE, 26),
    (127, 'Wrap de Vegetales', 6200.00, 2200.00, TRUE, 26),
    (128, 'Ensalada Gourmet', 5900.00, 2100.00, TRUE, 26),
    (129, 'Tarta de Verduras', 5500.00, 1900.00, TRUE, 26),
    (130, 'Limonada Casera', 2800.00, 700.00, TRUE, 26),

    -- Unidad 27
    (131, 'Brownie con Helado', 4800.00, 1700.00, TRUE, 27),
    (132, 'Cheesecake', 4200.00, 1500.00, TRUE, 27),
    (133, 'Churros con Dulce de Leche', 3900.00, 1300.00, TRUE, 27),
    (134, 'Café con Medialunas', 3500.00, 1200.00, TRUE, 27),
    (135, 'Helado Artesanal', 4500.00, 1600.00, TRUE, 27),

    -- Unidad 28
    (136, 'Limonada Casera', 2800.00, 700.00, TRUE, 28),
    (137, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 28),
    (138, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 28),
    (139, 'Limonada con Menta', 3200.00, 900.00, TRUE, 28),
    (140, 'Combo Hamburguesa y Bebida', 10500.00, 4200.00, TRUE, 28),

    -- Unidad 29
    (141, 'Hamburguesa BBQ', 9200.00, 3500.00, TRUE, 29),
    (142, 'Papas con Cheddar', 4800.00, 1600.00, TRUE, 29),
    (143, 'Nuggets de Pollo', 5200.00, 1900.00, TRUE, 29),
    (144, 'Hamburguesa Doble', 9500.00, 3700.00, TRUE, 29),
    (145, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 29),

    -- Unidad 30
    (146, 'Tacos de Pollo x3', 7200.00, 2700.00, TRUE, 30),
    (147, 'Quesadillas de Pollo', 6800.00, 2600.00, TRUE, 30),
    (148, 'Burrito de Carne', 7900.00, 3100.00, TRUE, 30),
    (149, 'Nachos con Cheddar', 5200.00, 1900.00, TRUE, 30),
    (150, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 30),

    -- Unidad 31
    (151, 'Pizza Especial', 11500.00, 4900.00, TRUE, 31),
    (152, 'Pizza Muzarella', 9000.00, 3800.00, TRUE, 31),
    (153, 'Empanadas de Jamón y Queso x3', 5800.00, 2200.00, TRUE, 31),
    (154, 'Pizza Napolitana', 9800.00, 4100.00, TRUE, 31),
    (155, 'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 31),

    -- Unidad 32
    (156, 'Choripan Completo', 6500.00, 2700.00, TRUE, 32),
    (157, 'Sandwich de Bondiola', 8500.00, 3600.00, TRUE, 32),
    (158, 'Vacío al Pan', 9500.00, 4000.00, TRUE, 32),
    (159, 'Provoleta', 5800.00, 2300.00, TRUE, 32),
    (160, 'Papas Fritas', 4200.00, 1400.00, TRUE, 32);
-- =====================================================
-- 7. CARGA DE PEDIDOS Y SUS DETALLES (VENTAS)
-- =====================================================
INSERT INTO `pedido` (`id`, `fecha_hora`, `unidad_venta_id`)
VALUES (1,  '2026-10-05 13:30:00', 1),
(2,  '2026-10-05 14:15:00', 1),

(3,  '2026-10-05 20:00:00', 2),
(4,  '2026-10-05 20:30:00', 2),

(5,  '2026-10-05 13:45:00', 3),
(6,  '2026-10-05 14:30:00', 3),

(7,  '2026-10-05 15:00:00', 4),
(8,  '2026-10-05 20:15:00', 4),

(9,  '2026-10-05 16:00:00', 5),
(10, '2026-10-05 19:00:00', 5),

(11, '2026-10-05 17:30:00', 6),
(12, '2026-10-05 20:00:00', 6);

INSERT INTO `detalle_pedido` (`id`, `pedido_id`, `plato_id`, `cantidad`, `precio_unitario`, `subtotal`)
VALUES 
-- Unidad 1: Hamburguesas y papas
(1,  1, 1, 2, 8500.00, 17000.00),
(2,  1, 2, 1, 4000.00,  4000.00),
(3,  2, 1, 1, 8500.00,  8500.00),

-- Unidad 2: Comida mexicana
(4,  3, 4, 3, 6800.00, 20400.00),
(5,  4, 4, 2, 6800.00, 13600.00),
(6,  4, 5, 1, 5200.00,  5200.00),

-- Unidad 3: Pizzería
(7,  5, 7, 2, 9000.00, 18000.00),
(8,  5, 9, 3, 6000.00, 18000.00),
(9,  6, 8, 1, 11500.00, 11500.00),

-- Unidad 4: Parrilla
(10, 7, 10, 2, 6500.00, 13000.00),
(11, 7, 12, 1, 5800.00,  5800.00),
(12, 8, 11, 2, 8500.00, 17000.00),

-- Unidad 5: Comida saludable
(13, 9, 13, 2, 7800.00, 15600.00),
(14, 9, 15, 1, 5900.00,  5900.00),
(15, 10, 14, 3, 6200.00, 18600.00),

-- Unidad 6: Cafetería y postres
(16, 11, 16, 2, 4800.00,  9600.00),
(17, 11, 18, 2, 3500.00,  7000.00),
(18, 12, 17, 3, 4200.00, 12600.00);

-- =====================================================
-- 8. CIERRES DE CAJA Y LIQUIDACIÓN DE HABERES (PRUEBAS DE REPORTES)
-- =====================================================
INSERT INTO `cierre_de_caja`
    (`id`, `cajero_id`, `festival_id`, `unidad_venta_id`,`fecha_hora_apertura`,
     `fecha_hora_cierre`, `total_sistema`, `total_declarado`, `diferencia`)
VALUES
    (1,  8, 1, 1, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL),
    (2,  9, 1, 2, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL),
    (3, 10, 1, 3, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL),
    (4, 11, 1, 4, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL),
    (5, 12, 1, 5, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL),
    (6, 13, 1, 6, '2026-10-05 08:30:00', NULL, NULL, NULL, NULL);

INSERT INTO `liquidacion_de_haberes`
    (`id`, `empleado_id`, `festival_id`, `fecha`,`dias_festival`, `sueldo`, `adicional_aplicado`,
     `factor_aplicado`, `total`)
VALUES
    -- Unidad 1
    (1,  8, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (2, 15, 1, '2026-09-10', 41, 100000.00, 150000.00, 1.00, 250000.00),

    -- Unidad 2
    (3,  9, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (4, 16, 1, '2026-09-10', 41, 100000.00, 150000.00, 1.10, 275000.00),

    -- Unidad 3
    (5, 10, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (6, 17, 1, '2026-09-10', 18, 100000.00, 150000.00, 1.10, 275000.00),

    -- Unidad 4
    (7, 11, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (8, 18, 1, '2026-09-10', 41, 100000.00, 150000.00, 1.10, 275000.00),

    -- Unidad 5
    (9, 12, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (10,19, 1, '2026-09-10', 41, 100000.00, 150000.00, 1.10, 275000.00),

    -- Unidad 6
    (11,13, 1, '2026-09-10', 41, 100000.00,      0, 1.00, 100000.00),
    (12,20, 1, '2026-09-10', 41, 100000.00, 150000.00, 1.10, 275000.00),

    -- Ayudantes
    (13, 21, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),
    (14, 22, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),
    (15, 23, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),
    (16, 24, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),
    (17, 25, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),
    (18, 26, 1, '2026-09-10', 41, 100000.00, 100000.00, 1.00, 200000.00),

    -- Lavaplatos
    (19, 27, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00),
    (20, 28, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00),
    (21, 29, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00),
    (22, 30, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00),
    (23, 31, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00),
    (24, 32, 1, '2026-09-10', 41, 100000.00, 50000.00, 1.00, 150000.00);
-- =====================================================
-- Asignamos encargados a las unidades del Festival 1
-- =====================================================

-- asignando a festival pasado
UPDATE staff SET unidad_venta_id = 1 WHERE id IN (8,15,21,27);
UPDATE staff SET unidad_venta_id = 2 WHERE id IN (9,16,22,28);
UPDATE staff SET unidad_venta_id = 3 WHERE id IN (10,17,23,29);
UPDATE staff SET unidad_venta_id = 4 WHERE id IN (11,18,24,30);
UPDATE staff SET unidad_venta_id = 5 WHERE id IN (12,19,25,31);
UPDATE staff SET unidad_venta_id = 6 WHERE id IN (13,20,26,32);

--asignando a festival activo

UPDATE staff SET unidad_venta_id = 8 WHERE id IN (8, 15, 21, 27);
UPDATE staff SET unidad_venta_id = 9 WHERE id IN (9, 16, 22, 28);
UPDATE staff SET unidad_venta_id = 10 WHERE id IN (10, 17, 23, 29);
UPDATE staff SET unidad_venta_id = 11 WHERE id IN (11, 18, 24, 30);
UPDATE staff SET unidad_venta_id = 12 WHERE id IN (12, 19, 25, 31);

INSERT INTO historial_unidad (staff_id, unidad_venta_id)
VALUES
-- Festival 1: unidades 1 a 6
(8, 1), (15, 1), (21, 1), (27, 1),
(9, 2), (16, 2), (22, 2), (28, 2),
(10, 3), (17, 3), (23, 3), (29, 3),
(11, 4), (18, 4), (24, 4), (30, 4),
(12, 5), (19, 5), (25, 5), (31, 5),
(13, 6), (20, 6), (26, 6), (32, 6),

-- Festival 2: unidades 8 a 12


-- Festival 3: unidades 13 a 17
(8, 13), (15, 13), (21, 13), (27, 13),
(9, 14), (16, 14), (22, 14), (28, 14),
(10, 15), (17, 15), (23, 15), (29, 15),
(11, 16), (18, 16), (24, 16), (30, 16),
(12, 17), (19, 17), (25, 17), (31, 17);

-- Festival 4: unidades 18 a 22
--no ocurrio
-- Festival 5: unidades 23 a 27
--no ocurrio

-- Festival 6: unidades 28 a 32
--no ocurrio

