-- =========================================================
-- REGENERAR PEDIDOS Y DETALLES
-- 10 pedidos por día por cada unidad de venta
-- =========================================================

DELETE FROM detalle_pedido;
DELETE FROM pedido;

-- ---------------------------------------------------------
-- 1. Generar pedidos según las fechas de cada festival
-- ---------------------------------------------------------

INSERT INTO pedido (id, fecha_hora, unidad_venta_id)
WITH RECURSIVE fechas AS (
    SELECT
        id AS festival_id,
        DATE(fecha_inicio) AS fecha,
        DATE(fecha_fin) AS fecha_fin
    FROM festival

    UNION ALL

    SELECT
        festival_id,
        DATE_ADD(fecha, INTERVAL 1 DAY),
        fecha_fin
    FROM fechas
    WHERE fecha < fecha_fin
),
numeros AS (
    SELECT 1 AS numero
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
),
pedidos_generados AS (
    SELECT
        uv.id AS unidad_venta_id,
        f.fecha,
        n.numero,
        ROW_NUMBER() OVER (
            ORDER BY uv.id, f.fecha, n.numero
        ) AS pedido_id
    FROM unidad_de_venta uv
    INNER JOIN festival fest
        ON fest.id = uv.festival_id
    INNER JOIN fechas f
        ON f.festival_id = fest.id
    WHERE fest.fecha_inicio <= CURRENT_DATE
    CROSS JOIN numeros n
)
SELECT
    pedido_id,
    TIMESTAMP(
        fecha,
        SEC_TO_TIME((8 + numero) * 3600)
    ),
    unidad_venta_id
FROM pedidos_generados
ORDER BY pedido_id;


-- ---------------------------------------------------------
-- 2. Generar detalles asociados a platos de cada unidad
-- Cada pedido tendrá uno o dos detalles
-- ---------------------------------------------------------

INSERT INTO detalle_pedido (
    id,
    pedido_id,
    plato_id,
    cantidad,
    precio_unitario,
    subtotal
)
WITH numeros AS (
    SELECT 1 AS numero
    UNION ALL SELECT 2
),
platos_ordenados AS (
    SELECT
        id,
        unidad_venta_id,
        precio,
        ROW_NUMBER() OVER (
            PARTITION BY unidad_venta_id
            ORDER BY id
        ) AS numero_plato,
        COUNT(*) OVER (
            PARTITION BY unidad_venta_id
        ) AS total_platos
    FROM plato
),
detalles_generados AS (
    SELECT
        pe.id AS pedido_id,
        pl.id AS plato_id,
        1 + MOD(pe.id + n.numero, 3) AS cantidad,
        pl.precio AS precio_unitario,
        ROW_NUMBER() OVER (
            ORDER BY pe.id, n.numero
        ) AS detalle_id
    FROM pedido pe
    CROSS JOIN numeros n
    INNER JOIN platos_ordenados pl
        ON pl.unidad_venta_id = pe.unidad_venta_id
        AND pl.numero_plato =
            MOD(pe.id + n.numero - 2, pl.total_platos) + 1
    WHERE n.numero <= 1 + MOD(pe.id, 2)
)
SELECT
    detalle_id,
    pedido_id,
    plato_id,
    cantidad,
    precio_unitario,
    cantidad * precio_unitario
FROM detalles_generados
ORDER BY detalle_id;