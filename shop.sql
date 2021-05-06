-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Май 06 2021 г., 14:36
-- Версия сервера: 10.3.22-MariaDB
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `shop`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cartOptionsTotalSum` ()  BEGIN
UPDATE cart_to_options CO SET
CO.sum_product = (SELECT P.price_prod FROM products P JOIN options_product OP ON OP.id_product = P.id_prod WHERE OP.id_options = CO.id_options)*CO.quantity;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `categoryProducts` (IN `nameCategoty` VARCHAR(30))  BEGIN
SELECT PC.id_product, P.name_prod 
FROM product_to_categories PC, categories C, products P
WHERE PC.id_category = C.id_category AND PC.id_product = P.id_prod AND C.name_category = nameCategoty;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Report` (IN `data_start` DATE, IN `data_end` DATE)  READS SQL DATA
BEGIN
SELECT O.date_order, O.id_customer, SUM(O.total_sum_order) AS Total_Sum_for_Period
FROM orders O
WHERE 
	O.date_order>=data_start AND O.date_order<=data_end
GROUP BY O.date_order WITH ROLLUP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sumOrders` ()  BEGIN
UPDATE orders O SET
O.total_sum_order = (SELECT SUM(OD.total_sum) FROM order_details OD WHERE OD.id_order = O.id_order);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sumTotalCart` ()  BEGIN
UPDATE cart C SET
C.total_sum = (SELECT SUM(CO.sum_product) FROM cart_to_options CO WHERE C.id_cart = CO.id_cart);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOrderDetails` ()  BEGIN
UPDATE order_details OD SET
OD.price_prod = (SELECT P.price_prod FROM products P WHERE P.id_prod = OD.id_product);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `cart`
--

CREATE TABLE `cart` (
  `id_cart` int(11) NOT NULL,
  `id_customer` int(11) NOT NULL,
  `total_sum` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `cart`
--

INSERT INTO `cart` (`id_cart`, `id_customer`, `total_sum`) VALUES
(1, 2, '2905.40'),
(2, 3, '1323.90'),
(3, 1, '2294.40');

-- --------------------------------------------------------

--
-- Структура таблицы `cart_to_options`
--

CREATE TABLE `cart_to_options` (
  `id_cart` int(11) NOT NULL,
  `id_options` int(11) NOT NULL,
  `quantity` int(100) NOT NULL,
  `sum_product` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `cart_to_options`
--

INSERT INTO `cart_to_options` (`id_cart`, `id_options`, `quantity`, `sum_product`) VALUES
(1, 2, 2, '400.40'),
(1, 1, 10, '2505.00'),
(2, 5, 3, '572.40'),
(2, 4, 3, '751.50'),
(3, 2, 3, '600.60'),
(3, 5, 1, '190.80'),
(3, 4, 6, '1503.00');

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id_category` int(10) NOT NULL,
  `name_category` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id_category`, `name_category`) VALUES
(1, 'Авто, мото'),
(2, 'Айтишникам'),
(3, 'Интернет приколы'),
(4, 'Музыка'),
(5, 'Праздники');

-- --------------------------------------------------------

--
-- Структура таблицы `city`
--

CREATE TABLE `city` (
  `id_city` int(10) NOT NULL,
  `name_city` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `city`
--

INSERT INTO `city` (`id_city`, `name_city`) VALUES
(1, 'Nikolaev'),
(2, 'Kiev'),
(3, 'Chernigov'),
(4, 'Kherson'),
(5, 'Odessa'),
(6, 'Melitopol');

-- --------------------------------------------------------

--
-- Структура таблицы `color`
--

CREATE TABLE `color` (
  `id_color` int(10) NOT NULL,
  `name_color` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `color`
--

INSERT INTO `color` (`id_color`, `name_color`) VALUES
(1, 'белый'),
(2, 'черный'),
(3, 'зеленый'),
(4, 'красный'),
(5, 'серый'),
(6, 'синий'),
(7, 'желтый');

-- --------------------------------------------------------

--
-- Структура таблицы `customers`
--

CREATE TABLE `customers` (
  `id_customer` int(10) NOT NULL,
  `name_surname_customer` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `email_customer` varchar(30) COLLATE utf8mb4_bin NOT NULL,
  `phone_customer` varchar(15) COLLATE utf8mb4_bin NOT NULL,
  `country_customer` varchar(10) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Ukraine',
  `id_city` int(11) NOT NULL,
  `region` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `address` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `index_address` int(10) DEFAULT NULL,
  `branch_NP` int(10) DEFAULT NULL,
  `login` varchar(20) COLLATE utf8mb4_bin NOT NULL,
  `password` varchar(20) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `customers`
--

INSERT INTO `customers` (`id_customer`, `name_surname_customer`, `email_customer`, `phone_customer`, `country_customer`, `id_city`, `region`, `address`, `index_address`, `branch_NP`, `login`, `password`) VALUES
(1, 'Ivan Ivanov', 'ivan@ukr.net', '+30981234567', 'Ukraine', 2, NULL, 'Sovetskaya', 50124, 2, 'ivan123', '123456'),
(2, 'Galina Petrova', 'galina@gmail.com', '+30981234567', 'Ukraine', 6, NULL, 'Petrova', 54217, 23, 'gal153', '7854'),
(3, 'Vladimir Pushkin', 'pushkin@gmail.com', '+380501452536', 'Ukraine', 1, 'Nikolaevskaya', 'Lenina', 54041, 18, 'puskin789', '654789');

-- --------------------------------------------------------

--
-- Структура таблицы `deliveries`
--

CREATE TABLE `deliveries` (
  `id_delivery` int(10) NOT NULL,
  `name_delivery` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `price_delivery` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `deliveries`
--

INSERT INTO `deliveries` (`id_delivery`, `name_delivery`, `price_delivery`) VALUES
(1, 'Новая Почта (На склад в Вашем городе (Украина))', '43.00'),
(2, 'Новая Почта(Курьером по адресу (Украина))', '60.00'),
(3, 'Укрпочта экспресс', '32.00');

-- --------------------------------------------------------

--
-- Структура таблицы `options_product`
--

CREATE TABLE `options_product` (
  `id_options` int(11) NOT NULL,
  `id_product` int(11) NOT NULL,
  `id_type` int(11) NOT NULL,
  `id_color` int(11) NOT NULL,
  `id_size` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `options_product`
--

INSERT INTO `options_product` (`id_options`, `id_product`, `id_type`, `id_color`, `id_size`) VALUES
(1, 1, 2, 3, 1),
(2, 2, 2, 3, 2),
(3, 3, 5, 7, 3),
(4, 5, 6, 4, 3),
(5, 6, 3, 1, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id_order` int(10) NOT NULL,
  `date_order` date NOT NULL,
  `id_customer` int(10) NOT NULL,
  `total_sum_order` decimal(10,2) NOT NULL,
  `id_payment` int(11) NOT NULL,
  `id_delivery` int(11) NOT NULL,
  `status` bit(1) DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`id_order`, `date_order`, `id_customer`, `total_sum_order`, `id_payment`, `id_delivery`, `status`) VALUES
