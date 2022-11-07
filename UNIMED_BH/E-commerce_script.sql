-- criação do banco de dados para o cenário de E-commerce 
-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- criar tabela cliente OK
create table clients(
		idClient int auto_increment primary key,
        CName varchar(45),               
        CPF char(11),
        CNPJ char(14),
        Address varchar(255),
        constraint unique_cpf_client unique (CPF),
        constraint unique_cnpj_client unique (CNPJ)
);

alter table clients auto_increment=1;

-- desc clients;
-- criar tabela produto OK

create table product(
		idProduct int auto_increment primary key,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        Pdescription varchar(255),
        price float default 0,
        size varchar(255) default null,
        avaliação float default 0        
);

alter table product auto_increment=1;

-- criar tabela pedido
-- drop table orders; OK
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum("Cancelado","Em andamento","Em processamento","Enviado","Entregue") default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10, 
    constraint fk_ordes_client foreign key (idOrderClient) references clients (idClient)
			on update cascade -- todas as tabelas relacionadas serão atualizadas
);
alter table orders auto_increment=1;

desc orders;

-- criar tabela estoque OK
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);
alter table productStorage auto_increment=1;


-- criar tabela fornecedor OK
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment=1;

desc supplier;

-- criar tabela vendedor terceiro OK
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;


-- tabelas de relacionamentos M:N
-- Produtos por vendedor OK
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

desc productSeller;
-- Relação de produto por pedido OK
-- poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,    
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);
-- Produto em estoque OK
create table storageLocation(
	idLproduct int,
    idLstorage int,
    quantity int default 1,
    location enum("RJ","SP","GO"),
    primary key (idLproduct),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);
-- Produtos por fornecedor OK
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;

-- Estoque satisfaz pedido OK
create table storageEnough(
	idSEorder int,
    idSEproduct int,        
    constraint fk_storage_enough_order foreign key (idSEorder) references orders(idOrder),
    constraint fk_storage_enough_product foreign key (idSEproduct) references product(idProduct)
);

-- pagamento

create table payments(	
    idPayment int auto_increment primary key,
    idPclient int,
    idPproduct int,
    idPorder int,
    typePayment enum("PIX", "Boleto", "Cartão de crédito"),
    limitAvailable float,    
    constraint fk_payments_client foreign key (idPclient) references clients (idClient),
    constraint fk_payments_order foreign key (idPorder) references orders(idOrder),
    constraint fk_payments_product foreign key (idPproduct) references product(idProduct)
);

alter table payments auto_increment=1;

-- Entrega delivery OK
create table delivery(
	idDelivery int auto_increment primary key,    
    idDPayment int,
    idDproduct int,
    idDorder int,
    trackingcode varchar(45),
    dStatus varchar(45),
    constraint fk_delivery_payment foreign key (idDPayment) references payments(idPayment),
    constraint fk_delivery_order foreign key (idDorder) references orders(idOrder),    
    constraint fk_delivery_product foreign key (idDproduct) references product(idProduct)
);

alter table delivery auto_increment=1;

-- Usar recuperação simples com SELECT Statement
-- Filtros com WHERE Statement
-- Crie expressões para gerar atributos derivados
-- Defina ordenações dos dados com ORDER BY
-- COndições de filtros aos grupos - HAVING Statement
-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
-- Elabore perguntas que podem ser respondidas pelas consultas
-- As cláusulas podem estar presentes em mais de uma query

show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';
-- select * from clients;