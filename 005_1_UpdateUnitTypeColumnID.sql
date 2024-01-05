/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014                    */
/* Created on:     24.08.2023 21:28:33                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.Orders') and o.name = 'Orders_fk1')
alter table dbo.Orders
   drop constraint Orders_fk1
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.Products') and o.name = 'Products_fk0')
alter table dbo.Products
   drop constraint Products_fk0
go

alter table dbo.Products
   drop constraint PK_PRODUCTS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.tmp_Products')
            and   type = 'U')
   drop table dbo.tmp_Products
go

execute sp_rename Products, tmp_Products
go

/*==============================================================*/
/* Table: Products                                              */
/*==============================================================*/
create table dbo.Products (
   ID                   bigint               not null,
   Name                 nvarchar(30)         collate Cyrillic_General_CI_AS not null,
   UnitID               tinyint              not null,
   Price                money                not null,
   constraint PK_PRODUCTS primary key (ID)
         on "PRIMARY"
)
on "PRIMARY"
go

insert into dbo.Products (ID, Name, UnitID, Price)
select ID, Name, UnitID, Price
from dbo.tmp_Products
go

alter table dbo.Orders
   add constraint Orders_fk1 foreign key (ProductID)
      references dbo.Products (ID)
         on update cascade
go

alter table dbo.Products
   add constraint Products_fk0 foreign key (UnitID)
      references dbo.Units (ID)
         on update cascade
go

