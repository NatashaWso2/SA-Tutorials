CREATE database bankdb;
USE bankdb;
CREATE TABLE accounts(accountId int  NOT NULL, balance decimal(13,2) NOT NULL, PRIMARY KEY (accountId));
INSERT INTO accounts (accountId, balance) VALUES (110011, 12000.00);
INSERT INTO accounts (accountId, balance) VALUES (110012, 15500.00);

CREATE database transactiondb;
USE transactiondb;
CREATE TABLE accounts(accountId int  NOT NULL, balance decimal(13,2) NOT NULL, updated enum('1','0') NOT NULL DEFAULT '0' , PRIMARY KEY (accountId));
