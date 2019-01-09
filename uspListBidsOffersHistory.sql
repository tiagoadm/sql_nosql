CREATE PROCEDURE uspListBidsOffersHistory (
	@CustomerID int, 
	@StartTime datetime, 
	@EndTime datetime, 
	@Active bit = 1
) AS

SELECT *
FROM Auction.AuctionedProductsBidHistory h
INNER JOIN Auction.AuctionedProducts a on a.productid = h.productid
WHERE customerid = @CustomerID
and ts between @StartTime and @EndTime
AND currentbidactive in (1,@Active)