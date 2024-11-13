-- MySQL Workbench Synchronization
-- Generated: 2024-11-13 19:08
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: evabe

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `clientes` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `clientes`.`clientes` (
  `id_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefono` INT(11) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `idclientes_UNIQUE` (`id_cliente` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `clientes`.`pedidos` (
  `id_pedido` INT(11) NOT NULL AUTO_INCREMENT,
  `fechal` DATE NOT NULL,
  `total` INT(11) NOT NULL,
  `clientes_id_cliente` INT(11) NOT NULL,
  PRIMARY KEY (`id_pedido`, `clientes_id_cliente`),
  UNIQUE INDEX `id_pedido_UNIQUE` (`id_pedido` ASC) VISIBLE,
  INDEX `fk_pedidos_clientes_idx` (`clientes_id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_clientes`
    FOREIGN KEY (`clientes_id_cliente`)
    REFERENCES `clientes`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- insertar personas
INSERT INTO clientes(nombre, direccion, telefono)
VALUES ('Rosa Diaz', 'calle falsa 1', '2345678'),
       ('Juan Gomez', 'calle 123', '12343222'),
       ('Maria Campos', 'calle 52', '6647566'),
       ('Ana Acosta', 'calle 6', '9345654'),
       ('Ramon Buelbe', 'calle 133', '983298');
       
-- insertar pedidos
INSERT INTO pedidos(fechal, total, clientes_id_cliente)
VALUES ('2024-03-17', '1000', '1'),
       ('2024-01-12', '1200', '2'),
       ('2024-02-12', '1300', '3'),
       ('2024-04-17', '1100', '1'),
       ('2024-05-12', '1500', '4'),
       ('2024-06-12', '1300', '5'),
       ('2024-07-12', '1300', '5'),
       ('2024-08-17', '1100', '1'),
       ('2024-09-12', '1500', '4'),
       ('2024-10-12', '1300', '5');

       
	-- proyectar pedidos
     SELECT 
    c.id_cliente,
    c.nombre AS cliente_nombre,
    c.direccion,
    c.telefono,
    p.id_pedido,
    p.fechal AS fecha_pedido,
    p.total AS total_pedido
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.id_cliente = p.clientes_id_cliente
ORDER BY 
    c.id_cliente, p.fechal;
    
-- proyectar los pedidos de un cliente especifico
SELECT 
    c.id_cliente,
    c.nombre AS cliente_nombre,
    c.direccion,
    c.telefono,
    p.id_pedido,
    p.fechal AS fecha_pedido,
    p.total AS total_pedido
FROM 
    clientes c
JOIN 
    pedidos p ON c.id_cliente = p.clientes_id_cliente
WHERE 
    c.id_cliente = 5
ORDER BY 
    p.fechal;
    
-- Calcular el total de todos los pedidos para cada cliente
SELECT 
    c.id_cliente,
    c.nombre AS cliente_nombre,
    SUM(p.total) AS total_pedidos
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.id_cliente = p.clientes_id_cliente
GROUP BY 
    c.id_cliente, c.nombre
ORDER BY 
    total_pedidos DESC;

-- alterar clave foranea para eliminacion en cascada
ALTER TABLE pedidos 
DROP FOREIGN KEY fk_pedidos_clientes;

SHOW CREATE TABLE pedidos;

ALTER TABLE pedidos DROP INDEX fk_pedidos_clientes_idx;

DELETE FROM pedidos WHERE clientes_id_cliente NOT IN (SELECT id_cliente FROM clientes);

SELECT * FROM clientes;

ALTER TABLE pedidos 
ADD CONSTRAINT fk_pedidos_clientes 
FOREIGN KEY (clientes_id_cliente)
REFERENCES clientes(id_cliente)
ON DELETE CASCADE;

-- clientes con mas pedidos
SELECT c.id_cliente, c.nombre, COUNT(p.id_pedido) AS total_pedidos 
FROM clientes c 
JOIN pedidos p ON c.id_cliente = p.clientes_id_cliente 
GROUP BY c.id_cliente 
ORDER BY total_pedidos 
DESC LIMIT 3;















       
       