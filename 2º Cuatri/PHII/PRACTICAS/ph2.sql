-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-03-2016 a las 17:52:39
-- Versión del servidor: 10.1.9-MariaDB
-- Versión de PHP: 5.6.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ph2`
--
CREATE DATABASE IF NOT EXISTS `ph2` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ph2`;

GRANT ALL PRIVILEGES ON ph2.* TO 'ph2'@127.0.0.1 IDENTIFIED BY 'ph2';
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentario`
--

DROP TABLE IF EXISTS `comentario`;
CREATE TABLE `comentario` (
  `ID` int(11) NOT NULL,
  `TITULO` varchar(50) NOT NULL,
  `TEXTO` text NOT NULL,
  `FECHAHORA` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID_VIAJE` int(11) NOT NULL,
  `LOGIN` varchar(20) NOT NULL COMMENT 'Autor del comentario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `comentario`
--

INSERT INTO `comentario` (`ID`, `TITULO`, `TEXTO`, `FECHAHORA`, `ID_VIAJE`, `LOGIN`) VALUES
(1, 'El idioma', '¿Con el inglés se puede mover uno por esa zona?', '2016-01-26 17:26:22', 2, 'usu2'),
(2, 'Re: El idioma', 'Claro que sí, casi todo el mundo lo habla allí.', '2016-01-27 09:43:15', 2, 'usu1'),
(3, 'El partido de Champions', '¿Qué precios tenían las entradas?', '2016-03-01 17:52:28', 1, 'usu3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `foto`
--

DROP TABLE IF EXISTS `foto`;
CREATE TABLE `foto` (
  `ID` int(11) NOT NULL,
  `DESCRIPCION` text NOT NULL,
  `FECHA` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `FICHERO` varchar(100) NOT NULL,
  `ID_VIAJE` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `foto`
--

INSERT INTO `foto` (`ID`, `DESCRIPCION`, `FECHA`, `FICHERO`, `ID_VIAJE`) VALUES
(1, 'Ayuntamiento de Hannover', '2016-02-22 10:07:14', '1.jpg', 2),
(2, 'Otra foto del ayuntamiento de Hannover', '2016-02-22 10:07:18', '2.jpg', 2),
(3, 'Otra foto más del ayuntamiento de Hannover', '2016-02-22 10:07:22', '3.jpg', 2),
(4, 'Foto del Santiago Bernabeu', '2016-02-09 23:00:00', '4.jpg', 1),
(5, 'Parque del Retiro', '2016-02-10 23:00:00', '5.jpg', 1),
(6, 'Foto nocturna del Big Ben', '2015-12-04 23:00:00', '6.jpg', 3),
(7, 'Foto del Támesis', '2015-12-05 23:00:00', '7.png', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `LOGIN` varchar(20) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL,
  `NOMBRE` varchar(50) NOT NULL,
  `EMAIL` varchar(100) NOT NULL,
  `CLAVE` varchar(35) NOT NULL,
  `FOTO` varchar(100) NOT NULL,
  `ULTIMO_ACCESO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora en la que se conectó'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`LOGIN`, `PASSWORD`, `NOMBRE`, `EMAIL`, `CLAVE`, `FOTO`, `ULTIMO_ACCESO`) VALUES
('usu1', 'usu1', 'Usuario 1', 'usuario1@phii.es', 'bc2eb2073ddb9db0df920d285395cc42', 'usu1.jpg', '2016-03-01 19:46:18'),
('usu2', 'usu2', 'Usuario 2', 'usuario2@phii.es', '', 'usu2.jpg', '2016-02-16 11:15:58'),
('usu3', 'usu3', 'Usuario 3', 'usu3@ph2.es', '90715d66aa715d56330372a3deb5fcd6', 'usu3.jpg', '2016-03-01 17:02:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `viaje`
--

DROP TABLE IF EXISTS `viaje`;
CREATE TABLE `viaje` (
  `ID` int(11) NOT NULL,
  `NOMBRE` varchar(200) NOT NULL,
  `DESCRIPCION` text NOT NULL COMMENT 'Descripción del viaje (recorrido, etc)',
  `FECHA_INICIO` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `FECHA_FIN` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `VALORACION` tinyint(6) NOT NULL,
  `LOGIN` varchar(20) NOT NULL COMMENT 'Usuario que dio de alta el viaje en la web'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `viaje`
--

INSERT INTO `viaje` (`ID`, `NOMBRE`, `DESCRIPCION`, `FECHA_INICIO`, `FECHA_FIN`, `VALORACION`, `LOGIN`) VALUES
(1, 'MADRID', 'Viaje a Madrid a ver el musical del Rey león', '2016-02-10 10:09:58', '2016-02-12 13:25:00', 3, 'usu1'),
(2, 'Baja Sajonia', 'Viaje por la baja Sajonia en Alemania. Hannover, una maravilla.', '2016-01-09 23:00:00', '2016-02-12 23:00:00', 4, 'usu1'),
(3, 'Londres', 'Viaje a Londres en el puente de la constitución para hacer las compras de Navidad. Vuelo directo desde Madrid.', '2015-12-03 23:00:00', '2015-12-07 23:00:00', 5, 'usu2');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `LOGIN` (`LOGIN`);

--
-- Indices de la tabla `foto`
--
ALTER TABLE `foto`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID_VIAJE` (`ID_VIAJE`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`LOGIN`);

--
-- Indices de la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `LOGIN` (`LOGIN`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comentario`
--
ALTER TABLE `comentario`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `foto`
--
ALTER TABLE `foto`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `viaje`
--
ALTER TABLE `viaje`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD CONSTRAINT `comentario_ibfk_1` FOREIGN KEY (`LOGIN`) REFERENCES `usuario` (`LOGIN`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `foto`
--
ALTER TABLE `foto`
  ADD CONSTRAINT `ID_VIAJE` FOREIGN KEY (`ID_VIAJE`) REFERENCES `viaje` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD CONSTRAINT `LOGIN` FOREIGN KEY (`LOGIN`) REFERENCES `usuario` (`LOGIN`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
