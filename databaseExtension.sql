DROP TABLE IF EXISTS Auction.AuctionedProductsBidHistory
CREATE TABLE Auction.AuctionedProductsBidHistory (
	productid int,
	productbidnumber int,
	customerid int,
	bid decimal(10,2),
	ts datetime
	primary key (productid, productbidnumber)
);

DROP TABLE IF EXISTS Auction.AuctionedProducts;
CREATE TABLE Auction.AuctionedProducts (
	productid int PRIMARY KEY,
	customerid int,
	initialbidprice decimal(10,2),
	maxbidprice decimal(10,2),
	defaultbidincrease decimal(10,2),
	currentbid decimal(10,2),
	startdate datetime,
	expiredate datetime,
	lastUpdated datetime,
	currentbidactive bit,
	status varchar(50)
);

CREATE VIEW Auction.EligibleProducts AS 
with pv as (
select productid, sum(quantity) quantity
from production.productinventory
group by productid
having sum(quantity) > 2)

select p.productId,
case 
when makeflag=0 or pc.name='Components' then 0.75
else 0.25
end * listprice initialbid,
0.02 bidincrease,
listprice maxbidlimit
from production.product p
left outer join production.ProductCategory pc
on p.productsubcategoryid = pc.productcategoryid
inner join pv 
on p.productid = pv.productid
where (pc.name != 'Accessories' or pc.name is null)
and sellenddate is null
and DiscontinuedDate is null
and listprice >= 50
order by 1