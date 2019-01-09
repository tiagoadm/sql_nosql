CREATE PROCEDURE uspTryBidProduct (
	--@AuctionID [int],
	@ProductID [int], 
	@CustomerID [int], 
	@BidAmount [int] = null
) AS

DECLARE @CustomerExists int = 0,
		@ProductIsAuctioned int = 0,
		@MaxBidLimit decimal(10,2) = 0,
		@NextBidNumber int = 1,
		@CurrentBid decimal(10,2) = null

SELECT TOP 1 @CustomerExists = 1
FROM Sales.Customer
WHERE CustomerID = @CustomerID

SELECT TOP 1 @ProductIsAuctioned = 1, 
	@MaxBidLimit = maxbidprice
FROM Auction.AuctionedProducts
WHERE ProductID = @ProductID
--WHERE AuctionID = @AuctionID
AND currentbidactive = 1

SELECT TOP 1 @NextBidNumber = MAX(productbidnumber)+1
FROM Auction.AuctionedProductsBidHistory
WHERE ProductID = @ProductID
--WHERE AuctionID = @AuctionID

SELECT TOP 1 @CurrentBid = currentbid
FROM Auction.AuctionedProducts
WHERE productid = @ProductID
--WHERE AuctionID = @AuctionID

BEGIN TRY
	IF @BidAmount > @MaxBidLimit
	BEGIN
		PRINT 'Bid amount over the price limit.'
	END
	ELSE IF @BidAmount <= @CurrentBid
	BEGIN
		PRINT 'Bid amount is less than current bid.'
	END
	ELSE IF @CustomerExists = 0
	BEGIN
		PRINT 'Customer ID does not exist.'
	END
	ELSE IF @ProductIsAuctioned = 0
	BEGIN
		PRINT 'Product is not being auctioned.'
	END
	ELSE IF @CustomerExists = 1 
		AND @ProductIsAuctioned = 1
	BEGIN
		UPDATE Auction.AuctionedProducts
		SET customerid = @CustomerID 
			currentbid = coalesce(@BidAmount,currentbid+defaultbidincrease),
			lastUpdated = getdate()
		WHERE productid = @ProductID
		--WHERE AuctionID = @AuctionID
		
		INSERT INTO Auction.AuctionedProductsBidHistory
		SELECT  productid,
				@NextBidNumber,
				@CustomerID,
				currentbid,
				lastUpdated
		FROM Auction.AuctionedProducts
		WHERE productid = @ProductID
		--WHERE AuctionID = @AuctionID
		
		PRINT 'Bid successfully placed.'
	END
END TRY
BEGIN CATCH
THROW 50000,'The bid was not placed because of an error.',1
END CATCH


--EXEC uspTryBidProduct 514,1;
--EXEC uspTryBidProduct 514,1;
--EXEC uspTryBidProduct 9999,1;
--EXEC uspTryBidProduct	514,9999;
--EXEC uspTryBidProduct 514,1,999999