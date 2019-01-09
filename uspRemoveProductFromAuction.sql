CREATE PROCEDURE uspRemoveProductFromAuction (
	--@AuctionID int
	@ProductID int
) AS
DECLARE @IsActive bit
SELECT @IsActive = currentbidactive
FROM Auction.AuctionedProducts 
WHERE productid = @ProductID
--WHERE AuctionID = @AuctionID

IF @IsActive = 1
BEGIN
	UPDATE Auction.AuctionedProducts
	SET currentbidactive = 0,
	expiredate = getdate(),
	lastupdated = getdate(),
    status = 'Canceled'
	WHERE productid = @ProductID
	--WHERE AuctionID = @AuctionID
	PRINT 'Product id successfully deactivated.'
END
ELSE IF @IsActive = 0
BEGIN
	PRINT 'Product id already deactivated.'
END
ELSE
BEGIN
	PRINT 'Product id not found.'
END

--EXEC uspRemoveProductFromAuction 515;
--EXEC uspRemoveProductFromAuction 515;
--EXEC uspRemoveProductFromAuction 9999;