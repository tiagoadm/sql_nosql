CREATE PROCEDURE uspSearchForAuctionBasedOnProductName (
	@Productname varchar(50), 
	@StartingOffSet varchar(4) = null, 
	@NumberOfRows varchar(4) = null
) AS

DECLARE @query nvarchar(2000)
SET @query = N'SELECT count(1) over () TotalCount, p.*, ap.*
	FROM [Production].[Product] p 
	INNER JOIN [Auction].[AuctionedProducts] ap
	ON p.ProductID = ap.productid
	WHERE Name LIKE ''%'+@Productname+'%''
	AND currentbidactive = 1
	ORDER BY Name '

IF @StartingOffSet is not null
SET @query +=N'OFFSET '+@StartingOffSet+' ROWS '

IF @NumberOfRows is not null
SET @query +=N'FETCH NEXT '+@NumberOfRows+' ROWS ONLY '
EXECUTE sp_executesql @query