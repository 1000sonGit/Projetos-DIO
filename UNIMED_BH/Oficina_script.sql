-- criação do banco de dados para o cenário de E-commerce 
-- drop database oficina;
create database oficina;
use oficina;

-- tabela cliente
create table clients(
		idClient int auto_increment primary key,
        CName varchar(45) not null,               
        CPF char(11) not null,        
        Address varchar(255) not null,
        carro varchar(45) not null,
        constraint unique_cpf_client unique (CPF)        
);

alter table clients auto_increment=1;

-- tabela OS
-- drop table orders;
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    number_os int not null,
    date_open varchar(45) not null,
    osvalue float not null,    
    status_os enum('Avaliando', 'Em manutenção', 'Entregue') default 'Avaliando',
    date_close varchar(45) not null,
    part_value float not null,
    permission bool default false,
    type_os varchar(45) not null,    
    constraint fk_ordes_client foreign key (idOrderClient) references clients (idClient)
			on update cascade -- todas as tabelas relacionadas serão atualizadas
);
alter table orders auto_increment=1;

desc orders;

-- desc clients;
-- tabela mecânico
create table mechanic(
		idMechanic int auto_increment primary key,
        Mname varchar(45) not null,
        code_s varchar(45) not null,
        M_Address varchar(255) not null,
        expertise varchar(45) not null       
);
alter table mechanic auto_increment=1;

-- tabela Estoque de peças
create table storageParts(
	idParts int auto_increment primary key,
    Pname varchar(45) not null,
    Pcode varchar(45) not null
);
alter table storageParts auto_increment=1;

-- tabela Serviço aprovado
create table serviceAgree(
	idService int auto_increment primary key,
    idSClient int,
    constraint fk_serviceAgree_client foreign key (idSClient) references clients (idClient)
);

-- tabela pagamento
create table payments(	
    idPayment int auto_increment primary key,
    idPorders int,    
    typePayment enum("PIX", "Parcelado"),        
    constraint fk_payments_order foreign key (idPorders) references orders (idOrder)
    
);

alter table payments auto_increment=1;


-- tabelas de relacionamentos M:N
-- tabela checar peças
create table checkParts(
	idCParts int,
    idCOrders int,
    constraint fk_checkparts_parts foreign key (idCParts) references storageParts(idParts),
    constraint fk_checkparts_orders foreign key (idCOrders) references orders(idOrder)
);

-- tabela estoque de peças satisfaz pedido
create table storageEnought(
	idSEparts int,
    idSEorderagree int,
    constraint fk_storageEnought_parts foreign key (idSEparts) references storageParts(idParts),
    constraint fk_storageEnought_orderAgree foreign key (idSEorderagree) references serviceAgree(idService)
);

-- tabela Ordens e Serviço
create table ordersService(
    idOSserviceagree int,
    idOSorders int,
    constraint fk_ordersService_orderAgree foreign key (idOSserviceagree) references serviceAgree(idService),
    constraint fk_ordersService_orders foreign key (idOSorders) references orders(idOrder)
);

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
select * from referential_constraints where constraint_schema = 'oficina';
-- select * from clients;