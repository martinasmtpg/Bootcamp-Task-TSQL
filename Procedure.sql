/** Menampilkan data barang **/
/** Buat Procedure **/
create or replace procedure getdataBarang
  		IS cursor barang is 
 	select
 		i.id KodeBarang,
i.name NamaBarang,
 		s.name Supplier
from
 		supplier s join Item i
on
 		s.id=i.supplier_id
order by
i.id;
b_rec barang%rowtype;
begin
 		for b_rec in barang loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Kode Barang : '||b_rec.KodeBarang);
  		dbms_output.put_line('Nama Barang : '||b_rec.NamaBarang);
  		dbms_output.put_line('Supplier : '||b_rec.Supplier);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataBarang();
end


/** Menampilkan data Faktur **/
/** Buat Procedure **/
create or replace procedure getdataFaktur101
  		IS cursor f_101 is 
select
 		ti.transaction_id nofak,
s.name supp,
 		i.name nama_barang,
i.price harga
from
 		supplier s join Item i
on
s.id=i.supplier_id
join
 		TransactionItem ti
on
 		ti.item_id=i.id
and
 		ti.transaction_id='101';
 		b_rec f_101%rowtype;
begin
for b_rec in f_101 loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Nomor Faktur : '||b_rec.nofak);
  		dbms_output.put_line('Supplier : '||b_rec.supp);
 		dbms_output.put_line('Barang : '||b_rec.nama_barang);
  		dbms_output.put_line('Price : '||b_rec.harga);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataFaktur101();
end

/** Menampilkan Jumlah barang yang terjual **/
/** Buat Procedure **/
create or replace procedure getdataSoldOut
 		IS cursor soldout is 
 	select
i.name nameitem,
 		sum(ti.quantity) quantity
from
 		TransactionItem ti join Item i
on
 		ti.item_id=i.id
group by
 		i.name
order by
 		i.name;
 		b_rec soldout%rowtype;
begin
 		for b_rec in soldout loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Name : '||b_rec.nameitem);
  		dbms_output.put_line('Quantity : '||b_rec.quantity);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataSoldOut();
end

/** Menampilkan Jumlah data barang yang terjual di bulan Oktober **/
/** Buat Procedure **/
create or replace procedure getdataSoldPerMonth(month in number)
 		IS cursor octsold is 
 	select
  		i.name nameitem,
  		sum(ti.quantity) quantity
from
TransactionItem ti join Item i
on
 		ti.item_id=i.id
join transaction t
on
 		ti.transaction_id=t.id
 	where 
  		extract(month from t.orderdate)=month
group by
i.name
order by
i.name; 
 		b_rec octsold%rowtype;
begin
 		for b_rec in octsold loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Name : '||b_rec.nameitem);
  		dbms_output.put_line('Quantity : '||b_rec.quantity);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataSoldPerMonth(10);
end

/** Menampilkan total produk yang terjual bulan October, November, dan Desember **/
/** Buat Procedure **/
create or replace procedure getdataSoldPerMonth
  		IS cursor sold is 
select
  		i.name nameitem,
  		sum(case when extract(month from t.orderdate)=10
  	then
ti.quantity else 0 end) oct,
 		sum(case when extract(month from t.orderdate)=11
  	then
 		ti.quantity else 0 end) nov,
 		sum(case when extract(month from t.orderdate)=12
 	then
ti.quantity else 0 end) dec
from TransactionItem ti
join transaction t
on
 		ti.transaction_id=t.id
join Item I
on 
ti.item_id = i.id
group by 
i.name;
 		b_rec sold%rowtype;
begin
 		for b_rec in sold loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Name : '||b_rec.nameitem);
  		dbms_output.put_line('October : '||b_rec.oct);
  		dbms_output.put_line('November : '||b_rec.nov);
  		dbms_output.put_line('December : '||b_rec.dec);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataSoldPerMonth();
end

/** Menampilkan total data produk yang telah terjual bulan October, November, dan Desember serta total per bulan **/
create or replace procedure getdataTotalSoldPerMonth
IS cursor totalsold is 
select
 		i.name nameitem, sum(case when extract(month from t.orderdate)=10
  	then
 		ti.quantity else 0 end) oct, sum(case when extract(month from t.orderdate)=11
  	then
 ti.quantity else 0 end) nov, sum(case when extract(month from t.orderdate)=12 
  	then
ti.quantity else 0 end) dec
from TransactionItem ti
join transaction t
on
 		ti.transaction_id=t.id
join Item I 
on 
ti.item_id = i.id
group by 
i.name
union 
select  
 	'T O T A L',
 		sum(case when extract(month from t.orderdate)=10 
  	then 
 		ti.quantity else 0 end) oct, sum(case when extract(month from t.orderdate)=11 
  	then 
ti.quantity else 0 end) nov, sum(case when extract(month from t.orderdate)=12 
  	then 
ti.quantity else 0 end) dec
from TransactionItem ti
join transaction t 
on 
ti.transaction_id=t.id
join Item I
 	on 
ti.item_id=i.id;
 		b_rec totalsold%rowtype;
begin
for b_rec in totalsold loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Name : '||b_rec.nameitem);
  		dbms_output.put_line('October : '||b_rec.oct);
  		dbms_output.put_line('November : '||b_rec.nov);
  		dbms_output.put_line('December : '||b_rec.dec);
 		end loop; 
end

/** Panggil Procedure **/
begin getdataTotalSoldPerMonth();
end
