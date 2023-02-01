CREATE FUNCTION tambah_hari
(
	@v_hari int, @v_tanggal datetime
)
RETURNS datetime
AS
BEGIN
-- =============================================
-- Author:		Dimara Kusuma Hakim
-- Create date: 16 Desember 2014
-- Description:	tabel kalender dan fungsi tambah hari
-- =============================================

	DECLARE @hasil datetime;

SELECT @hasil = max(a.tanggal) 
FROM 
(
SELECT top (@v_hari)
* 
FROM d_kalender 
WHERE tanggal > @v_tanggal
AND is_libur <> 1
ORDER BY tanggal
) as A

	RETURN @hasil ;

END
GO

