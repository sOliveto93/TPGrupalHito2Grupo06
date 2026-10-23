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
(98,'alanarias','alanarias@gmail.com','$2a$10$vPmxwQFVLUq6FWAwU0EwU.Ub.F6zzlwkn1NpVc3s9n5Lajf1uyd6u',1,NOW(),NOW());

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
(96,96,'ROLE_RESPONSABLE',NOW(),NOW()),(97,97,'ROLE_EMPLEADO',NOW(),NOW()),(98,98,'ROLE_EMPLEADO',NOW(),NOW());

-- =====================================================
-- 4. CARGA DE STAFF / PERSONAL
-- =====================================================
INSERT INTO `staff` (`id`, `usuario_id`, `name`, apellido, `dni`, `fecha_nac`, `fecha_ingreso`, `activo`, `fecha_baja`, `unidad_venta_id`)
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
(98, 98, 'Alan', 'Arias', '82000031', '1992-01-01', CURDATE(), 1, NULL, NULL);
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
(98, 'COCINERO');
-- =====================================================
-- 5. CARGA DE UNIDADES DE VENTA (Food Trucks y Puestos Desarmables)
-- Códigos únicos de 10 caracteres según requerimientos del TP.
-- =====================================================
-- Responsables: un responsable por unidad.
INSERT INTO unidad_de_venta
    (id, codigo, nombre_comercial, superficie, festival_id, responsable_id)
VALUES
    (1,  'UV101VENTA', 'Panchos Truck',        25.00, 1, 2),
    (2,  'UV102VENTA', 'Puesto de Tacos',      15.00, 1, 6),
    (3,  'UV103VENTA', 'Burger Truck',          25.00, 1, 9),
    (4,  'UV104VENTA', 'Puesto de Tacos',      15.00, 1, 12),
    (5,  'UV105VENTA', 'Pizza al Paso',         20.00, 1, 15),
    (6,  'UV106VENTA', 'Puesto de Empanadas',   12.00, 1, 18),
    (7,  'UV107VENTA', 'Food Truck Gourmet',    22.00, 1, 21),
    (8,  'UV201VENTA', 'Burger Fest',           25.00, 2, 24),
    (9,  'UV202VENTA', 'Tacos Fest',            15.00, 2, 27),
    (10, 'UV203VENTA', 'Pizza Fest',            20.00, 2, 30),
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
VALUES (1, 4, 1, 1,
        '2026-10-05 23:00:00', 29500.00, 29500.00, 0.00);

INSERT INTO `liquidacion_de_haberes` (`id`, `empleado_id`, `festival_id`, `fecha`,
                                      `dias_festival`, `sueldo`, `adicional_aplicado`, `factor_aplicado`, `total`)
VALUES (1, 4, 1, '2026-10-20',
        20, 100000.00, 20000.00, 1.00, 120000.00),
        (2, 5, 1, '2026-10-20', 15, 100000.00, 150000.00, 1.00, 250000.00),
        (3, 2, 1, '2026-10-20', 20, 100000.00, 50000.00, 1.10, 165000.00);

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