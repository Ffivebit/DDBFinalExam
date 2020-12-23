CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `clientview` AS SELECT 
client.id_client AS ID_Client,
client.firstName AS First_Name,
client.lastName AS Last_Name,
SUM(paketprice.price) AS Packet_Price_Sum,
SUM(packet.id_packet) AS SumOfPacket
FROM client
JOIN packet ON client.id_client = packet.Fk_client
JOIN paketprice ON packet.Fk_price_packet = paketprice.id_paket_Price 
GROUP BY 
client.id_client ;

-- --VIEW------------------------------------


CREATE TRIGGER `trigger1` AFTER INSERT ON `packet` FOR EACH ROW BEGIN
DECLARE gg VARCHAR(255);
SELECT
 price INTO gg
FROM packet
INNER JOIN 
paketprice
ON packet.Fk_price_packet = paketprice.id_paket_Price
WHERE packet.id_packet = NEW.id_packet;
INSERT INTO stat
SET stat.Desc_STAT = CONCAT('Inserted packet with ID = ',NEW.id_packet,'and price in: ',gg),
	DATE_STAT = NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- --Trigger---------------------------------------


CREATE PROCEDURE `procedure1`(
	IN `packet_id` INT
)
BEGIN
SELECT packet.id_packet,delivery.id_status,Status_delivery.`status`s
FROM delivery
INNER JOIN packet
ON delivery.id_packet = packet.id_packet
INNER JOIN Status_delivery 
ON delivery.id_status = status_delivery.Id_status
WHERE packet.id_packet = packet_id;
END//
DELIMITER ;



CALL `procedure1`('1')
-- --Procedure-------------------------------------