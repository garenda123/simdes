--select * from d_kalender

/*
SELECT *, datepart(weekday, tanggal)
FROM d_kalender
WHERE 
datepart(weekday, tanggal) = 1
OR 
datepart(weekday, tanggal) = 7
ORDER BY tanggal ASC
*/

-- tetapkan nilai default is_libur
UPDATE d_kalender
SET is_libur = 0


-- jika libur hari sabtu + minggu
UPDATE d_kalender
SET is_libur = 1
WHERE 
datepart(weekday, tanggal) = 1 
OR							   -- Jika libur hari sabtu. Jika tidak, nonaktifkan
datepart(weekday, tanggal) = 7 -- Jika libur hari sabtu. Jika tidak, nonaktifkan

/*
select *
from d_kalender
where day(tanggal) = 17 and month(tanggal) = 8
*/

UPDATE d_kalender
SET is_libur = 1, keterangan = 'Tahun Baru'
WHERE day(tanggal) = 1 and month(tanggal) = 1

UPDATE d_kalender
SET is_libur = 1, keterangan = 'Hari Buruh Internasional'
WHERE day(tanggal) = 1 and month(tanggal) = 5

UPDATE d_kalender
SET is_libur = 1, keterangan = 'Hari Kemerdekaan'
WHERE day(tanggal) = 17 and month(tanggal) = 8

UPDATE d_kalender
SET is_libur = 1, keterangan = 'Natal'
WHERE day(tanggal) = 25 and month(tanggal) = 12

