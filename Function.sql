/** Menampilkan data total faktur **/
/** Buat Function **/
create or replace function totalfaktur(quantity in number, price in number)
 	return number is total number(12) := 0;
begin
 		total := quantity*price;
return total;
end

/** Buat Procedure **/
create or replace procedure getdataFakturAll
IS cursor faktur is 
 	select
ti.transaction_id nofak,
 		i.name nama_barang,
 		ti.quantity quantity,
 		i.price harga,
 		to_char(totalfaktur(i.price, ti.quantity), '99,999,999.00') total
from
TransactionItem ti join Item i
on
ti.item_id=i.id
order by
 		ti.transaction_id;
 		b_rec faktur%rowtype;
begin
 		for b_rec in faktur loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Nomor Faktur : '||b_rec.nofak);
  		dbms_output.put_line('Barang : '||b_rec.nama_barang);
  		dbms_output.put_line('Quantity : '||b_rec.quantity);
  		dbms_output.put_line('Harga : '||b_rec.harga); 
  		dbms_output.put_line('Total Harga : '||b_rec.total);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataFakturAll();
end


/** Menampilkan data faktur beserta jatuh tempo **/
/** Buat Function **/
create or replace function jatuhtempo(orderdate in date, tempo in number)
 	return date is japo date;
begin
japo := orderdate+tempo; 
return japo;
end

/** Buat Procedure **/
create or replace procedure getdataJatuhTempo
IS cursor japo is 
 	select
 		distinct
t.id nofak,
to_char(sum(totalfaktur(i.price, ti.quantity)) over (partition by t.id),'99,999,999.00') totalfaktur,
to_char(t.orderdate, 'yyyy-mm-dd') fakturdate,
to_char(jatuhtempo(t.orderdate, (select value from parameter where id = '1')), 'yyyy-mm-dd') japo
from
 		transaction t join TransactionItem ti
on
t.id=ti.transaction_id
join Item i
on
 		i.id=ti.item_id
group by
 		t.id, i.price,t.orderdate,ti.quantity
order by
 		t.id;
 		b_rec japo%rowtype;
begin
 		for b_rec in japo loop
  		dbms_output.put_line('--------------------------------');
  		dbms_output.put_line('Nomor Faktur : '||b_rec.nofak);
  		dbms_output.put_line('Total Faktur : '||b_rec.totalfaktur);
 		dbms_output.put_line('Tanggal Faktur : '||b_rec.fakturdate);
  		dbms_output.put_line('Jatuh Tempo : '||b_rec.japo);
 		end loop;
end;

/** Panggil Procedure **/
begin getdataJatuhTempo();
end