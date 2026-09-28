INSERT INTO roles_usuario (nombreRol)
VALUES
	('Administrador'),
    ('Encargado de almacen');

INSERT INTO usuario (username, contraseña, nombreUsuario, apellidoUsuario, idRolUsuario, usuarioActivo)
VALUES
	('Admin123', 'clave123', 'Juan', 'Perez', 1, true),
    ('Pepe', 'clave222', 'Pedro', 'Diaz', 2, true),
    ('Felipe', 'clave333', 'Felipe', 'Belli', 2, true);

INSERT INTO cliente (nombreCliente, apellidoCliente, dni, telefono, email, direccion)
VALUES
	('Francisco', 'Rojas', '46499888', '3413876492', 'franrj@gmail.com', 'San Martín 820, Rosario, Santa Fe'),
    ('Valentina', 'Gómez', '20948274', '3413646284', 'valen.gomez.01@yahoo.com', 'Av. Colón 2341, Rosario, Santa Fe'),
    ('Mateo', 'Fernandez', '28983250', '3413092326', 'mateo.fernandez@hotmail.com', 'Av. Pellegrini 1180, Rosario, Santa Fe');

INSERT INTO proveedor (nombreProveedor, telefono, email, direccion)
VALUES
	('Distribuidora La Cosecha S.A.', '341876543', 'contacto@lacosecha.com.ar', 'Av. Circunvalación 1250, Rosario, Santa Fe'),
	('Alimentos del Centro S.R.L.', '341939494', 'ventas@alimentosdelcentro.com.ar', 'Av. Colón 1840, Rosario, Santa Fe'),
	('Frigorífica y Alimentos Andinos S.A.', '341098772', 'info@alimentandinos.com.ar', 'San Martín 920, Rosario, Santa Fe');

INSERT INTO producto (descripcion, precio, stockMinimo, stockMaximo, stockActual)
VALUES
	('Arroz largo fino 1kg', 1500.00, 20, 100, 40),
	('Aceite de oliva 500ml', 4500.00, 10, 60, 30),
	('Atún en lata 170g', 2800.00, 10, 50, 20),
	('Lentejas secas 500g', 1800.00, 15, 80, 20);

INSERT INTO pedido (fecha, idProveedor)
VALUES
	('2026-09-10', 1),
    ('2026-09-10', 2),
    ('2026-09-20', 1);


INSERT INTO detalle_pedido (idPedido, idProducto, cantidad, precioUnitario, precioTotal)
VALUES
	(1, 1, 60, 1500, 90000.00),
	(1, 2, 30, 4500, 135000.00),
    
	(2, 3, 30, 2800.00, 84000.0),
	(2, 4, 40, 1800.00, 72000.00),
    
	(3, 4, 20, 1800.00, 36000.00);

INSERT INTO estado_venta (nombreEstado)
VALUES
	('Pendiente'),
	('Confirmado'),
	('Anulado');

INSERT INTO venta (fecha, idEstadoVenta, idUsuario, idCliente)
VALUE
	('2026-09-05', 2, 2, 1),
	('2026-09-19', 1, 2, 2),
    ('2026-09-15', 2, 3, 1);

INSERT INTO detalle_venta (idVenta, idProducto, cantidad, precioUnitario, precioTotal)
VALUE
	(1, 1, 10, 1500.00, 15000.00),
    (1, 2, 1, 4500.00, 4500.00),
    
    (2, 4, 7, 1800.00, 12600.00),
    
    (3, 2, 2, 4500.00, 9000.00),
    (3, 3, 5, 2800.00, 14000.00);

INSERT INTO historial (fecha, idProducto, cantidad, tipoMovimiento)
VALUES
	('2026-09-10', 1, 60, 'Ingreso'),
	('2026-09-10', 2, 30, 'Ingreso'),
	('2026-09-10', 3, 30, 'Ingreso'),
	('2026-09-10', 4, 40, 'Ingreso'),
	('2026-09-20', 4, 20, 'Ingreso'),
    
    ('2026-09-05', 1, 10, 'Egreso'),
    ('2026-09-05', 2, 1, 'Egreso'),
    ('2026-09-19', 4, 7, 'Egreso'),
    ('2026-09-15', 2, 2, 'Egreso'),
    ('2026-09-15', 3, 5, 'Egreso');
    
-- Consultar Detalle de Ventas (Con información del Cliente y Producto)
SELECT 
    VE.fecha AS 'Fecha Venta',
    CL.nombreCliente AS 'Nombre Cliente',
    CL.apellidoCliente AS 'Apellido Cliente',
    PR.descripcion AS 'Producto',
    DV.cantidad AS 'Cantidad',
    DV.precioUnitario AS 'Precio Unitario',
    DV.precioTotal AS 'Precio Total',
    US.username AS 'Vendedor'
FROM 
    venta VE,
    cliente CL,
    detalle_venta DV,
    producto PR,
    usuario US
WHERE 
    VE.idCliente = CL.idCliente
    AND VE.idVenta = DV.idVenta
    AND DV.idProducto = PR.idProducto
    AND VE.idUsuario = US.idUsuario;

-- Consultar Detalle de Pedidos (A Proveedores)
SELECT
    PE.fecha AS 'Fecha Pedido',
    PV.nombreProveedor AS 'Proveedor',
    PR.descripcion AS 'Producto',
    DP.cantidad AS 'Cantidad',
    DP.precioUnitario AS 'Costo Unitario',
    DP.precioTotal AS 'Costo Total'
FROM 
    pedido PE,
    proveedor PV,
    detalle_pedido DP,
    producto PR
WHERE 
    PE.idProveedor = PV.idProveedor
    AND PE.idPedido = DP.idPedido
    AND DP.idProducto = PR.idProducto;

-- Consultar Historial de Movimientos de Stock
SELECT 
    HI.fecha AS 'Fecha Movimiento',
    PR.descripcion AS 'Producto',
    HI.cantidad AS 'Cantidad',
    HI.tipoMovimiento AS 'Tipo de Movimiento'
FROM 
    historial HI,
    producto PR
WHERE 
    HI.idProducto = PR.idProducto
ORDER BY 
    HI.fecha DESC;

-- Eliminar una Venta Específica
-- Paso 1: Eliminar el detalle de los productos asociados a la venta
DELETE DV 
FROM detalle_venta DV
WHERE DV.idVenta = 2;
-- Paso 2: Eliminar la venta principal
DELETE VE 
FROM venta VE
WHERE VE.idVenta = 2;
-- Comprobacion de la eliminación de la Venta (idVenta = 2)
SELECT 
    VE.idVenta AS 'ID Venta',
    VE.fecha AS 'Fecha Venta',
    DV.idProducto AS 'ID Producto',
    DV.cantidad AS 'Cantidad'
FROM 
    venta VE
LEFT JOIN 
    detalle_venta DV ON VE.idVenta = DV.idVenta
WHERE 
    VE.idVenta = 2;

-- Borrado lógico de usuario
UPDATE usuario US
SET US.usuarioActivo = 0
WHERE US.idUsuario = 3;
-- Comprobar el estado del Usuario (Borrado Lógico)
SELECT 
    US.idUsuario AS 'ID Usuario',
    US.username AS 'Nombre de Usuario',
    US.usuarioActivo AS 'Estado Activo (1=Sí, 0=No)'
FROM 
    usuario US
WHERE 
    US.idUsuario = 3;