/*Considerando DATA_PEDIDO=STRING e DATA_CRIACAO=STRING*/
SELECT *
FROM "ecommerce"."pedidos_part" 
WHERE date_parse(data_pedido,'%Y-%m-%d') = date_parse('2024-01-01','%Y-%m-%d') 
AND cast(date_parse(data_criacao,'%Y-%m-%dT%H:%i:%s') as DATE ) = date_parse('2024-01-01','%Y-%m-%d') 
limit 10;

/*Considerando DATA_PEDIDO=DATE e DATA_CRIACAO=STRING*/
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


/*ADICIONANDO PARTIÇÕES*/
SELECT * FROM "AwsDataCatalog"."ecommerce"."pedidos_part" limit 10;

MSCK REPAIR TABLE ecommerce.pedidos_part;

SHOW partitions ecommerce.pedidos_part;

ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-01') location 's3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/part/' ;

ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-02') location 's3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/part/' ;

ALTER TABLE ecommerce.pedidos_part ADD PARTITION (data_pedido='2024-01-03') location 's3://lab-data-eng-202402-p4004/raw/ecommerce/pedidos/part/' ;
