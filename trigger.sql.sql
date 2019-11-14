/** Membuat Tabel baru **/
create table parameter(
 		id varchar2(3) not null primary key,
 name varchar2(50),
 		value number);

/** Insert data baru ke tabel parameter **/
insert into parameter
values (1, 'Jatuh Tempo', 14)


/** Menggunakan Trigger untuk mencetak “SP” pada id Supplier untuk tabel Supplier**/
/** Buat Trigger **/
create or replace trigger insert_supplier
before insert or update on supplier
for each row 
when (new.id > 0)
begin
 :new.id := 'SP' || :new.id;
END;

/** Coba Insert dengan data Baru **/
insert into supplier
 		values ('05', 'PT Martina', sysdate)


/** Menggunakan Trigger untuk mencetak “B” pada id Item untuk tabel Item **/
/** Buat Trigger **/
create or replace trigger insert_item
before insert or update on item
for each row 
when (new.id > 0)
begin
:new.id := 'B' || :new.id;
 		:new.supplier_id := 'SP' || :new.supplier_id;
END;

/** Coba Insert dengan data Baru **/
insert into item
 		values ('05', 'Basis Data', 100000, 13, '05')


/** Menggunakan Trigger untuk mencetak "SP" dan “B” pada id Supplier dan id Item untuk tabel TransactionItem **/
/** Buat Trigger **/
create or replace trigger insert_TransactionItem
before insert or update on TransactionItem
for each row 
when (new.quantity > 0)
begin
 		:new.item_id := 'B' || :new.item_id;
END;

/** Coba Insert dengan data Baru **/
insert into TransactionItem
values (07, 6, 105, '04')
