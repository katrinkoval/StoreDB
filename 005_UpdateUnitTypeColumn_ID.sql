/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014                    */
/* Created on:     24.08.2023 20:10:38                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.Products') and o.name = 'Products_fk0')
alter table dbo.Products
   drop constraint Products_fk0
go

alter table dbo.Units
   drop constraint PK_UNITS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.tmp_Units')
            and   type = 'U')
   drop table dbo.tmp_Units
go

execute sp_rename Units, tmp_Units
go

/*==============================================================*/
/* Table: Units                                                 */
/*==============================================================*/
create table dbo.Units (
   ID                   tinyint              not null,
   UnitType             nchar(22)            collate Cyrillic_General_CI_AS not null,
   constraint PK_UNITS primary key (ID)
         on "PRIMARY"
)
on "PRIMARY"
with (data_compression = none on partitions (1))
go

insert into dbo.Units (ID, UnitType)
select ID, UnitType
from dbo.tmp_Units
go

alter table dbo.Products
   add constraint Products_fk0 foreign key (UnitID)
      references dbo.Units (ID)
         on update cascade
go

