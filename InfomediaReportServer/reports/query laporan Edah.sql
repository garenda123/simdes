SELECT 
x.permit_group_name, 
CASE 
WHEN SD_bulan_ini is null THEN 0
ELSE SD_bulan_ini
END as SD_bulan_ini, 

CASE 
WHEN Terbit is null THEN 0
ELSE Terbit
END as Terbit, 

CASE 
WHEN Proses is null THEN 0
ELSE Proses
END as Proses, 

CASE 
WHEN Ditolak is null THEN 0
ELSE Ditolak
END as Ditolak

FROM
(
SELECT y.permit_group_name,SUM (SD_bulan_ini) as SD_bulan_ini , SUM (Proses) as Proses, SUM (Terbit) as Terbit , SUM (Ditolak) as Ditolak
FROM d_permit_group y

LEFT OUTER JOIN 
(
SELECT  permit_group_id, count(*) SD_Bulan_Ini, 0 as Terbit, 0 as Proses, 0 as Ditolak
FROM m_company_detail
WHERE tanggal_sk is not null
AND tanggal_sk < CAST ('11' + '/01/' + '2014' as datetime)
GROUP BY permit_group_id

UNION

SELECT  permit_group_id,  0 as SD_Bulan_Ini, count(*) as Terbit, 0 as Proses, 0 as Ditolak
FROM m_company_detail
WHERE tanggal_sk is not null
AND month(tanggal_sk) = 11
AND year(tanggal_sk) = 2014
GROUP BY permit_group_id

UNION
SELECT  a.permit_group_id, 0 as SD_Bulan_Ini,0 as Terbit, count(a.permit_id) as Diproses, 0 as Ditolak
FROM m_company_detail a
LEFT OUTER JOIN m_company b ON a.company_id = b.company_id
WHERE a.tanggal_sk is null
AND a.tanggal_tolak is null
AND month(b.input_date) = 11
AND year(b.input_date) = 2014
GROUP BY a.permit_group_id

UNION
SELECT permit_group_id,0 as SD_bulan_ini,0 as Terbit ,0 as Proses, count(*)  as Ditolak
FROM m_company_detail
WHERE tanggal_tolak is not null
AND month(tanggal_tolak) = 11
AND year(tanggal_tolak) = 2014
GROUP BY permit_group_id
) as Z
ON y.permit_group_id = z.permit_group_id

GROUP BY  y.permit_group_name
) as x
