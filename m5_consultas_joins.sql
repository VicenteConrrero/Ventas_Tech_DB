/*Combiná con INNER JOIN tu tabla de ventas con las tablas descriptivas que hayas modelado (clientes, productos y cualquier otra dimensión de tu caso 
de negocio) para obtener en una sola fila, como mínimo: fecha, identificación del cliente, descripción del producto, cantidad, precio unitario y total de venta.

Sumá además las columnas descriptivas que existan en tu propio esquema (por ejemplo segmento de cliente, categoría de producto o región, si las modelaste). 
No es necesario que estén todas: la consulta se evalúa sobre las tablas que vos diseñaste, no sobre una lista fija.

Si tu esquema no tiene ninguna dimensión geográfica ni de segmentación, agregala ahora al script del Módulo 3 con dos o tres registros de ejemplo. 
Esta consulta va a ser la fuente de datos principal en Power BI, así que conviene que tenga al menos una columna para agrupar y una para filtrar
*/

SELECT 
    V.id_venta, V.fecha_venta,
    C.id_cliente, C.nombre AS nombre_cliente, C.tipo_de_cliente,
    P.id_producto, P.nombre_producto,
    Ca.Nombre_categoria, Ca.descripcion AS descripcion_categoria,
    V.cantidad, V.Precio_unitario, V.cantidad * V.Precio_unitario AS Total_venta,
    T.Ciudad, T.Provincia, T.Region, T.Pais

FROM ventas V

INNER JOIN clientes C
    ON C.id_cliente = V.id_cliente

INNER JOIN productos P
    ON P.id_producto = V.id_producto

INNER JOIN categorias Ca
    ON Ca.id_categoria = P.id_categoria

INNER JOIN territorios T
    ON T.Id_territorio = V.Id_territorio;

/* Clientes sin ventas (LEFT JOIN) Identificá clientes registrados que aún no han realizado ninguna compra. 
Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.
*/

Select C.nombre, C.email, C.fecha_registro
from clientes C
Left join ventas V
On C. id_cliente = V. id_cliente
Where V.id_venta is null 



/*
Productos sin ventas (LEFT JOIN) Identificá productos del catálogo que no tienen ninguna venta registrada. 
Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.
*/

Select P.nombre_producto, C. Nombre_categoria as Categoria, P. precio
from productos P
Left join  ventas V
On P. id_producto = V. id_producto
Inner join categorias C
on P. id_categoria = C. id_categoria
Where V. id_producto is null

/*
Consolidado por canal (UNION ALL)

Importante: la columna canal no se consulta, se crea. No busques ese dato en tus tablas — 
lo generás vos dentro de cada SELECT como valor literal. Ese es el punto de este ejercicio.

Escribí dos SELECT sobre tus ventas, separados por el criterio que corresponda a tu caso 
(por ejemplo, ventas de dos períodos, dos sucursales o dos orígenes distintos), y agregá en cada uno una columna de texto fija que identifique el origen. 
Unilos con UNION ALL y agrupá ese resultado por origen para obtener el total de cada uno.
*/
select Canal, sum(Total_venta) as Total_ventas
from
(select V.cantidad * V.Precio_unitario as Total_venta, 'Periodo 1' as Canal
    from ventas V
    where V.fecha_venta between '2024-03-05' and '2024-03-10'
union all
select V.cantidad * V.Precio_unitario as Total_venta, 'Periodo 2' as Canal
    from ventas V
    where V.fecha_venta between '2024-03-11' and'2024-03-15') 
as Ventas_por_periodo
group by canal;
