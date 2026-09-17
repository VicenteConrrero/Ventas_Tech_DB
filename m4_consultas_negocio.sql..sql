USE Ventas_Tech_DB;

select * 
from ventas;
/*
----------------------------------------------------------------------
Resumen ejecutivo mensual
---------------------------------------------------------------------
*/


Select  
MONTH(fecha_venta) as Mes,
count(id_venta) as Cantidad_Pedidos,
sum(cantidad * precio_unitario) as Total_Facturado,
round(sum(cantidad * precio_unitario) / count(id_venta), 2) as Ticket_Promedio
from ventas
group by month(fecha_venta);

/*
---------------------------------------------
 Ranking de productos
 --------------------------------------------
 */

select top 5
id_producto as id_producto,
sum(cantidad) as unidades_vendidas,
sum(cantidad * precio_unitario) as total_facturado
from ventas
group by id_producto
order by total_facturado desc;

/*
---------------------------------------------
 Clientes recurrentes
 --------------------------------------------
 */

select 
id_cliente as id_cliente,
count(*) as cantidad_pedidos,
sum(cantidad * precio_unitario) as total_gastado
from ventas
group by id_cliente
having count(*) > 1
order by cantidad_pedidos desc;

/*
---------------------------------------------
Meses por encima/por debajo del promedio 
-------------------------------------------
*/

with facturacionMensual as(select
month(fecha_venta) as Mes,
Sum(cantidad * precio_unitario) as Total_facturado
from ventas
group by month(fecha_venta))
select mes, total_facturado,
case
when total_facturado > (select avg(total_facturado)
from facturacionMensual)
then 'por encima'
else 'por debajo'
end as estado_promedio
from facturacionMensual
order by mes asc;


/*
------------------------------------------------------------------------------
HALLAZGOS CLAVE DEL ANÁLISIS DE DATOS
------------------------------------------------------------------------------

1. Concentración de Facturación en Producto Top:
   El producto con id_producto = 1 ('Laptop Pro 15') genera $3,600.00 sobre un 
   total facturado de $6,444.00, lo que representa el 55.86% de los ingresos 
   totales del mes con solo 3 unidades vendidas.

2. Alta Retención de Clientes:
   El 100% de la base de clientes registrados (los 5 clientes) es recurrente, 
   habiendo realizado exactamente 2 compras cada uno dentro del periodo analizado.

3. Disparidad entre Volumen y Facturación:
   El producto con id_producto = 2 ('Mouse Inalámbrico') lidera en volumen de 
   ventas con 13 unidades vendidas, pero aporta solo $364.00 (5.65% de los ingresos 
   totales), evidenciando que las ventas están fuertemente impulsadas por productos 
   de alto valor unitario.
*/


