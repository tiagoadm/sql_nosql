CREATE PROCEDURE [dbo].[uspAddProductToAuction](
	@ProductID int,
	@ExpireDate datetime = null, 
	@InitialBidPrice decimal(10,2) = null
) AS
DECLARE @EligibleProducts int = 0,
		@AuctionedProducts int = 0,
		@AuctionID int = 1

SELECT TOP 1 @EligibleProducts=1
from Auction.EligibleProducts
WHERE productid = @ProductID

SELECT @AuctionID = max(auctionid)+1
FROM Auction.AuctionedProducts

IF @AuctionID IS NULL
BEGIN
	SET @AuctionID = 1
END

BEGIN
   IF @EligibleProducts = 1
   BEGIN
		BEGIN TRY
		INSERT INTO Auction.AuctionedProducts
		SELECT @AuctionID
				,@ProductID
				,0
				,coalesce(@InitialBidPrice,initialbid)
				,maxbidlimit
				,bidincrease
				,coalesce(@InitialBidPrice,initialbid)
				,getdate()
				,coalesce(@ExpireDate,DATEADD(day,7,getdate()))
				,getdate()
				,1
				,null
		from Auction.EligibleProducts
		WHERE productid = @ProductID
		END TRY
		BEGIN CATCH
			THROW 50000, 'An error has occured while trying to insert the record in the AuctionedProducts table.', 1;  
		END CATCH
		BEGIN TRY
		INSERT INTO Auction.AuctionedProductsBidHistory
		SELECT  auctionid
				,1
				,productid
				,0
				,currentbid
				,lastUpdated
		FROM Auction.AuctionedProducts
		WHERE auctionid = @AuctionID
        PRINT 'Product auctioned.'
		END TRY
		BEGIN CATCH
			THROW 50000, 'An error has occured while trying to insert the record in the AuctionedProductsBidHistory table.', 1;  
		END CATCH
		BEGIN TRY
		UPDATE Production.productinventory
		SET Quantity = Quantity-1
		WHERE productid = @ProductID
		END TRY
		BEGIN CATCH
			THROW 50000, 'An error has occured while updating a record in the productinventory table.', 1;  
		END CATCH
	END
	ELSE IF @EligibleProducts = 0
	PRINT 'This product id is not auctionable.'
END

--EXEC [dbo].[uspAddProductToAuction] 515;
--EXEC [dbo].[uspAddProductToAuction] 515;
--EXEC [dbo].[uspAddProductToAuction] 59915;