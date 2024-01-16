--funcionou
SELECT *
FROM "ecommerce"."pedidos_part" 
where data_pedido = cast(date_parse('2024-01-01','%Y-%m-%d') as date)
limit 10;

SELECT *
FROM "ecommerce"."pedidos_part" 
where data_pedido = date_parse('2024-01-01', '%Y-%m-%d')
limit 10;

SELECT *
FROM "ecommerce"."pedidos_part" 
where year(data_pedido) = 2024
limit 10;

SELECT data_pedido, count(1) qtt
FROM "ecommerce"."pedidos_part" 
GROUP BY data_pedido;

SELECT COUNT(1) qtt
FROM "ecommerce"."pedidos_part" 
WHERE DAY(data_pedido) = 01;

SELECT *
FROM "ecommerce"."pedidos_part" 
WHERE data_pedido = cast(date_parse('2024-01-01','%Y-%m-%d') as DATE)
AND cast(date_parse(data_criacao,'%Y-%m-%dT%H:%i:%s') as DATE ) = date_parse('2024-01-01','%Y-%m-%d') 
limit 10;

SELECT *
FROM "ecommerce"."pedidos_part" 
WHERE data_pedido = cast(date_parse('2024-01-01','%Y-%m-%d') as DATE)
AND date_parse(data_criacao,'%Y-%m-%dT%H:%i:%s') = date_parse('2024-01-01T15:44:46','%Y-%m-%dT%H:%i:%s') 
limit 10;

SELECT date_parse(p.data_criacao,'%Y-%m-%dT%H:%i:%s') data_criacao_parsed, p.*
FROM "ecommerce"."pedidos_part" p
WHERE p.data_pedido = cast(date_parse('2024-01-01','%Y-%m-%d') as DATE)
AND date_parse(p.data_criacao,'%Y-%m-%dT%H:%i:%s') = date_parse('2024-01-01T15:44:46','%Y-%m-%dT%H:%i:%s') 
LIMIT 10;
