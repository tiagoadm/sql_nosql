DROP TABLE IF EXISTS Auction.AuctionedProducts;
CREATE TABLE Auction.AuctionedProducts (
	auctionid int PRIMARY KEY,
	productid int,
	customerid int,
	initialbidprice decimal(10,2),
	maxbidprice decimal(10,2),
	defaultbidincrease decimal(10,2),
	currentbid decimal(10,2),
	startdate datetime,
	expiredate datetime,
	lastupdated datetime,
	currentbidactive bit,
	status varchar(50)
);