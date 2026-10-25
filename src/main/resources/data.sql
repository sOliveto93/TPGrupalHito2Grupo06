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
VALUES  (1, 'Festival Gourmet Primavera', 'PRIMAVERA', '2026-10-01', '2026-11-30', 1),
    (2, 'Beer & Food Fest Verano', 'PRIMAVERA', '2026-10-01', '2026-10-15', 2),
    (3, 'Sabores de Otoño', 'OTONIO', '2026-03-01', '2026-03-28', 3),
    (4, 'Festival del Invierno', 'INVIERNO', '2027-05-10', '2027-06-30', 4),
    (5, 'Buenos Aires Street Food', 'PRIMAVERA', '2026-10-15', '2026-11-15', 5),
    (6, 'Sabores Fest', 'PRIMAVERA', '2026-10-05', '2026-11-15', 6);
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
(8,'valentinagomez','valentinagomez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(9,'sofiaMartinez','sofiamartinez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(10,'facundolopez','facundolopez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(11,'camilaromero','camilaromero@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(12,'tomasdiaz','tomasdiaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(13,'florenciatorres','florenciatorres@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(14,'nicolasacosta','nicolasacosta@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(15,'julietasuarez','julietasuarez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(16,'mateosilva','mateosilva@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(17,'agustinromero','agustinromero@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(18,'martinaflores','martinaflores@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(19,'santiagomendez','santiagomendez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(20,'milagroscastro','milagroscastro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(21,'benjaminortiz','benjaminortiz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(22,'abrilnavarro','abrilnavarro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(23,'joaquinpereyra','joaquinpereyra@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(24,'morenabenitez','morenabenitez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(25,'franciscovargas','franciscovargas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(26,'emiliapaz','emiliapaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(27,'leonardorojas','leonardorojas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(28,'renatamolina','renatamolina@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(29,'brunocabrera','brunocabrera@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(30,'paulacordoba','paulacordoba@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(31,'diegorivera','diegorivera@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(32,'catalinagil','catalinagil@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(33,'ramiroarias','ramiroarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(34,'zoeaguirre','zoeaguirre@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(35,'gabrielmedina','gabrielmedina@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(36,'lucianavega','lucianavega@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(37,'ezequieldominguez','ezequieldominguez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(38,'jazminherrera','jazminherrera@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(39,'maximilianofarias','maximilianofarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(40,'antonellacosta','antonellacosta@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(41,'thiagofranco','thiagofranco@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(42,'malenalozano','malenalozano@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(43,'ignaciobenitez','ignaciobenitez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(44,'candelaibanez','candelaibanez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(45,'alanmendez','alanmendez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(46,'biancasuarez','biancasuarez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(47,'simonarias','simonarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(48,'delfinapaz','delfinapaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(49,'franciscorios','franciscorios@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(50,'laraortiz','laraortiz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(51,'julianvera','julianvera@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(52,'mialuna','mialuna@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(53,'beniciogimenez','beniciogimenez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(54,'oliviapereira','oliviapereira@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(55,'valentinagil','valentinagil@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(56,'joelrojas','joelrojas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(57,'almaortega','almaortega@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(58,'matiascampos','matiascampos@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(59,'inesvillalba','inesvillalba@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(60,'ramonpereyra','ramonpereyra@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(61,'camilabenitez','camilabenitez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(62,'federicoalvarez','federicoalvarez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(63,'paulinaguerra','paulinaguerra@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(64,'agustinpaz','agustinpaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(65,'lorenavargas','lorenavargas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(66,'marcosarias','marcosarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(67,'sofiacastro','sofiacastro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(68,'lucianopaz','lucianopaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(69,'danaarias','danaarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(70,'lautaroacosta','lautaroacosta@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(71,'morenasosa','morenasosa@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(72,'brunomendez','brunomendez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(73,'malenaflores','malenaflores@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(74,'santiagocampos','santiagocampos@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(75,'abrilrios','abrilrios@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(76,'thiagorojas','thiagorojas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(77,'julietabenitez','julietabenitez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(78,'mateorios','mateorios@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(79,'antonellamendez','antonellamendez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(80,'joaquinvega','joaquinvega@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(81,'catalinacastro','catalinacastro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(82,'benjaminpaz','benjaminpaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(83,'zoemartinez','zoemartinez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(84,'ignaciorios','ignaciorios@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(85,'milagrosvega','milagrosvega@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(86,'franciscogil','franciscogil@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(87,'mialopez','mialopez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(88,'leonardodiaz','leonardodiaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(89,'larafernandez','larafernandez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(90,'ramirolopez','ramirolopez@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(91,'paulamedina','paulamedina@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(92,'maximilianopaz','maximilianopaz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(93,'emiliacastro','emiliacastro@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(94,'ezequielrojas','ezequielrojas@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(95,'valentinapereyra','valentinapereyra@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(96,'gabrielortiz','gabrielortiz@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(97,'jazminromero','jazminromero@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(98,'alanarias','alanarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW()),
(99, 'empleado99', 'empleado99@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(100, 'empleado100', 'empleado100@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(101, 'empleado101', 'empleado101@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(102, 'empleado102', 'empleado102@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(103, 'empleado103', 'empleado103@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(104, 'empleado104', 'empleado104@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(105, 'empleado105', 'empleado105@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(106, 'empleado106', 'empleado106@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(107, 'empleado107', 'empleado107@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(108, 'empleado108', 'empleado108@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(109, 'empleado109', 'empleado109@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(110, 'empleado110', 'empleado110@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(111, 'empleado111', 'empleado111@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(112, 'empleado112', 'empleado112@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(113, 'empleado113', 'empleado113@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(114, 'empleado114', 'empleado114@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(115, 'empleado115', 'empleado115@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(116, 'empleado116', 'empleado116@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(117, 'empleado117', 'empleado117@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(118, 'empleado118', 'empleado118@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(119, 'empleado119', 'empleado119@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(120, 'empleado120', 'empleado120@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(121, 'empleado121', 'empleado121@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(122, 'empleado122', 'empleado122@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(123, 'empleado123', 'empleado123@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(124, 'empleado124', 'empleado124@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(125, 'empleado125', 'empleado125@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(126, 'empleado126', 'empleado126@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(127, 'empleado127', 'empleado127@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(128, 'empleado128', 'empleado128@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(129, 'empleado129', 'empleado129@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(130, 'empleado130', 'empleado130@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(131, 'empleado131', 'empleado131@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(132, 'empleado132', 'empleado132@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(133, 'empleado133', 'empleado133@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(134, 'empleado134', 'empleado134@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(135, 'empleado135', 'empleado135@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(136, 'empleado136', 'empleado136@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(137, 'empleado137', 'empleado137@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(138, 'empleado138', 'empleado138@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(139, 'empleado139', 'empleado139@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(140, 'empleado140', 'empleado140@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(141, 'empleado141', 'empleado141@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(142, 'empleado142', 'empleado142@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(143, 'empleado143', 'empleado143@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(144, 'empleado144', 'empleado144@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(145, 'empleado145', 'empleado145@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(146, 'empleado146', 'empleado146@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(147, 'empleado147', 'empleado147@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(148, 'empleado148', 'empleado148@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(149, 'empleado149', 'empleado149@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(150, 'empleado150', 'empleado150@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(151, 'empleado151', 'empleado151@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(152, 'empleado152', 'empleado152@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(153, 'empleado153', 'empleado153@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(154, 'empleado154', 'empleado154@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(155, 'empleado155', 'empleado155@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(156, 'empleado156', 'empleado156@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(157, 'empleado157', 'empleado157@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(158, 'empleado158', 'empleado158@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(159, 'empleado159', 'empleado159@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(160, 'empleado160', 'empleado160@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(161, 'empleado161', 'empleado161@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW()),
(162, 'empleado162', 'empleado162@gmail.com', '$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u', 1, NOW(), NOW());

-- Rol del Administrador del sistema
INSERT INTO `usuario_rol` (`id`, `usuario_id`, `rol`, `created_at`, `updated_at`)
VALUES (1, 1, 'ROLE_ADMINISTRADOR', NOW(), NOW()),
       (2, 2, 'ROLE_RESPONSABLE', NOW(), NOW()),
       (3, 3, 'ROLE_EMPLEADO', NOW(), NOW()),
       (4, 4, 'ROLE_EMPLEADO', NOW(), NOW()),
       (5, 5, 'ROLE_EMPLEADO', NOW(), NOW()),
       (6,6,'ROLE_RESPONSABLE',NOW(),NOW()),(7,7,'ROLE_EMPLEADO',NOW(),NOW()),(8,8,'ROLE_EMPLEADO',NOW(),NOW()),
(9,9,'ROLE_RESPONSABLE',NOW(),NOW()),(10,10,'ROLE_EMPLEADO',NOW(),NOW()),(11,11,'ROLE_EMPLEADO',NOW(),NOW()),
(12,12,'ROLE_RESPONSABLE',NOW(),NOW()),(13,13,'ROLE_EMPLEADO',NOW(),NOW()),(14,14,'ROLE_EMPLEADO',NOW(),NOW()),
(15,15,'ROLE_RESPONSABLE',NOW(),NOW()),(16,16,'ROLE_EMPLEADO',NOW(),NOW()),(17,17,'ROLE_EMPLEADO',NOW(),NOW()),
(18,18,'ROLE_RESPONSABLE',NOW(),NOW()),(19,19,'ROLE_EMPLEADO',NOW(),NOW()),(20,20,'ROLE_EMPLEADO',NOW(),NOW()),
(21,21,'ROLE_RESPONSABLE',NOW(),NOW()),(22,22,'ROLE_EMPLEADO',NOW(),NOW()),(23,23,'ROLE_EMPLEADO',NOW(),NOW()),
(24,24,'ROLE_RESPONSABLE',NOW(),NOW()),(25,25,'ROLE_EMPLEADO',NOW(),NOW()),(26,26,'ROLE_EMPLEADO',NOW(),NOW()),
(27,27,'ROLE_RESPONSABLE',NOW(),NOW()),(28,28,'ROLE_EMPLEADO',NOW(),NOW()),(29,29,'ROLE_EMPLEADO',NOW(),NOW()),
(30,30,'ROLE_RESPONSABLE',NOW(),NOW()),(31,31,'ROLE_EMPLEADO',NOW(),NOW()),(32,32,'ROLE_EMPLEADO',NOW(),NOW()),
(33,33,'ROLE_RESPONSABLE',NOW(),NOW()),(34,34,'ROLE_EMPLEADO',NOW(),NOW()),(35,35,'ROLE_EMPLEADO',NOW(),NOW()),
(36,36,'ROLE_RESPONSABLE',NOW(),NOW()),(37,37,'ROLE_EMPLEADO',NOW(),NOW()),(38,38,'ROLE_EMPLEADO',NOW(),NOW()),
(39,39,'ROLE_RESPONSABLE',NOW(),NOW()),(40,40,'ROLE_EMPLEADO',NOW(),NOW()),(41,41,'ROLE_EMPLEADO',NOW(),NOW()),
(42,42,'ROLE_RESPONSABLE',NOW(),NOW()),(43,43,'ROLE_EMPLEADO',NOW(),NOW()),(44,44,'ROLE_EMPLEADO',NOW(),NOW()),
(45,45,'ROLE_RESPONSABLE',NOW(),NOW()),(46,46,'ROLE_EMPLEADO',NOW(),NOW()),(47,47,'ROLE_EMPLEADO',NOW(),NOW()),
(48,48,'ROLE_RESPONSABLE',NOW(),NOW()),(49,49,'ROLE_EMPLEADO',NOW(),NOW()),(50,50,'ROLE_EMPLEADO',NOW(),NOW()),
(51,51,'ROLE_RESPONSABLE',NOW(),NOW()),(52,52,'ROLE_EMPLEADO',NOW(),NOW()),(53,53,'ROLE_EMPLEADO',NOW(),NOW()),
(54,54,'ROLE_RESPONSABLE',NOW(),NOW()),(55,55,'ROLE_EMPLEADO',NOW(),NOW()),(56,56,'ROLE_EMPLEADO',NOW(),NOW()),
(57,57,'ROLE_RESPONSABLE',NOW(),NOW()),(58,58,'ROLE_EMPLEADO',NOW(),NOW()),(59,59,'ROLE_EMPLEADO',NOW(),NOW()),
(60,60,'ROLE_RESPONSABLE',NOW(),NOW()),(61,61,'ROLE_EMPLEADO',NOW(),NOW()),(62,62,'ROLE_EMPLEADO',NOW(),NOW()),
(63,63,'ROLE_RESPONSABLE',NOW(),NOW()),(64,64,'ROLE_EMPLEADO',NOW(),NOW()),(65,65,'ROLE_EMPLEADO',NOW(),NOW()),
(66,66,'ROLE_RESPONSABLE',NOW(),NOW()),(67,67,'ROLE_EMPLEADO',NOW(),NOW()),(68,68,'ROLE_EMPLEADO',NOW(),NOW()),
(69,69,'ROLE_RESPONSABLE',NOW(),NOW()),(70,70,'ROLE_EMPLEADO',NOW(),NOW()),(71,71,'ROLE_EMPLEADO',NOW(),NOW()),
(72,72,'ROLE_RESPONSABLE',NOW(),NOW()),(73,73,'ROLE_EMPLEADO',NOW(),NOW()),(74,74,'ROLE_EMPLEADO',NOW(),NOW()),
(75,75,'ROLE_RESPONSABLE',NOW(),NOW()),(76,76,'ROLE_EMPLEADO',NOW(),NOW()),(77,77,'ROLE_EMPLEADO',NOW(),NOW()),
(78,78,'ROLE_RESPONSABLE',NOW(),NOW()),(79,79,'ROLE_EMPLEADO',NOW(),NOW()),(80,80,'ROLE_EMPLEADO',NOW(),NOW()),
(81,81,'ROLE_RESPONSABLE',NOW(),NOW()),(82,82,'ROLE_EMPLEADO',NOW(),NOW()),(83,83,'ROLE_EMPLEADO',NOW(),NOW()),
(84,84,'ROLE_RESPONSABLE',NOW(),NOW()),(85,85,'ROLE_EMPLEADO',NOW(),NOW()),(86,86,'ROLE_EMPLEADO',NOW(),NOW()),
(87,87,'ROLE_RESPONSABLE',NOW(),NOW()),(88,88,'ROLE_EMPLEADO',NOW(),NOW()),(89,89,'ROLE_EMPLEADO',NOW(),NOW()),
(90,90,'ROLE_RESPONSABLE',NOW(),NOW()),(91,91,'ROLE_EMPLEADO',NOW(),NOW()),(92,92,'ROLE_EMPLEADO',NOW(),NOW()),
(93,93,'ROLE_RESPONSABLE',NOW(),NOW()),(94,94,'ROLE_EMPLEADO',NOW(),NOW()),(95,95,'ROLE_EMPLEADO',NOW(),NOW()),
(96,96,'ROLE_RESPONSABLE',NOW(),NOW()),(97,97,'ROLE_EMPLEADO',NOW(),NOW()),(98,98,'ROLE_EMPLEADO',NOW(),NOW()),
(99,99,'ROLE_EMPLEADO',NOW(),NOW()),
(100,100,'ROLE_EMPLEADO',NOW(),NOW()),
(101,101,'ROLE_EMPLEADO',NOW(),NOW()),
(102,102,'ROLE_EMPLEADO',NOW(),NOW()),
(103,103,'ROLE_EMPLEADO',NOW(),NOW()),
(104,104,'ROLE_EMPLEADO',NOW(),NOW()),
(105,105,'ROLE_EMPLEADO',NOW(),NOW()),
(106,106,'ROLE_EMPLEADO',NOW(),NOW()),
(107,107,'ROLE_EMPLEADO',NOW(),NOW()),
(108,108,'ROLE_EMPLEADO',NOW(),NOW()),
(109,109,'ROLE_EMPLEADO',NOW(),NOW()),
(110,110,'ROLE_EMPLEADO',NOW(),NOW()),
(111,111,'ROLE_EMPLEADO',NOW(),NOW()),
(112,112,'ROLE_EMPLEADO',NOW(),NOW()),
(113,113,'ROLE_EMPLEADO',NOW(),NOW()),
(114,114,'ROLE_EMPLEADO',NOW(),NOW()),
(115,115,'ROLE_EMPLEADO',NOW(),NOW()),
(116,116,'ROLE_EMPLEADO',NOW(),NOW()),
(117,117,'ROLE_EMPLEADO',NOW(),NOW()),
(118,118,'ROLE_EMPLEADO',NOW(),NOW()),
(119,119,'ROLE_EMPLEADO',NOW(),NOW()),
(120,120,'ROLE_EMPLEADO',NOW(),NOW()),
(121,121,'ROLE_EMPLEADO',NOW(),NOW()),
(122,122,'ROLE_EMPLEADO',NOW(),NOW()),
(123,123,'ROLE_EMPLEADO',NOW(),NOW()),
(124,124,'ROLE_EMPLEADO',NOW(),NOW()),
(125,125,'ROLE_EMPLEADO',NOW(),NOW()),
(126,126,'ROLE_EMPLEADO',NOW(),NOW()),
(127,127,'ROLE_EMPLEADO',NOW(),NOW()),
(128,128,'ROLE_EMPLEADO',NOW(),NOW()),
(129,129,'ROLE_EMPLEADO',NOW(),NOW()),
(130,130,'ROLE_EMPLEADO',NOW(),NOW()),
(131,131,'ROLE_EMPLEADO',NOW(),NOW()),
(132,132,'ROLE_EMPLEADO',NOW(),NOW()),
(133,133,'ROLE_EMPLEADO',NOW(),NOW()),
(134,134,'ROLE_EMPLEADO',NOW(),NOW()),
(135,135,'ROLE_EMPLEADO',NOW(),NOW()),
(136,136,'ROLE_EMPLEADO',NOW(),NOW()),
(137,137,'ROLE_EMPLEADO',NOW(),NOW()),
(138,138,'ROLE_EMPLEADO',NOW(),NOW()),
(139,139,'ROLE_EMPLEADO',NOW(),NOW()),
(140,140,'ROLE_EMPLEADO',NOW(),NOW()),
(141,141,'ROLE_EMPLEADO',NOW(),NOW()),
(142,142,'ROLE_EMPLEADO',NOW(),NOW()),
(143,143,'ROLE_EMPLEADO',NOW(),NOW()),
(144,144,'ROLE_EMPLEADO',NOW(),NOW()),
(145,145,'ROLE_EMPLEADO',NOW(),NOW()),
(146,146,'ROLE_EMPLEADO',NOW(),NOW()),
(147,147,'ROLE_EMPLEADO',NOW(),NOW()),
(148,148,'ROLE_EMPLEADO',NOW(),NOW()),
(149,149,'ROLE_EMPLEADO',NOW(),NOW()),
(150,150,'ROLE_EMPLEADO',NOW(),NOW()),
(151,151,'ROLE_EMPLEADO',NOW(),NOW()),
(152,152,'ROLE_EMPLEADO',NOW(),NOW()),
(153,153,'ROLE_EMPLEADO',NOW(),NOW()),
(154,154,'ROLE_EMPLEADO',NOW(),NOW()),
(155,155,'ROLE_EMPLEADO',NOW(),NOW()),
(156,156,'ROLE_EMPLEADO',NOW(),NOW()),
(157,157,'ROLE_EMPLEADO',NOW(),NOW()),
(158,158,'ROLE_EMPLEADO',NOW(),NOW()),
(159,159,'ROLE_EMPLEADO',NOW(),NOW()),
(160,160,'ROLE_EMPLEADO',NOW(),NOW()),
(161,161,'ROLE_EMPLEADO',NOW(),NOW()),
(162,162,'ROLE_EMPLEADO',NOW(),NOW());

-- =====================================================
-- 4. CARGA DE STAFF / PERSONAL
-- =====================================================
INSERT INTO `staff` (`id`, `usuario_id`, `name`, `apellido`, `dni`, `fecha_nac`, `fecha_ingreso`, `activo`, `fecha_baja`, `unidad_venta_id`)
VALUES
(2, 2, 'Carlos', 'Ríos', '30111222', '1985-05-12', '2020-03-01', 1, NULL, NULL),
(3, 3, 'Ana', 'Martínez', '32333444', '1988-08-20', '2021-06-15', 1, NULL, NULL),
(4, 4, 'Juan', 'Pérez', '38555666', '1995-02-10', '2022-01-10', 1, NULL, NULL),
(5, 5, 'María', 'Gómez', '36777888', '1992-11-05', '2021-02-01', 1, NULL, NULL),
(6, 6, 'Lucas', 'Fernández', '80000001', '1990-01-01', CURDATE(), 1, NULL, NULL),
(7, 7, 'Martín', 'Rodríguez', '81000001', '1995-01-01', CURDATE(), 1, NULL, NULL),
(8, 8, 'Valentina', 'Gómez', '82000001', '1992-01-01', CURDATE(), 1, NULL, NULL),
(9, 9, 'Sofía', 'Martínez', '80000002', '1990-01-01', CURDATE(), 1, NULL, NULL),
(10, 10, 'Facundo', 'López', '81000002', '1995-01-01', CURDATE(), 1, NULL, NULL),
(11, 11, 'Camila', 'Romero', '82000002', '1992-01-01', CURDATE(), 1, NULL, NULL),
(12, 12, 'Tomás', 'Díaz', '80000003', '1990-01-01', CURDATE(), 1, NULL, NULL),
(13, 13, 'Florencia', 'Torres', '81000003', '1995-01-01', CURDATE(), 1, NULL, NULL),
(14, 14, 'Nicolás', 'Acosta', '82000003', '1992-01-01', CURDATE(), 1, NULL, NULL),
(15, 15, 'Julieta', 'Suárez', '80000004', '1990-01-01', CURDATE(), 1, NULL, NULL),
(16, 16, 'Mateo', 'Silva', '81000004', '1995-01-01', CURDATE(), 1, NULL, NULL),
(17, 17, 'Agustín', 'Romero', '82000004', '1992-01-01', CURDATE(), 1, NULL, NULL),
(18, 18, 'Martina', 'Flores', '80000005', '1990-01-01', CURDATE(), 1, NULL, NULL),
(19, 19, 'Santiago', 'Méndez', '81000005', '1995-01-01', CURDATE(), 1, NULL, NULL),
(20, 20, 'Milagros', 'Castro', '82000005', '1992-01-01', CURDATE(), 1, NULL, NULL),
(21, 21, 'Benjamín', 'Ortiz', '80000006', '1990-01-01', CURDATE(), 1, NULL, NULL),
(22, 22, 'Abril', 'Navarro', '81000006', '1995-01-01', CURDATE(), 1, NULL, NULL),
(23, 23, 'Joaquín', 'Pereyra', '82000006', '1992-01-01', CURDATE(), 1, NULL, NULL),
(24, 24, 'Morena', 'Benítez', '80000007', '1990-01-01', CURDATE(), 1, NULL, NULL),
(25, 25, 'Francisco', 'Vargas', '81000007', '1995-01-01', CURDATE(), 1, NULL, NULL),
(26, 26, 'Emilia', 'Paz', '82000007', '1992-01-01', CURDATE(), 1, NULL, NULL),
(27, 27, 'Leonardo', 'Rojas', '80000008', '1990-01-01', CURDATE(), 1, NULL, NULL),
(28, 28, 'Renata', 'Molina', '81000008', '1995-01-01', CURDATE(), 1, NULL, NULL),
(29, 29, 'Bruno', 'Cabrera', '82000008', '1992-01-01', CURDATE(), 1, NULL, NULL),
(30, 30, 'Paula', 'Córdoba', '80000009', '1990-01-01', CURDATE(), 1, NULL, NULL),
(31, 31, 'Diego', 'Rivera', '81000009', '1995-01-01', CURDATE(), 1, NULL, NULL),
(32, 32, 'Catalina', 'Gil', '82000009', '1992-01-01', CURDATE(), 1, NULL, NULL),
(33, 33, 'Ramiro', 'Arias', '80000010', '1990-01-01', CURDATE(), 1, NULL, NULL),
(34, 34, 'Zoe', 'Aguirre', '81000010', '1995-01-01', CURDATE(), 1, NULL, NULL),
(35, 35, 'Gabriel', 'Medina', '82000010', '1992-01-01', CURDATE(), 1, NULL, NULL),
(36, 36, 'Luciana', 'Vega', '80000011', '1990-01-01', CURDATE(), 1, NULL, NULL),
(37, 37, 'Ezequiel', 'Domínguez', '81000011', '1995-01-01', CURDATE(), 1, NULL, NULL),
(38, 38, 'Jazmín', 'Herrera', '82000011', '1992-01-01', CURDATE(), 1, NULL, NULL),
(39, 39, 'Maximiliano', 'Farías', '80000012', '1990-01-01', CURDATE(), 1, NULL, NULL),
(40, 40, 'Antonella', 'Costa', '81000012', '1995-01-01', CURDATE(), 1, NULL, NULL),
(41, 41, 'Thiago', 'Franco', '82000012', '1992-01-01', CURDATE(), 1, NULL, NULL),
(42, 42, 'Malena', 'Lozano', '80000013', '1990-01-01', CURDATE(), 1, NULL, NULL),
(43, 43, 'Ignacio', 'Benítez', '81000013', '1995-01-01', CURDATE(), 1, NULL, NULL),
(44, 44, 'Candela', 'Ibáñez', '82000013', '1992-01-01', CURDATE(), 1, NULL, NULL),
(45, 45, 'Alan', 'Méndez', '80000014', '1990-01-01', CURDATE(), 1, NULL, NULL),
(46, 46, 'Bianca', 'Suárez', '81000014', '1995-01-01', CURDATE(), 1, NULL, NULL),
(47, 47, 'Simón', 'Arias', '82000014', '1992-01-01', CURDATE(), 1, NULL, NULL),
(48, 48, 'Delfina', 'Paz', '80000015', '1990-01-01', CURDATE(), 1, NULL, NULL),
(49, 49, 'Francisco', 'Ríos', '81000015', '1995-01-01', CURDATE(), 1, NULL, NULL),
(50, 50, 'Lara', 'Ortiz', '82000015', '1992-01-01', CURDATE(), 1, NULL, NULL),
(51, 51, 'Julián', 'Vera', '80000016', '1990-01-01', CURDATE(), 1, NULL, NULL),
(52, 52, 'Mía', 'Luna', '81000016', '1995-01-01', CURDATE(), 1, NULL, NULL),
(53, 53, 'Benicio', 'Giménez', '82000016', '1992-01-01', CURDATE(), 1, NULL, NULL),
(54, 54, 'Olivia', 'Pereira', '80000017', '1990-01-01', CURDATE(), 1, NULL, NULL),
(55, 55, 'Valentina', 'Gil', '81000017', '1995-01-01', CURDATE(), 1, NULL, NULL),
(56, 56, 'Joel', 'Rojas', '82000017', '1992-01-01', CURDATE(), 1, NULL, NULL),
(57, 57, 'Alma', 'Ortega', '80000018', '1990-01-01', CURDATE(), 1, NULL, NULL),
(58, 58, 'Matías', 'Campos', '81000018', '1995-01-01', CURDATE(), 1, NULL, NULL),
(59, 59, 'Inés', 'Villalba', '82000018', '1992-01-01', CURDATE(), 1, NULL, NULL),
(60, 60, 'Ramón', 'Pereyra', '80000019', '1990-01-01', CURDATE(), 1, NULL, NULL),
(61, 61, 'Camila', 'Benítez', '81000019', '1995-01-01', CURDATE(), 1, NULL, NULL),
(62, 62, 'Federico', 'Álvarez', '82000019', '1992-01-01', CURDATE(), 1, NULL, NULL),
(63, 63, 'Paulina', 'Guerra', '80000020', '1990-01-01', CURDATE(), 1, NULL, NULL),
(64, 64, 'Agustín', 'Paz', '81000020', '1995-01-01', CURDATE(), 1, NULL, NULL),
(65, 65, 'Lorena', 'Vargas', '82000020', '1992-01-01', CURDATE(), 1, NULL, NULL),
(66, 66, 'Marcos', 'Arias', '80000021', '1990-01-01', CURDATE(), 1, NULL, NULL),
(67, 67, 'Sofía', 'Castro', '81000021', '1995-01-01', CURDATE(), 1, NULL, NULL),
(68, 68, 'Luciano', 'Paz', '82000021', '1992-01-01', CURDATE(), 1, NULL, NULL),
(69, 69, 'Dana', 'Arias', '80000022', '1990-01-01', CURDATE(), 1, NULL, NULL),
(70, 70, 'Lautaro', 'Acosta', '81000022', '1995-01-01', CURDATE(), 1, NULL, NULL),
(71, 71, 'Morena', 'Sosa', '82000022', '1992-01-01', CURDATE(), 1, NULL, NULL),
(72, 72, 'Bruno', 'Méndez', '80000023', '1990-01-01', CURDATE(), 1, NULL, NULL),
(73, 73, 'Malena', 'Flores', '81000023', '1995-01-01', CURDATE(), 1, NULL, NULL),
(74, 74, 'Santiago', 'Campos', '82000023', '1992-01-01', CURDATE(), 1, NULL, NULL),
(75, 75, 'Abril', 'Ríos', '80000024', '1990-01-01', CURDATE(), 1, NULL, NULL),
(76, 76, 'Thiago', 'Rojas', '81000024', '1995-01-01', CURDATE(), 1, NULL, NULL),
(77, 77, 'Julieta', 'Benítez', '82000024', '1992-01-01', CURDATE(), 1, NULL, NULL),
(78, 78, 'Mateo', 'Ríos', '80000025', '1990-01-01', CURDATE(), 1, NULL, NULL),
(79, 79, 'Antonella', 'Méndez', '81000025', '1995-01-01', CURDATE(), 1, NULL, NULL),
(80, 80, 'Joaquín', 'Vega', '82000025', '1992-01-01', CURDATE(), 1, NULL, NULL),
(81, 81, 'Catalina', 'Castro', '80000026', '1990-01-01', CURDATE(), 1, NULL, NULL),
(82, 82, 'Benjamín', 'Paz', '81000026', '1995-01-01', CURDATE(), 1, NULL, NULL),
(83, 83, 'Zoe', 'Martínez', '82000026', '1992-01-01', CURDATE(), 1, NULL, NULL),
(84, 84, 'Ignacio', 'Ríos', '80000027', '1990-01-01', CURDATE(), 1, NULL, NULL),
(85, 85, 'Milagros', 'Vega', '81000027', '1995-01-01', CURDATE(), 1, NULL, NULL),
(86, 86, 'Francisco', 'Gil', '82000027', '1992-01-01', CURDATE(), 1, NULL, NULL),
(87, 87, 'Mía', 'López', '80000028', '1990-01-01', CURDATE(), 1, NULL, NULL),
(88, 88, 'Leonardo', 'Díaz', '81000028', '1995-01-01', CURDATE(), 1, NULL, NULL),
(89, 89, 'Lara', 'Fernández', '82000028', '1992-01-01', CURDATE(), 1, NULL, NULL),
(90, 90, 'Ramiro', 'López', '80000029', '1990-01-01', CURDATE(), 1, NULL, NULL),
(91, 91, 'Paula', 'Medina', '81000029', '1995-01-01', CURDATE(), 1, NULL, NULL),
(92, 92, 'Maximiliano', 'Paz', '82000029', '1992-01-01', CURDATE(), 1, NULL, NULL),
(93, 93, 'Emilia', 'Castro', '80000030', '1990-01-01', CURDATE(), 1, NULL, NULL),
(94, 94, 'Ezequiel', 'Rojas', '81000030', '1995-01-01', CURDATE(), 1, NULL, NULL),
(95, 95, 'Valentina', 'Pereyra', '82000030', '1992-01-01', CURDATE(), 1, NULL, NULL),
(96, 96, 'Gabriel', 'Ortiz', '80000031', '1990-01-01', CURDATE(), 1, NULL, NULL),
(97, 97, 'Jazmín', 'Romero', '81000031', '1995-01-01', CURDATE(), 1, NULL, NULL),
(98, 98, 'Alan', 'Arias', '82000031', '1992-01-01', CURDATE(), 1, NULL, NULL),

-- Ayudantes de cocina: uno por unidad de venta
-- Ayudantes de cocina: uno por unidad de venta
(99, 99, 'Ayudante', 'Cocina 1', '90000099', '1995-01-01', CURDATE(), 1, NULL, NULL),
(100, 100, 'Ayudante', 'Cocina 2', '90000100', '1995-01-01', CURDATE(), 1, NULL, NULL),
(101, 101, 'Ayudante', 'Cocina 3', '90000101', '1995-01-01', CURDATE(), 1, NULL, NULL),
(102, 102, 'Ayudante', 'Cocina 4', '90000102', '1995-01-01', CURDATE(), 1, NULL, NULL),
(103, 103, 'Ayudante', 'Cocina 5', '90000103', '1995-01-01', CURDATE(), 1, NULL, NULL),
(104, 104, 'Ayudante', 'Cocina 6', '90000104', '1995-01-01', CURDATE(), 1, NULL, NULL),
(105, 105, 'Ayudante', 'Cocina 7', '90000105', '1995-01-01', CURDATE(), 1, NULL, NULL),
(106, 106, 'Ayudante', 'Cocina 8', '90000106', '1995-01-01', CURDATE(), 1, NULL, NULL),
(107, 107, 'Ayudante', 'Cocina 9', '90000107', '1995-01-01', CURDATE(), 1, NULL, NULL),
(108, 108, 'Ayudante', 'Cocina 10', '90000108', '1995-01-01', CURDATE(), 1, NULL, NULL),
(109, 109, 'Ayudante', 'Cocina 11', '90000109', '1995-01-01', CURDATE(), 1, NULL, NULL),
(110, 110, 'Ayudante', 'Cocina 12', '90000110', '1995-01-01', CURDATE(), 1, NULL, NULL),
(111, 111, 'Ayudante', 'Cocina 13', '90000111', '1995-01-01', CURDATE(), 1, NULL, NULL),
(112, 112, 'Ayudante', 'Cocina 14', '90000112', '1995-01-01', CURDATE(), 1, NULL, NULL),
(113, 113, 'Ayudante', 'Cocina 15', '90000113', '1995-01-01', CURDATE(), 1, NULL, NULL),
(114, 114, 'Ayudante', 'Cocina 16', '90000114', '1995-01-01', CURDATE(), 1, NULL, NULL),
(115, 115, 'Ayudante', 'Cocina 17', '90000115', '1995-01-01', CURDATE(), 1, NULL, NULL),
(116, 116, 'Ayudante', 'Cocina 18', '90000116', '1995-01-01', CURDATE(), 1, NULL, NULL),
(117, 117, 'Ayudante', 'Cocina 19', '90000117', '1995-01-01', CURDATE(), 1, NULL, NULL),
(118, 118, 'Ayudante', 'Cocina 20', '90000118', '1995-01-01', CURDATE(), 1, NULL, NULL),
(119, 119, 'Ayudante', 'Cocina 21', '90000119', '1995-01-01', CURDATE(), 1, NULL, NULL),
(120, 120, 'Ayudante', 'Cocina 22', '90000120', '1995-01-01', CURDATE(), 1, NULL, NULL),
(121, 121, 'Ayudante', 'Cocina 23', '90000121', '1995-01-01', CURDATE(), 1, NULL, NULL),
(122, 122, 'Ayudante', 'Cocina 24', '90000122', '1995-01-01', CURDATE(), 1, NULL, NULL),
(123, 123, 'Ayudante', 'Cocina 25', '90000123', '1995-01-01', CURDATE(), 1, NULL, NULL),
(124, 124, 'Ayudante', 'Cocina 26', '90000124', '1995-01-01', CURDATE(), 1, NULL, NULL),
(125, 125, 'Ayudante', 'Cocina 27', '90000125', '1995-01-01', CURDATE(), 1, NULL, NULL),
(126, 126, 'Ayudante', 'Cocina 28', '90000126', '1995-01-01', CURDATE(), 1, NULL, NULL),
(127, 127, 'Ayudante', 'Cocina 29', '90000127', '1995-01-01', CURDATE(), 1, NULL, NULL),
(128, 128, 'Ayudante', 'Cocina 30', '90000128', '1995-01-01', CURDATE(), 1, NULL, NULL),
(129, 129, 'Ayudante', 'Cocina 31', '90000129', '1995-01-01', CURDATE(), 1, NULL, NULL),
(130, 130, 'Ayudante', 'Cocina 32', '90000130', '1995-01-01', CURDATE(), 1, NULL, NULL),

-- Lavaplatos: uno por unidad de venta
(131, 131, 'Lavaplatos', 'Unidad 1', '90000131', '1995-01-01', CURDATE(), 1, NULL, NULL),
(132, 132, 'Lavaplatos', 'Unidad 2', '90000132', '1995-01-01', CURDATE(), 1, NULL, NULL),
(133, 133, 'Lavaplatos', 'Unidad 3', '90000133', '1995-01-01', CURDATE(), 1, NULL, NULL),
(134, 134, 'Lavaplatos', 'Unidad 4', '90000134', '1995-01-01', CURDATE(), 1, NULL, NULL),
(135, 135, 'Lavaplatos', 'Unidad 5', '90000135', '1995-01-01', CURDATE(), 1, NULL, NULL),
(136, 136, 'Lavaplatos', 'Unidad 6', '90000136', '1995-01-01', CURDATE(), 1, NULL, NULL),
(137, 137, 'Lavaplatos', 'Unidad 7', '90000137', '1995-01-01', CURDATE(), 1, NULL, NULL),
(138, 138, 'Lavaplatos', 'Unidad 8', '90000138', '1995-01-01', CURDATE(), 1, NULL, NULL),
(139, 139, 'Lavaplatos', 'Unidad 9', '90000139', '1995-01-01', CURDATE(), 1, NULL, NULL),
(140, 140, 'Lavaplatos', 'Unidad 10', '90000140', '1995-01-01', CURDATE(), 1, NULL, NULL),
(141, 141, 'Lavaplatos', 'Unidad 11', '90000141', '1995-01-01', CURDATE(), 1, NULL, NULL),
(142, 142, 'Lavaplatos', 'Unidad 12', '90000142', '1995-01-01', CURDATE(), 1, NULL, NULL),
(143, 143, 'Lavaplatos', 'Unidad 13', '90000143', '1995-01-01', CURDATE(), 1, NULL, NULL),
(144, 144, 'Lavaplatos', 'Unidad 14', '90000144', '1995-01-01', CURDATE(), 1, NULL, NULL),
(145, 145, 'Lavaplatos', 'Unidad 15', '90000145', '1995-01-01', CURDATE(), 1, NULL, NULL),
(146, 146, 'Lavaplatos', 'Unidad 16', '90000146', '1995-01-01', CURDATE(), 1, NULL, NULL),
(147, 147, 'Lavaplatos', 'Unidad 17', '90000147', '1995-01-01', CURDATE(), 1, NULL, NULL),
(148, 148, 'Lavaplatos', 'Unidad 18', '90000148', '1995-01-01', CURDATE(), 1, NULL, NULL),
(149, 149, 'Lavaplatos', 'Unidad 19', '90000149', '1995-01-01', CURDATE(), 1, NULL, NULL),
(150, 150, 'Lavaplatos', 'Unidad 20', '90000150', '1995-01-01', CURDATE(), 1, NULL, NULL),
(151, 151, 'Lavaplatos', 'Unidad 21', '90000151', '1995-01-01', CURDATE(), 1, NULL, NULL),
(152, 152, 'Lavaplatos', 'Unidad 22', '90000152', '1995-01-01', CURDATE(), 1, NULL, NULL),
(153, 153, 'Lavaplatos', 'Unidad 23', '90000153', '1995-01-01', CURDATE(), 1, NULL, NULL),
(154, 154, 'Lavaplatos', 'Unidad 24', '90000154', '1995-01-01', CURDATE(), 1, NULL, NULL),
(155, 155, 'Lavaplatos', 'Unidad 25', '90000155', '1995-01-01', CURDATE(), 1, NULL, NULL),
(156, 156, 'Lavaplatos', 'Unidad 26', '90000156', '1995-01-01', CURDATE(), 1, NULL, NULL),
(157, 157, 'Lavaplatos', 'Unidad 27', '90000157', '1995-01-01', CURDATE(), 1, NULL, NULL),
(158, 158, 'Lavaplatos', 'Unidad 28', '90000158', '1995-01-01', CURDATE(), 1, NULL, NULL),
(159, 159, 'Lavaplatos', 'Unidad 29', '90000159', '1995-01-01', CURDATE(), 1, NULL, NULL),
(160, 160, 'Lavaplatos', 'Unidad 30', '90000160', '1995-01-01', CURDATE(), 1, NULL, NULL),
(161, 161, 'Lavaplatos', 'Unidad 31', '90000161', '1995-01-01', CURDATE(), 1, NULL, NULL),
(162, 162, 'Lavaplatos', 'Unidad 32', '90000162', '1995-01-01', CURDATE(), 1, NULL, NULL);
-- =====================================================
-- SUBTIPOS DE EMPLEADOS
-- =====================================================
INSERT INTO `cajero` (`id`, `turno`)
VALUES
(4, 'MANIANA'),
(7, 'MANIANA'),
(10, 'MANIANA'),
(13, 'MANIANA'),
(16, 'MANIANA'),
(19, 'MANIANA'),
(22, 'MANIANA'),
(25, 'MANIANA'),
(28, 'MANIANA'),
(31, 'MANIANA'),
(34, 'MANIANA'),
(37, 'MANIANA'),
(40, 'MANIANA'),
(43, 'MANIANA'),
(46, 'MANIANA'),
(49, 'MANIANA'),
(52, 'MANIANA'),
(55, 'MANIANA'),
(58, 'MANIANA'),
(61, 'MANIANA'),
(64, 'MANIANA'),
(67, 'MANIANA'),
(70, 'MANIANA'),
(73, 'MANIANA'),
(76, 'MANIANA'),
(79, 'MANIANA'),
(82, 'MANIANA'),
(85, 'MANIANA'),
(88, 'MANIANA'),
(91, 'MANIANA'),
(94, 'MANIANA'),
(97, 'MANIANA');

INSERT INTO `cocinero` (`id`, `categoria`)
VALUES
(5, 'COCINERO'),
(8, 'COCINERO'),
(11, 'COCINERO'),
(14, 'COCINERO'),
(17, 'COCINERO'),
(20, 'COCINERO'),
(23, 'COCINERO'),
(26, 'COCINERO'),
(29, 'COCINERO'),
(32, 'COCINERO'),
(35, 'COCINERO'),
(38, 'COCINERO'),
(41, 'COCINERO'),
(44, 'COCINERO'),
(47, 'COCINERO'),
(50, 'COCINERO'),
(53, 'COCINERO'),
(56, 'COCINERO'),
(59, 'COCINERO'),
(62, 'COCINERO'),
(65, 'COCINERO'),
(68, 'COCINERO'),
(71, 'COCINERO'),
(74, 'COCINERO'),
(77, 'COCINERO'),
(80, 'COCINERO'),
(83, 'COCINERO'),
(86, 'COCINERO'),
(89, 'COCINERO'),
(92, 'COCINERO'),
(95, 'COCINERO'),
(98, 'COCINERO'),

-- Ayudantes de cocina
(99, 'AYUDANTE_COCINA'),
(100, 'AYUDANTE_COCINA'),
(101, 'AYUDANTE_COCINA'),
(102, 'AYUDANTE_COCINA'),
(103, 'AYUDANTE_COCINA'),
(104, 'AYUDANTE_COCINA'),
(105, 'AYUDANTE_COCINA'),
(106, 'AYUDANTE_COCINA'),
(107, 'AYUDANTE_COCINA'),
(108, 'AYUDANTE_COCINA'),
(109, 'AYUDANTE_COCINA'),
(110, 'AYUDANTE_COCINA'),
(111, 'AYUDANTE_COCINA'),
(112, 'AYUDANTE_COCINA'),
(113, 'AYUDANTE_COCINA'),
(114, 'AYUDANTE_COCINA'),
(115, 'AYUDANTE_COCINA'),
(116, 'AYUDANTE_COCINA'),
(117, 'AYUDANTE_COCINA'),
(118, 'AYUDANTE_COCINA'),
(119, 'AYUDANTE_COCINA'),
(120, 'AYUDANTE_COCINA'),
(121, 'AYUDANTE_COCINA'),
(122, 'AYUDANTE_COCINA'),
(123, 'AYUDANTE_COCINA'),
(124, 'AYUDANTE_COCINA'),
(125, 'AYUDANTE_COCINA'),
(126, 'AYUDANTE_COCINA'),
(127, 'AYUDANTE_COCINA'),
(128, 'AYUDANTE_COCINA'),
(129, 'AYUDANTE_COCINA'),
(130, 'AYUDANTE_COCINA'),

-- Lavaplatos
(131, 'LAVAPLATOS'),
(132, 'LAVAPLATOS'),
(133, 'LAVAPLATOS'),
(134, 'LAVAPLATOS'),
(135, 'LAVAPLATOS'),
(136, 'LAVAPLATOS'),
(137, 'LAVAPLATOS'),
(138, 'LAVAPLATOS'),
(139, 'LAVAPLATOS'),
(140, 'LAVAPLATOS'),
(141, 'LAVAPLATOS'),
(142, 'LAVAPLATOS'),
(143, 'LAVAPLATOS'),
(144, 'LAVAPLATOS'),
(145, 'LAVAPLATOS'),
(146, 'LAVAPLATOS'),
(147, 'LAVAPLATOS'),
(148, 'LAVAPLATOS'),
(149, 'LAVAPLATOS'),
(150, 'LAVAPLATOS'),
(151, 'LAVAPLATOS'),
(152, 'LAVAPLATOS'),
(153, 'LAVAPLATOS'),
(154, 'LAVAPLATOS'),
(155, 'LAVAPLATOS'),
(156, 'LAVAPLATOS'),
(157, 'LAVAPLATOS'),
(158, 'LAVAPLATOS'),
(159, 'LAVAPLATOS'),
(160, 'LAVAPLATOS'),
(161, 'LAVAPLATOS'),
(162, 'LAVAPLATOS');
-- =====================================================
-- 5. CARGA DE UNIDADES DE VENTA (Food Trucks y Puestos Desarmables)
-- Códigos únicos de 10 caracteres según requerimientos del TP.
-- =====================================================
-- Responsables: un responsable por unidad.
INSERT INTO unidad_de_venta
    (id, codigo, nombre_comercial, superficie, festival_id, responsable_id)
VALUES
    (1,  'FT00000001', 'Panchos Truck',        25.00, 1, 2),
    (2,  'PD00000001', 'Puesto de Tacos',      15.00, 1, 6),
    (3,  'FT00000002', 'Burger Truck',          25.00, 1, 9),
    (4,  'PD00000002', 'Puesto de Tacos',      15.00, 1, 12),
    (5,  'FT00000003', 'Pizza al Paso',         20.00, 1, 15),
    (6,  'PD00000003', 'Puesto de Empanadas',   12.00, 1, 18),
    (7,  'FT00000004', 'Food Truck Gourmet',    22.00, 1, 21),
    (8,  'FT00000005', 'Burger Fest',           25.00, 2, 24),
    (9,  'PD00000004', 'Tacos Fest',            15.00, 2, 27),
    (10, 'FT00000006', 'Pizza Fest',            20.00, 2, 30),
    (11, 'UV204VENTA', 'Empanadas Fest',        12.00, 2, 33),
    (12, 'UV205VENTA', 'Gourmet Fest',          22.00, 2, 36),
    (13, 'UV301VENTA', 'Burger de Otoño',       25.00, 3, 39),
    (14, 'UV302VENTA', 'Tacos de Otoño',        15.00, 3, 42),
    (15, 'UV303VENTA', 'Pizza de Otoño',        20.00, 3, 45),
    (16, 'UV304VENTA', 'Empanadas de Otoño',    12.00, 3, 48),
    (17, 'UV305VENTA', 'Sabores Gourmet',       22.00, 3, 51),
    (18, 'UV401VENTA', 'Burger de Invierno',    25.00, 4, 54),
    (19, 'UV402VENTA', 'Tacos de Invierno',     15.00, 4, 57),
    (20, 'UV403VENTA', 'Pizza de Invierno',     20.00, 4, 60),
    (21, 'UV404VENTA', 'Empanadas Calientes',   12.00, 4, 63),
    (22, 'UV405VENTA', 'Gourmet de Invierno',   22.00, 4, 66),
    (23, 'UV501VENTA', 'Street Burger',         25.00, 5, 69),
    (24, 'UV502VENTA', 'Street Tacos',          15.00, 5, 72),
    (25, 'UV503VENTA', 'Street Pizza',          20.00, 5, 75),
    (26, 'UV504VENTA', 'Street Empanadas',      12.00, 5, 78),
    (27, 'UV505VENTA', 'Street Gourmet',        22.00, 5, 81),
    (28, 'UV601VENTA', 'Sabores Burger',        25.00, 6, 84),
    (29, 'UV602VENTA', 'Sabores Tacos',         15.00, 6, 87),
    (30, 'UV603VENTA', 'Sabores Pizza',         20.00, 6, 90),
    (31, 'UV604VENTA', 'Sabores Empanadas',     12.00, 6, 93),
    (32, 'UV605VENTA', 'Sabores Gourmet',       22.00, 6, 96);

-- Subtipos de las nuevas unidades: Food Trucks
INSERT INTO `foodtruck` (`id`, `patente`, `requiere_electricidad`)
VALUES
    (1,'AB123ZE', 1),
    (3,  'AB123CD', 1),
    (5,  'AC123DE', 1),
    (7,  'AD123EF', 0),
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

        -- Unidad 7: bebidas y combos
        (19,'Limonada Casera', 2800.00, 700.00, TRUE, 7),
        (20,'Gaseosa 500 ml', 2200.00, 800.00, TRUE, 7),
        (21,'Combo Hamburguesa y Bebida', 10500.00, 4200.00, TRUE, 7),
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

    -- Unidad 7: completar 5 platos
    (34, 'Agua Mineral 500 ml', 1800.00, 500.00, TRUE, 7),
    (35, 'Limonada con Menta', 3200.00, 900.00, TRUE, 7),

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
(12, '2026-10-05 20:00:00', 6),

(13, '2026-10-05 18:15:00', 7),
(14, '2026-10-05 21:00:00', 7);

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
(18, 12, 17, 3, 4200.00, 12600.00),

-- Unidad 7: Bebidas y combos
(19, 13, 21, 2, 10500.00, 21000.00),
(20, 13, 19, 2,  2800.00,  5600.00),
(21, 14, 20, 3,  2200.00,  6600.00);

-- =====================================================
-- 8. CIERRES DE CAJA Y LIQUIDACIÓN DE HABERES (PRUEBAS DE REPORTES)
-- =====================================================
INSERT INTO `cierre_de_caja`
    (`id`, `cajero_id`, `festival_id`, `unidad_venta_id`,
     `fecha_hora_cierre`, `total_sistema`, `total_declarado`, `diferencia`)
VALUES
    (1,  4, 1, 1, '2026-10-05 23:00:00', 29500.00, 29500.00,      0.00),
    (2,  7, 1, 2, '2026-10-05 23:15:00', 39200.00, 39400.00,    200.00),
    (3, 10, 1, 3, '2026-10-05 23:30:00', 47500.00, 47000.00,   -500.00),
    (4, 13, 1, 4, '2026-10-05 23:45:00', 35800.00, 19000.00, -16800.00),
    (5, 16, 1, 5, '2026-10-06 00:00:00', 40100.00, 21500.00, -18600.00),
    (6, 19, 1, 6, '2026-10-06 00:15:00', 29200.00, 29000.00,   -200.00),
    (7, 22, 1, 7, '2026-10-06 00:30:00', 33200.00, 33200.00,      0.00);
INSERT INTO `liquidacion_de_haberes`
    (`id`, `empleado_id`, `festival_id`, `fecha`,
     `dias_festival`, `sueldo`, `adicional_aplicado`,
     `factor_aplicado`, `total`)
VALUES
    -- Unidad 1: Carlos, Ana, Juan y María
    (1,  4, 1, '2026-10-20', 20,  90000.00, 20000.00, 1.00, 110000.00),
    (2,  5, 1, '2026-10-20', 20, 120000.00, 40000.00, 1.00, 160000.00),

    -- Unidad 2: Lucas, Martín y Valentina
    (3,  7, 1, '2026-10-20', 15, 100000.00, 15000.00, 1.00, 115000.00),
    (4,  8, 1, '2026-10-20', 15, 135000.00, 30000.00, 1.10, 181500.00),

    -- Unidad 3: Sofía, Facundo y Camila
    (5, 10, 1, '2026-10-20', 18,  90000.00, 18000.00, 1.00, 108000.00),
    (6, 11, 1, '2026-10-20', 18, 120000.00, 45000.00, 1.10, 181500.00),

    -- Unidad 4: Tomás, Florencia y Nicolás
    (7, 13, 1, '2026-10-20', 20,  90000.00, 25000.00, 1.00, 115000.00),
    (8, 14, 1, '2026-10-20', 20, 120000.00, 50000.00, 1.10, 187000.00),

    -- Unidad 5: Julieta, Mateo y Agustín
    (9, 16, 1, '2026-10-20', 12, 100000.00, 12000.00, 1.00, 112000.00),
    (10,17, 1, '2026-10-20', 12, 135000.00, 35000.00, 1.10, 187000.00),

    -- Unidad 6: Martina, Santiago y Milagros
    (11,19, 1, '2026-10-20', 16,  90000.00, 20000.00, 1.00, 110000.00),
    (12,20, 1, '2026-10-20', 16, 120000.00, 40000.00, 1.10, 176000.00),

    -- Unidad 7: Benjamín, Abril y Joaquín
    (13,22, 1, '2026-10-20', 20, 100000.00, 25000.00, 1.00, 125000.00),
    (14,23, 1, '2026-10-20', 20, 135000.00, 50000.00, 1.10, 203500.00);

-- =====================================================
-- asignamos staff a sus unidades de venta
-- =====================================================

-- Unidad 1
UPDATE staff SET unidad_venta_id = 1 WHERE id IN (2, 3, 4, 5);

-- Unidad 2
UPDATE staff SET unidad_venta_id = 2 WHERE id IN (6, 7, 8);

-- Unidad 3
UPDATE staff SET unidad_venta_id = 3 WHERE id IN (9, 10, 11);

-- Unidad 4
UPDATE staff SET unidad_venta_id = 4 WHERE id IN (12, 13, 14);

-- Unidad 5
UPDATE staff SET unidad_venta_id = 5 WHERE id IN (15, 16, 17);

-- Unidad 6
UPDATE staff SET unidad_venta_id = 6 WHERE id IN (18, 19, 20);

-- Unidad 7
UPDATE staff SET unidad_venta_id = 7 WHERE id IN (21, 22, 23);

-- Unidad 8
UPDATE staff SET unidad_venta_id = 8 WHERE id IN (24, 25, 26);

-- Unidad 9
UPDATE staff SET unidad_venta_id = 9 WHERE id IN (27, 28, 29);

-- Unidad 10
UPDATE staff SET unidad_venta_id = 10 WHERE id IN (30, 31, 32);

-- Unidad 11
UPDATE staff SET unidad_venta_id = 11 WHERE id IN (33, 34, 35);

-- Unidad 12
UPDATE staff SET unidad_venta_id = 12 WHERE id IN (36, 37, 38);

-- Unidad 13
UPDATE staff SET unidad_venta_id = 13 WHERE id IN (39, 40, 41);

-- Unidad 14
UPDATE staff SET unidad_venta_id = 14 WHERE id IN (42, 43, 44);

-- Unidad 15
UPDATE staff SET unidad_venta_id = 15 WHERE id IN (45, 46, 47);

-- Unidad 16
UPDATE staff SET unidad_venta_id = 16 WHERE id IN (48, 49, 50);

-- Unidad 17
UPDATE staff SET unidad_venta_id = 17 WHERE id IN (51, 52, 53);

-- Unidad 18
UPDATE staff SET unidad_venta_id = 18 WHERE id IN (54, 55, 56);

-- Unidad 19
UPDATE staff SET unidad_venta_id = 19 WHERE id IN (57, 58, 59);

-- Unidad 20
UPDATE staff SET unidad_venta_id = 20 WHERE id IN (60, 61, 62);

-- Unidad 21
UPDATE staff SET unidad_venta_id = 21 WHERE id IN (63, 64, 65);

-- Unidad 22
UPDATE staff SET unidad_venta_id = 22 WHERE id IN (66, 67, 68);

-- Unidad 23
UPDATE staff SET unidad_venta_id = 23 WHERE id IN (69, 70, 71);

-- Unidad 24
UPDATE staff SET unidad_venta_id = 24 WHERE id IN (72, 73, 74);

-- Unidad 25
UPDATE staff SET unidad_venta_id = 25 WHERE id IN (75, 76, 77);

-- Unidad 26
UPDATE staff SET unidad_venta_id = 26 WHERE id IN (78, 79, 80);

-- Unidad 27
UPDATE staff SET unidad_venta_id = 27 WHERE id IN (81, 82, 83);

-- Unidad 28
UPDATE staff SET unidad_venta_id = 28 WHERE id IN (84, 85, 86);

-- Unidad 29
UPDATE staff SET unidad_venta_id = 29 WHERE id IN (87, 88, 89);

-- Unidad 30
UPDATE staff SET unidad_venta_id = 30 WHERE id IN (90, 91, 92);

-- Unidad 31
UPDATE staff SET unidad_venta_id = 31 WHERE id IN (93, 94, 95);

-- Unidad 32
UPDATE staff SET unidad_venta_id = 32 WHERE id IN (96, 97, 98);

------------ayudantes y lavaplatos --------------------
-- Unidad 1
UPDATE staff SET unidad_venta_id = 1 WHERE id IN (99, 131);

-- Unidad 2
UPDATE staff SET unidad_venta_id = 2 WHERE id IN (100, 132);

-- Unidad 3
UPDATE staff SET unidad_venta_id = 3 WHERE id IN (101, 133);

-- Unidad 4
UPDATE staff SET unidad_venta_id = 4 WHERE id IN (102, 134);

-- Unidad 5
UPDATE staff SET unidad_venta_id = 5 WHERE id IN (103, 135);

-- Unidad 6
UPDATE staff SET unidad_venta_id = 6 WHERE id IN (104, 136);

-- Unidad 7
UPDATE staff SET unidad_venta_id = 7 WHERE id IN (105, 137);

-- Unidad 8
UPDATE staff SET unidad_venta_id = 8 WHERE id IN (106, 138);

-- Unidad 9
UPDATE staff SET unidad_venta_id = 9 WHERE id IN (107, 139);

-- Unidad 10
UPDATE staff SET unidad_venta_id = 10 WHERE id IN (108, 140);

-- Unidad 11
UPDATE staff SET unidad_venta_id = 11 WHERE id IN (109, 141);

-- Unidad 12
UPDATE staff SET unidad_venta_id = 12 WHERE id IN (110, 142);

-- Unidad 13
UPDATE staff SET unidad_venta_id = 13 WHERE id IN (111, 143);

-- Unidad 14
UPDATE staff SET unidad_venta_id = 14 WHERE id IN (112, 144);

-- Unidad 15
UPDATE staff SET unidad_venta_id = 15 WHERE id IN (113, 145);

-- Unidad 16
UPDATE staff SET unidad_venta_id = 16 WHERE id IN (114, 146);

-- Unidad 17
UPDATE staff SET unidad_venta_id = 17 WHERE id IN (115, 147);

-- Unidad 18
UPDATE staff SET unidad_venta_id = 18 WHERE id IN (116, 148);

-- Unidad 19
UPDATE staff SET unidad_venta_id = 19 WHERE id IN (117, 149);

-- Unidad 20
UPDATE staff SET unidad_venta_id = 20 WHERE id IN (118, 150);

-- Unidad 21
UPDATE staff SET unidad_venta_id = 21 WHERE id IN (119, 151);

-- Unidad 22
UPDATE staff SET unidad_venta_id = 22 WHERE id IN (120, 152);

-- Unidad 23
UPDATE staff SET unidad_venta_id = 23 WHERE id IN (121, 153);

-- Unidad 24
UPDATE staff SET unidad_venta_id = 24 WHERE id IN (122, 154);

-- Unidad 25
UPDATE staff SET unidad_venta_id = 25 WHERE id IN (123, 155);

-- Unidad 26
UPDATE staff SET unidad_venta_id = 26 WHERE id IN (124, 156);

-- Unidad 27
UPDATE staff SET unidad_venta_id = 27 WHERE id IN (125, 157);

-- Unidad 28
UPDATE staff SET unidad_venta_id = 28 WHERE id IN (126, 158);

-- Unidad 29
UPDATE staff SET unidad_venta_id = 29 WHERE id IN (127, 159);

-- Unidad 30
UPDATE staff SET unidad_venta_id = 30 WHERE id IN (128, 160);

-- Unidad 31
UPDATE staff SET unidad_venta_id = 31 WHERE id IN (129, 161);

-- Unidad 32
UPDATE staff SET unidad_venta_id = 32 WHERE id IN (130, 162);