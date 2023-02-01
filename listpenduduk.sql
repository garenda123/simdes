SELECT
	cast(
	AES_DECRYPT( a.nik, 33189 ) AS CHAR ( 16 )) AS NIK,
	a.stat_ektp,
	cast(
	AES_DECRYPT( a.no_kk, 33189 ) AS CHAR ( 16 )) AS NO_KK,
	AES_DECRYPT( a.NAMA_LGKP, 33189 ) AS NAMA_LGKP,
	a.TGL_LHR AS TANGGAL_LAHIR,
	ROUND(
	udfGetUmur ( a.tgl_lhr )) AS UMUR,
	a.TMPT_LHR AS TEMPAT_LAHIR,
IF
	( a.jenis_klmin = 1, 'LK', 'PR' ) AS JENIS_KELAMIN,
	S.DESCRIP AS SHDK,
	a.tmpt_sbl AS ALAMAT_SEBELUMNYA,
	b.ALAMAT,
	lpad( b.NO_RT, 3, '0' ) AS NO_RT,
	lpad( b.NO_RW, 3, '0' ) AS NO_RW,
	k.descrip AS STATUS_KAWIN,
IF
	( ifnull( f2.descrip, '' )= '', f.descrip, f2.descrip ) AS PENDIDIKAN,
	g.descrip AS AGAMA,
IF
	( ifnull( h2.descrip, '' )= '', h.descrip, h2.descrip ) AS PEKERJAAN,
IF
	( ifnull( l2.descrip, '' )= '', l.descrip, l2.descrip ) AS GOLONGAN_DARAH,
IF
	( ifnull( m2.descrip, '' )= '', m.descrip, m2.descrip ) AS CACAT,
CASE
		
		WHEN a.akta_lhr = 2 THEN
		'ADA' ELSE 'TIDAK ADA' 
	END AS AKTA_LAHIR,
CASE
		
		WHEN a.akta_kwn = 2 THEN
		'ADA' ELSE 'TIDAK ADA' 
	END AS AKTA_KAWIN,
	a.tgl_kwn AS TANGGAL_KAWIN,
CASE
		
		WHEN a.akta_crai = 2 THEN
		'ADA' ELSE 'TIDAK ADA' 
	END AS AKTA_CERAI,
	a.tgl_crai AS TANGGAL_CERAI,
IF
	( length( ifnull( t.NO_AKTA_LHR, '' ))> 2, t.NO_AKTA_LHR, a.NO_AKTA_LHR ) AS NO_AKTA_LAHIR,
IF
	( length( ifnull( t.NO_AKTA_KWN, '' ))> 2, t.NO_AKTA_KWN, a.NO_AKTA_KWN ) AS NO_AKTA_KAWIN,
IF
	( length( ifnull( t.NO_AKTA_CRAI, '' ))> 2, t.NO_AKTA_CRAI, a.NO_AKTA_CRAI ) AS NO_AKTA_CERAI,
	cast(
	a.nik_ayah AS CHAR ( 16 )) AS NIK_AYAH,
	a.nama_lgkp_ayah AS NAMA_AYAH,
	cast(
	a.nik_ibu AS CHAR ( 16 )) AS NIK_IBU,
	a.nama_lgkp_ibu AS NAMA_IBU,
	i.nama_kel AS KELURAHAN,
	i.nama_kec AS KECAMATAN,
	a.NO_PASPOR,
	a.TGL_AKH_PASPOR,
	ft.FOTO 
FROM
	biodata_wni a
	LEFT OUTER JOIN data_keluarga b ON b.no_kk = a.no_kk
	LEFT OUTER JOIN biodata_foto ft ON ft.nik = a.nik
	LEFT OUTER JOIN pddkn_master f ON f.NO = a.pddk_akh
	LEFT OUTER JOIN agama_master g ON g.NO = a.agama
	LEFT OUTER JOIN pkrjn_master h ON h.NO = a.jenis_pkrjn
	LEFT OUTER JOIN cct_master m ON m.NO = a.PNYDNG_CCT
	LEFT OUTER JOIN kwn_master k ON k.NO = a.stat_kwn
	LEFT OUTER JOIN goldrh_master l ON l.NO = a.gol_drh
	LEFT OUTER JOIN instansi i ON i.no_kel = b.no_kel
	LEFT OUTER JOIN SHDK S ON S.NO = A.STAT_HBKEL
	LEFT OUTER JOIN z_des_biodata_wni_maintenance a3 ON cast(
		a3.nik AS CHAR ( 16 ))= cast(
	a.nik AS CHAR ( 16 )) 
	AND a3.flag_status IN ( 1, 2, 3 ) 
	AND status_update = 0
	LEFT OUTER JOIN ( SELECT * FROM z_des_biodata_wni_maintenance WHERE flag_status = 0 AND status_update = 0 /*lengkapi data*/ ) t ON t.nik = a.nik
	LEFT OUTER JOIN pddkn_master f2 ON f2.NO = t.pddk_akh
	LEFT OUTER JOIN pkrjn_master h2 ON h2.NO = t.jenis_pkrjn
	LEFT OUTER JOIN cct_master m2 ON m2.NO = t.PNYDNG_CCT
	LEFT OUTER JOIN goldrh_master l2 ON l2.NO = t.gol_drh 
WHERE
	a.flag_status = '0' 
	AND ifnull( a3.nik, '' )= '' 
ORDER BY
	b.no_rw,
	b.no_rt,
	b.no_kk,
	a.stat_hbkel,
	a.nik