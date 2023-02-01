<?php 
$my['host'] = "localhost";
$my['user'] = "c4sa_simdes";
$my['pass'] = "janganlupa";
$my['dbs'] = "c4simdesv2_db";

$koneksi = mysql_connect($my['host'],$my['user'],$my['pass']);
if (! $koneksi) {
	echo "gagal boss";
	mysql_error();
	}
mysql_select_db($my['dbs'])
		or die ("gagal boss".mysql_error());

function ambil_bulan($x)
{
	
	
	$hasil = 'JANUARI';
	return $hasil;
}	
	
?>
