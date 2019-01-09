DROP TABLE IF EXISTS Auction.AuctionedProductsBidHistory
CREATE TABLE Auction.AuctionedProductsBidHistory (
	auctionid int identity(0,1) PRIMARY KEY,
	auctionbidnumber int,
	productid int,
	customerid int,
	bid decimal(10,2),
	ts datetime
	primary key (auctionid, auctionbidnumber)
);