(1, '2021-04-27', 1, '501.00', 1, 1, b'0'),
(2, '2021-04-29', 2, '5059.00', 3, 1, b'0');

-- --------------------------------------------------------

--
-- Структура таблицы `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `id_order` int(11) NOT NULL,
  `id_options` int(11) NOT NULL,
  `id_product` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_prod` decimal(10,2) DEFAULT NULL,
  `total_sum` decimal(10,2) GENERATED ALWAYS AS (`quantity` * `price_prod`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `order_details`
--

INSERT INTO `order_details` (`id`, `id_order`, `id_options`, `id_product`, `quantity`, `price_prod`) VALUES
(1, 1, 1, 1, 2, '250.50'),
(2, 2, 2, 2, 5, '200.20'),
(3, 2, 1, 1, 10, '250.50'),
(4, 2, 3, 3, 5, '310.60');

-- --------------------------------------------------------

--
-- Структура таблицы `payment`
--

CREATE TABLE `payment` (
  `id_ payment` int(10) NOT NULL,
  `name_payment` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `payment`
--

INSERT INTO `payment` (`id_ payment`, `name_payment`) VALUES
(1, 'Картой VISA, MasterCard, Maestro'),
(2, 'LiqPay Приват24'),
(3, 'Оплата в кассе любого банка Украины (счет-фактура)');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `id_prod` int(10) NOT NULL,
  `name_prod` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `price_prod` decimal(10,2) NOT NULL,
  `description_product` text COLLATE utf8mb4_bin NOT NULL,
  `id_structure` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`id_prod`, `name_prod`, `price_prod`, `description_product`, `id_structure`) VALUES
(1, 'Хенли', '250.50', 'Основное отличие хенли – это пуговицы на вороте. Шьются такие модели t-shirt из мягких хлопковых тканей, зачастую имеют длинный рукав. Дизайнеры дают следующие рекомендации относительно преимуществ мужских хенли', 1),
(2, 'Борцовка', '200.20', 'От классической майки отличается специальным кроем на спине. Лямки сужаются, образуя вырез, открывают лопатки и плечи. Борцовка является элементом спортивного образа, но также может использоваться для создания луков в стиле casual.', 2),
(3, 'Поло', '310.60', 'вляются классической моделью, имеющей на горловине воротничок с пуговицами. Футболка поло часто используется в деловом стиле, а также в образах яхтсменов и членов элитных гольф клубов. Отлично сочетаются с разными версиями мужских брюк, джинсов, шортов. Находятся вне моды и поэтому не теряют актуальности. Модные луки, в которых используются поло', 3),
(4, 'Джемпер', '240.20', 'Это версия классической футболки из тонкого текстиля, имеющей округлый вырез и длинный рукав. Джемпер подходит для демисезонного гардероба, а также может спасать в холодные летние вечера. Универсальность такого элемента одежды позволяет легко создавать стильные образы в комбинации с джинсами, спортивными штанами, брюками разных фасонов (кроме классики).', 1),
(5, 'Классическая футболка', '250.50', 'Классическая футболка прямого фасона отличается приятной мягкостью и обладает хорошей плотностью. Свободный крой и отсутствие боковых швов дают ощущение комфорта не стесняя движений. Благодаря использованию экологически чистого хлопка, ткань является гипоаллергенной и обладает высокой степенью гигроскопичности. Материал отличается долговечностью и цветоустойчивостью.', 3),
(6, 'Боди', '190.80', 'Такие виды футболок для девушек отличаются наличием нижней части как у сдельного купальника, только на застежках – липучки, крючки, кнопки. Верх может быть выполнен в виде майки, классической футболки, лонгслива.', 2),
(7, 'Спортивная', '320.80', 'Название говорит о прямом назначении одежды. В основном спортивные футболки имеют классический фасон с прямым кроем, округлым или треугольным вырезом. Шьются из гипоаллергенного, дышащего текстиля. Обеспечивают максимальный комфорт во время тренировки.', 1),
(8, 'Круглый вырез', '200.00', 'Такой тип горловины позволяет носить футболку под разные виды верхней одежды, создавая модные многослойные луки. При круглом вырезе крой остается прямым, свободным или приталенным. С таким фасоном мужчина выглядит солидно и одновременно просто, может с успехом носить пиджак или кожаную косуху.', 2),
(9, 'V-образный-вырез', '250.00', 'Это достаточно практичные и универсальные виды мужских футболок, которые прекрасно подходят для образа в стиле кэжуал, отличаются по глубине выреза. Небольшой вырез в виде треугольника на горловине придаст строгости и элегантности. Если же выбрать вырез поглубже, то такая модель поможет создать модный и сексуальный лук для прогулки, вечеринки, романтического свидания.', 3),
(10, 'Футболка цветной рукав', '210.00', 'Футболка эргономичного кроя с круглым воротом и короткими рукавами реглан. Благодаря использованию натурального хлопка, ткань обладает прекрасной гигроскопичностью и не вызывает аллергических реакций. Мягкий материал не скатывается и не деформируется при стирке.', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `product_to_categories`
--

CREATE TABLE `product_to_categories` (
  `id_product` int(11) NOT NULL,
  `id_category` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `product_to_categories`
--

INSERT INTO `product_to_categories` (`id_product`, `id_category`) VALUES
(1, 2),
(1, 5),
(2, 3),
(2, 1),
(3, 2),
(3, 4),
(6, 1),
(8, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `sizes`
--

CREATE TABLE `sizes` (
  `id_size` int(10) NOT NULL,
  `name_size` varchar(10) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `sizes`
--

INSERT INTO `sizes` (`id_size`, `name_size`) VALUES
(1, 'S'),
(2, 'M'),
(3, 'L'),
(4, 'XL');

-- --------------------------------------------------------

--
-- Структура таблицы `structure`
--

CREATE TABLE `structure` (
  `id_structure` int(10) NOT NULL,
  `name_structure` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `structure`
--

INSERT INTO `structure` (`id_structure`, `name_structure`) VALUES
(1, 'хлопок 100%'),
(2, 'хлопок 90%, полиэстер 10%'),
(3, 'хлопок 95%, вискоза 5% 	');

-- --------------------------------------------------------

--
-- Структура таблицы `type`
--

CREATE TABLE `type` (
  `id_type` int(10) NOT NULL,
  `name_type` varchar(100) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Дамп данных таблицы `type`
--

INSERT INTO `type` (`id_type`, `name_type`) VALUES
(1, 'Мужская'),
(2, 'Унисекс'),
(3, 'Женская'),
(4, 'Детская'),
(5, 'Длинный рукав'),
(6, 'Ringer');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id_cart`),
  ADD KEY `id_customer` (`id_customer`);

--
-- Индексы таблицы `cart_to_options`
--
ALTER TABLE `cart_to_options`
  ADD KEY `id_cart` (`id_cart`),
  ADD KEY `id_options` (`id_options`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id_category`);

--
-- Индексы таблицы `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`id_city`);

--
-- Индексы таблицы `color`
--
ALTER TABLE `color`
  ADD PRIMARY KEY (`id_color`);

--
-- Индексы таблицы `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id_customer`),
  ADD KEY `id_city` (`id_city`);

--
-- Индексы таблицы `deliveries`
--
ALTER TABLE `deliveries`
  ADD PRIMARY KEY (`id_delivery`);

--
-- Индексы таблицы `options_product`
--
ALTER TABLE `options_product`
  ADD PRIMARY KEY (`id_options`),
  ADD KEY `id_product` (`id_product`),
  ADD KEY `id_type` (`id_type`),
  ADD KEY `id_color` (`id_color`),
  ADD KEY `id_size` (`id_size`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id_order`),
  ADD KEY `id_payment` (`id_payment`),
  ADD KEY `id_delivery` (`id_delivery`);

--
-- Индексы таблицы `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_options` (`id_options`),
  ADD KEY `id_order` (`id_order`),
  ADD KEY `id_product` (`id_product`);

--
-- Индексы таблицы `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id_ payment`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id_prod`),
  ADD KEY `id_structure` (`id_structure`),
  ADD KEY `price_prod` (`price_prod`);

--
-- Индексы таблицы `product_to_categories`
--
ALTER TABLE `product_to_categories`
  ADD KEY `id_product` (`id_product`),
  ADD KEY `id_category` (`id_category`);

--
-- Индексы таблицы `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`id_size`);

--
-- Индексы таблицы `structure`
--
ALTER TABLE `structure`
  ADD PRIMARY KEY (`id_structure`);

--
-- Индексы таблицы `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`id_type`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cart`
--
ALTER TABLE `cart`
  MODIFY `id_cart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id_category` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `city`
--
ALTER TABLE `city`
  MODIFY `id_city` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `color`
--
ALTER TABLE `color`
  MODIFY `id_color` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `customers`
--
ALTER TABLE `customers`
  MODIFY `id_customer` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `deliveries`
--
ALTER TABLE `deliveries`
  MODIFY `id_delivery` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `options_product`
--
ALTER TABLE `options_product`
  MODIFY `id_options` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id_order` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `payment`
--
ALTER TABLE `payment`
  MODIFY `id_ payment` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `id_prod` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `sizes`
--
ALTER TABLE `sizes`
  MODIFY `id_size` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `structure`
--
ALTER TABLE `structure`
  MODIFY `id_structure` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `type`
--
ALTER TABLE `type`
  MODIFY `id_type` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customers` (`id_customer`);

--
-- Ограничения внешнего ключа таблицы `cart_to_options`
--
ALTER TABLE `cart_to_options`
  ADD CONSTRAINT `cart_to_options_ibfk_1` FOREIGN KEY (`id_cart`) REFERENCES `cart` (`id_cart`),
  ADD CONSTRAINT `cart_to_options_ibfk_2` FOREIGN KEY (`id_options`) REFERENCES `options_product` (`id_options`);

--
-- Ограничения внешнего ключа таблицы `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_ibfk_2` FOREIGN KEY (`id_city`) REFERENCES `city` (`id_city`);

--
-- Ограничения внешнего ключа таблицы `options_product`
--
ALTER TABLE `options_product`
  ADD CONSTRAINT `options_product_ibfk_1` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_prod`),
  ADD CONSTRAINT `options_product_ibfk_2` FOREIGN KEY (`id_type`) REFERENCES `type` (`id_type`),
  ADD CONSTRAINT `options_product_ibfk_3` FOREIGN KEY (`id_color`) REFERENCES `color` (`id_color`),
  ADD CONSTRAINT `options_product_ibfk_4` FOREIGN KEY (`id_size`) REFERENCES `sizes` (`id_size`);

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`id_payment`) REFERENCES `payment` (`id_ payment`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`id_delivery`) REFERENCES `deliveries` (`id_delivery`);

--
-- Ограничения внешнего ключа таблицы `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`id_options`) REFERENCES `options_product` (`id_options`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`id_order`) REFERENCES `orders` (`id_order`),
  ADD CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_prod`);

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`id_structure`) REFERENCES `structure` (`id_structure`);

--
-- Ограничения внешнего ключа таблицы `product_to_categories`
--
ALTER TABLE `product_to_categories`
  ADD CONSTRAINT `product_to_categories_ibfk_1` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_prod`),
  ADD CONSTRAINT `product_to_categories_ibfk_2` FOREIGN KEY (`id_category`) REFERENCES `categories` (`id_category`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
