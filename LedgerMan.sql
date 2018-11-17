/* Create The Database */
create database LEDGERMAN;

/* Select The Database */
use LEDGERMAN;

/* Implement The User Schema */
create table if not exists User(
	user_id varchar(20) not null primary key,
	first_name varchar(20) not null,
	last_name varchar(20),
	street varchar(20) not null,
	city varchar(20) not null,
	phone varchar(20) not null);

/* Implement The Account Schema */
create table if not exists Account(
	account_id varchar(20) not null primary key,
	user_id varchar(20) not null,
	upi_id int(6) not null,
	balance int not null,
	constraint FK_Account_User foreign key (user_id) references User(user_id));

/* Implement The Mutual Funds Schema */
create table if not exists MutualFunds(
	scheme_id varchar(20) not null primary key,
	title varchar(20) not null,
	return_rate int not null,
	monthwise_duration int not null);

/* Implement The Transfers Schema */
create table if not exists Transfers(
	transfer_id varchar(20) not null primary key,
	lender_id varchar(20) not null,
	borrower_id varchar(20) not null,
	amount int not null);

/* Implement The Loans Schema */
create table if not exists Loans(
	loan_id varchar(20) not null primary key,
	lender_id varchar(20) not null,
	borrower_id varchar(20) not null,
	amount int not null,
	interest_rate int not null,
	monthwise_duration int not null);

/* Implement The Transaction Schema */
create table if not exists Transaction(
	transaction_id varchar(20) not null primary key,
	transaction_type enum('Mutual Fund', 'Transfer', 'Loan'),
	account_id varchar(20) not null,
	constraint FK_Transaction_Account foreign key (account_id) references Account(account_id));

/* Implement The LedgerMan Schema */
create table if not exists LedgerMan(
	transaction_id varchar(20) not null,
	net_gross int,
	constraint FK_LedgerMan_Transaction foreign key (transaction_id) references Transaction(transaction_id));

/* Insert The User Data */
insert into User values('1', 'Rajesh', 'Rajan', 'Contini George', 'Patna', '9876543210');
insert into User values('2', 'Ramesh', 'Lajan', 'Bontini George', 'Mumbai', '9786543210');
insert into User values('3', 'Suresh', 'Hajan', 'Dontini George', 'Pune', '9867543210');
insert into User values('4', 'Mahesh', 'Majan', 'Fontini George', 'Palam', '9875643210');
insert into User values('5', 'Yogesh', 'Sajan', 'Hontini George', 'Kolkata', '9876453210');

/* Insert The Account Data */
insert into Account values('11', '1', 112233, 100000);
insert into Account values('22', '2', 223344, 1000000);
insert into Account values('33', '3', 334455, 10000);
insert into Account values('44', '4', 445566, 10000000);
insert into Account values('55', '5', 556677, 10000);

/* Insert The Mutual Funds Data */
insert into MutualFunds values('111', 'SBI Mutual', 4, 6);
insert into MutualFunds values('222', 'CANARA Mutual', 5, 8);
insert into MutualFunds values('333', 'ICICI Mutual', 6, 10);
insert into MutualFunds values('444', 'IDBI Mutual', 7, 12);
insert into MutualFunds values('555', 'HDFC Mutual', 8, 14);

/* Insert The Transfers Data */
insert into Transfers values('666', '11', '22', 10000);
insert into Transfers values('777', '22', '33', 10000);
insert into Transfers values('888', '33', '44', 10000);
insert into Transfers values('999', '44', '55', 10000);
insert into Transfers values('1000', '55', '11', 10000);

/* Insert The Loans Data */
insert into Loans values('1111', '11', '22', 10000, 3, 6);
insert into Loans values('2222', '22', '33', 10000, 4, 5);
insert into Loans values('3333', '33', '44', 10000, 5, 4);
insert into Loans values('4444', '44', '55', 10000, 6, 3);
insert into Loans values('5555', '55', '11', 10000, 7, 2);

/* Insert The Transaction Data */
insert into Transaction values('111', 'Mutual Fund', '22');
insert into Transaction values('222', 'Mutual Fund', '33');
insert into Transaction values('333', 'Mutual Fund', '44');
insert into Transaction values('444', 'Mutual Fund', '55');
insert into Transaction values('555', 'Mutual Fund', '11');
insert into Transaction values('666', 'Transfer', '11');
insert into Transaction values('777', 'Transfer', '22');
insert into Transaction values('888', 'Transfer', '33');
insert into Transaction values('999', 'Transfer', '44');
insert into Transaction values('1000', 'Transfer', '55');
insert into Transaction values('1111', 'Loan', '11');
insert into Transaction values('2222', 'Loan', '22');
insert into Transaction values('3333', 'Loan', '33');
insert into Transaction values('4444', 'Loan', '44');
insert into Transaction values('5555', 'Loan', '55');

insert into LedgerMan values('111', 0);
insert into LedgerMan values('222', 0);
insert into LedgerMan values('333', 0);
insert into LedgerMan values('444', 0);
insert into LedgerMan values('555', 0);
insert into LedgerMan values('666', 0);
insert into LedgerMan values('777', 0);
insert into LedgerMan values('888', 0);
insert into LedgerMan values('999', 0);
insert into LedgerMan values('1000', 0);
insert into LedgerMan values('1111', 7);
insert into LedgerMan values('2222', 7);
insert into LedgerMan values('3333', 7);
insert into LedgerMan values('4444', 7);
insert into LedgerMan values('5555', 7);

/* For Querying User and Account Information */
select * from User where user_id = '1';
select * from Account where user_id = '1';

/* For Querying Past History By Account */
select * from Transaction where account_id = '11';

/* For Ranking Mutual Funds By Returns */
select * from MutualFunds order by return_rate desc;

/* For Charge Incurred By Account */
create view LoanCharge as select count(transaction_id) * 7 as loan_charge from Transaction where account_id = '11' and transaction_type = 'Loan';

create view Temp as select return_rate * monthwise_duration / 100 as fractional from MutualFunds left join Transaction on MutualFunds.scheme_id = Transaction.transaction_id where account_id = '11';
create view MutualFundCharge as select fractional * balance / 50 as fund_charge from Account, Temp where account_id = '11';

select fund_charge + loan_charge as total_charge from LoanCharge, MutualFundCharge;