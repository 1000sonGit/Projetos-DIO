-- inserção de dados e queries
use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into clients (CName, CPF, Address) 
	   values('Maria M Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
		     ('Matheus O Pimentel', 987654321,'rua alemeda 289, Centro - Cidade das flores'),
			 ('Ricardo F Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
			 ('Julia S França', 789123456,'rua lareijras 861, Centro - Cidade das flores'),
			 ('Roberta G Assis', 98745631,'avenidade koller 19, Centro - Cidade das flores'),
			 ('Isabela M Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');


-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, size, avaliação) values
							  ('Fone de ouvido',false,'Eletrônico',null,'4'),
                              ('Barbiesize Elsa',true,'Brinquedos',null,'3'),
                              ('Body Carters',true,'Vestimenta',null,'5'),
                              ('Microfone Vedo - Youtuber',False,'Eletrônico',null,'4'),
                              ('Sofá retrátil',False,'Móveis','3x57x80','3'),
                              ('Farinha de arroz',False,'Alimentos',null, '2'),
                              ('Fire Stick Amazon',False,'Eletrônico',null, '3');

select * from clients;
select * from product;
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash

delete from orders where idOrderClient in  (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue) values 
							 (1, default,'compra via aplicativo',null),
                             (2,default,'compra via aplicativo',50),
                             (3,'Enviado',null,null),
                             (4,default,'compra via web site',150);

-- idPOproduct, idPOorder, poQuantity, poStatus
select * from orders;
insert into productOrder (idPOproduct, idPOorder, poQuantity) values
						 (1,1,2),
                         (2,1,1),
                         (3,2,1);

-- storageLocation,quantity
insert into productStorage (storageLocation,quantity) values 
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);

-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, quantity, location) values
						 (1,2,100,'RJ'),
                         (2,6,50,'GO');

-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values 
							('Almeida e filhos', 12345678912345,'21985474'),
                            ('Eletrônicos Silva',85451964914345,'21985484'),
                            ('Eletrônicos Valma', 93456789393469,'21975474');
                            
select * from supplier;
-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
						 (1,1,500),
                         (1,2,400),
                         (2,4,633),
                         (3,3,5),
                         (2,5,10);

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values 
						('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
					    ('Botique Durgas',null,null,123456783,'Rio de Janeiro', 219567895),
						('Kids World',null,456789123654485,null,'São Paulo', 1198657484);

select * from seller;
-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values 
						 (1,6,80),
                         (2,7,10);

select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

select CName, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
-- select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue) values 
							 (2, default,'compra via aplicativo',50);
                             
select count(*) from clients c, orders o 
			where c.idClient = idOrderClient;

select * from orders;

-- recuperação de pedido com produto associado
select * from clients c 
				inner join orders o ON c.idClient = o.idOrderClient
                inner join productOrder p on p.idPOorder = o.idOrder
		group by idClient; 
        
-- Recuperar quantos pedidos foram realizados pelos clientes?
select c.idClient, Cname, count(*) as Number_of_orders from clients c 
				inner join orders o ON c.idClient = o.idOrderClient
		group by idClient; 
        
-- Quantos brinquedos foram comprados?
select count(*) from product p where p.category = 'Brinquedos';