CREATE PROCEDURE uspListBidPurchaseHistory (
	@CustomerID int, 
	@StartTime datetime, 
	@EndTime datetime
) AS

select * 
from Auction.AuctionedProducts
where customerid = @CustomerID
and currentbidactive = 0
and lastupdated between @StartTime and @EndTime
and status in ('Pending Payment','Shipping','Shipped','Delivered')