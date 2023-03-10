USE [master]
GO
/****** Object:  Database [permit_banjar]    Script Date: 12/15/2014 12:55:02 ******/
CREATE DATABASE [permit_banjar] ON  PRIMARY 
( NAME = N'permit_banjar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\permit_banjar.mdf' , SIZE = 17728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'permit_banjar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\permit_banjar.LDF' , SIZE = 4224KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [permit_banjar] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [permit_banjar].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [permit_banjar] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [permit_banjar] SET ANSI_NULLS OFF
GO
ALTER DATABASE [permit_banjar] SET ANSI_PADDING OFF
GO
ALTER DATABASE [permit_banjar] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [permit_banjar] SET ARITHABORT OFF
GO
ALTER DATABASE [permit_banjar] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [permit_banjar] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [permit_banjar] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [permit_banjar] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [permit_banjar] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [permit_banjar] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [permit_banjar] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [permit_banjar] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [permit_banjar] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [permit_banjar] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [permit_banjar] SET  DISABLE_BROKER
GO
ALTER DATABASE [permit_banjar] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [permit_banjar] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [permit_banjar] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [permit_banjar] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [permit_banjar] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [permit_banjar] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [permit_banjar] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [permit_banjar] SET  READ_WRITE
GO
ALTER DATABASE [permit_banjar] SET RECOVERY SIMPLE
GO
ALTER DATABASE [permit_banjar] SET  MULTI_USER
GO
ALTER DATABASE [permit_banjar] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [permit_banjar] SET DB_CHAINING OFF
GO
USE [permit_banjar]
GO
/****** Object:  UserDefinedFunction [dbo].[angka_romawi]    Script Date: 12/15/2014 12:55:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[angka_romawi] (@x int)
RETURNS varchar(5)
AS
BEGIN
 DECLARE @hasil varchar(5);
   
   SELECT @hasil = CASE
		   	WHEN @x = 1 THEN 'I'
			WHEN @x = 2 THEN 'II'
			WHEN @x = 3 THEN 'III'
			WHEN @x = 4 THEN 'IV'
			WHEN @x = 5 THEN 'V'
			WHEN @x = 6 THEN 'VI'
			WHEN @x = 7 THEN 'VII'
			WHEN @x = 8 THEN 'VIII'
			WHEN @x = 9 THEN 'IX'
			WHEN @x = 10 THEN 'X'
			WHEN @x = 11 THEN 'XI'
			WHEN @x = 12 THEN 'XII'
            ELSE '' 
            end

  return @hasil ;
END
GO
/****** Object:  Table [dbo].[t_permit_IUTM]    Script Date: 12/15/2014 12:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IUTM](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[atas_nama] [varchar](255) NULL,
	[status_survey_id] [smallint] NULL,
	[jenis_usaha] [varchar](50) NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
	[nomor_BAP] [varchar](50) NULL,
	[tanggal_BAP] [datetime] NULL,
 CONSTRAINT [PK__t_permit_IUTM__2FCF1A8A] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_IUTM]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_IUTM]
AS
SELECT 
  permit_id,
  company_id,
  jenis_usaha
FROM 
  dbo.t_permit_IUTM ;
GO
/****** Object:  UserDefinedFunction [dbo].[get_company_code_IUJK]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[get_company_code_IUJK] ( @company_id bigint , @jenis_usaha_id varchar(4) )
RETURNS varchar(50)  AS
BEGIN

--  <menentukan Kode Perusahaan untuk IUJK
	DECLARE @vID varchar(50)
	DECLARE @vNumber  varchar(6)
	
	SELECT @vNumber = substring(a.permit_number,3,6)
    FROM t_permit_IUJK a
    WHERE company_id = @company_id

  	
IF (@vNumber is null) or (@vNumber = '')
BEGIN
	SELECT  @vNumber =
	  CASE

	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1) / 10 >= 10000
	    THEN  rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1) / 10 >= 1000
	    THEN '0' + rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1) / 10 >= 100
	    THEN '00' + rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))
        	
	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1) / 10 >= 10
	    THEN '000' + rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1) / 10 >= 1
	    THEN '0000' + rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)/ 10 = 0
        THEN '00000' + rtrim(ltrim(str(ISNULL(max(substring(permit_number,3,6)) + 0,0) + 1)))

	  END
	FROM t_permit_IUJK
	WHERE IsNumeric(substring(permit_number,3,6)) > 0
	AND jenis_usaha_id = @jenis_usaha_id
END	
	     	

RETURN @vNumber

END
GO
/****** Object:  Table [dbo].[t_permit_IUJK]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IUJK](
	[permit_id] [bigint] NOT NULL,
	[company_id] [varchar](50) NULL,
	[business_kind] [varchar](255) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[bidang_id] [int] NULL,
	[letter_date] [datetime] NULL,
	[jenis_usaha] [varchar](50) NULL,
	[nama_penanggung_jawab1] [varchar](255) NULL,
	[nama_penanggung_jawab2] [varchar](255) NULL,
	[nama_penanggung_jawab3] [varchar](255) NULL,
	[perusahaan_jalan_nomor] [varchar](255) NULL,
	[perusahaan_kelurahan] [varchar](255) NULL,
	[perusahaan_rt_rk_rw] [varchar](255) NULL,
	[penanggung_jawab_teknis] [varchar](255) NULL,
	[pjt_bu] [varchar](255) NULL,
	[kualifikasi_id] [int] NULL,
	[RT] [varchar](10) NULL,
	[RW] [varchar](10) NULL,
	[nomor_sbu] [varchar](20) NULL,
	[status_survey_id] [smallint] NULL,
	[desa_id] [int] NULL,
 CONSTRAINT [PK__t_permit_IUJK__282DF8C2] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_IUJK]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_IUJK] 
AS
SELECT 
  permit_id,
  company_id,
  permit_type_id,
  bidang_id,
  jenis_usaha,
  nama_penanggung_jawab1,
  nama_penanggung_jawab2,
  nama_penanggung_jawab3,
  perusahaan_jalan_nomor,
  perusahaan_kelurahan,
  perusahaan_rt_rk_rw,
  penanggung_jawab_teknis,
  kualifikasi_id,
  RT,
  RW,
  pjt_bu,
  nomor_sbu
FROM 
  dbo.t_permit_IUJK ;
GO
/****** Object:  Table [dbo].[t_permit_REKLAME]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_REKLAME](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[Tempat_Pemasangan] [varchar](255) NULL,
	[reklame_produk] [varchar](255) NULL,
	[reklame_waktu_pasang] [varchar](255) NULL,
	[tanggal_mulai] [datetime] NULL,
	[tanggal_akhir] [datetime] NULL,
	[reklame_ukuran] [varchar](255) NULL,
	[sk_lama] [varchar](255) NULL,
	[nomor_BAP] [varchar](255) NULL,
	[jenis_reklame] [varchar](255) NULL,
	[atas_nama] [varchar](255) NULL,
	[status_survey_id] [int] NULL,
	[petugas_id] [int] NULL,
	[petugas_2] [int] NULL,
	[petugas_3] [int] NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
	[tanggal_BAP] [datetime] NULL,
 CONSTRAINT [PK__t_permit_REKLAME__37703C52] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_REKLAME]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_REKLAME]
AS
SELECT 
 permit_id,
company_id,
permit_type_id,
reklame_produk,
reklame_waktu_pasang,
jenis_reklame,
reklame_ukuran
FROM 
  dbo.t_permit_REKLAME ;
GO
/****** Object:  Table [dbo].[t_permit_IPPT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IPPT](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[pemilik_tanah] [varchar](255) NULL,
	[no_sertifikat] [varchar](255) NULL,
	[luas_tanah] [decimal](16, 2) NULL,
	[tanah_untuk] [varchar](255) NULL,
	[batas_utara] [varchar](255) NULL,
	[batas_timur] [varchar](255) NULL,
	[batas_selatan] [varchar](255) NULL,
	[batas_barat] [varchar](255) NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[no_seri_sertifikat] [varchar](50) NULL,
	[ippt_ditarik_nomor] [varchar](255) NULL,
	[memperhatikan] [varchar](255) NULL,
	[memperhatikan2] [varchar](255) NULL,
	[memperhatikan3] [varchar](255) NULL,
	[memperhatikan4] [varchar](255) NULL,
	[memperhatikan5] [varchar](255) NULL,
	[memperhatikan6] [varchar](255) NULL,
	[memperhatikan7] [varchar](255) NULL,
	[memperhatikan8] [varchar](255) NULL,
	[atas_nama] [varchar](255) NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
	[nomor_BAP] [varchar](50) NULL,
	[ippt_ditarik_tanggal] [varchar](30) NULL,
	[ippt_ditarik_nama] [varchar](30) NULL,
	[status_survey_id] [smallint] NULL,
	[ippt_type_id] [int] NULL,
 CONSTRAINT [PK__t_permit_IPPT__17036CC0] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_IPPT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_t_permit_IPPT]
AS

SELECT 
  permit_id,
  company_id,
  permit_type_id,
  no_sertifikat,
  pemilik_tanah,
  luas_tanah,
  [address],
  kecamatan_id,
  desa_id,
  ippt_type_id
FROM 
  dbo.t_permit_IPPT ;
GO
/****** Object:  Table [dbo].[t_permit_trayek]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_trayek](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[business_kind] [varchar](255) NULL,
	[trayek_klasifikasi_id] [bigint] NULL,
	[ijin_trayek_type_id] [smallint] NULL,
	[total_biaya] [varchar](30) NULL,
	[kegiatan_usaha] [varchar](255) NULL,
	[kelembagaan] [varchar](255) NULL,
	[KELOMPOK_ID] [varchar](15) NULL,
	[bidang_usaha] [varchar](255) NULL,
	[jenis_kendaraan] [varchar](255) NULL,
	[merk] [varchar](255) NULL,
	[tahun_pembuatan] [varchar](255) NULL,
	[nomor_kendaraan] [varchar](255) NULL,
	[nomor_chasis] [varchar](255) NULL,
	[nomor_mesin] [varchar](255) NULL,
	[nomor_urut_trayek] [varchar](255) NULL,
	[letter_date] [datetime] NULL,
	[ijin_trayek_id] [smallint] NULL,
	[jalan_id] [char](10) NULL,
	[No_induk_perusahaan] [varchar](30) NULL,
	[No_Uji] [varchar](50) NULL,
	[daya_angkut_orang] [char](30) NULL,
	[daya_angkut_barang] [char](30) NULL,
	[kode_trayek_yg_dilalui] [varchar](30) NULL,
	[No_Surat_Rekomendasi] [varchar](15) NULL,
	[tgl_surat_rekomendasi] [varchar](15) NULL,
	[trayek_rute] [varchar](100) NULL,
	[no_sertifikat] [varchar](50) NULL,
	[sk_tidak_berlaku] [varchar](25) NULL,
	[tanggal_sk_tidak_berlaku] [datetime] NULL,
	[status_survey_id] [smallint] NULL,
	[surat_dishub_nomor] [varchar](50) NULL,
	[surat_dishub_tanggal] [datetime] NULL,
	[nomor_BAP] [varchar](30) NULL,
	[nomor_urut_BAP] [varchar](20) NULL,
	[tanggal_BAP] [datetime] NULL,
	[petugas_survey_dishub] [varchar](20) NULL,
	[nip_petugas_survey_dishub] [varchar](30) NULL,
	[denda] [varchar](20) NULL,
 CONSTRAINT [PK__t_permit_trayek__4F47C5E3] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_trayek]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_trayek]
AS
SELECT 
  permit_id,
  company_id,
  merk,
  tahun_pembuatan,
  nomor_kendaraan,
  No_induk_perusahaan,
  No_Uji,
  daya_angkut_orang,
  daya_angkut_barang,
  kode_trayek_yg_dilalui,
  trayek_rute,
  surat_dishub_nomor,
  surat_dishub_tanggal
FROM 
  dbo.t_permit_trayek ;
GO
/****** Object:  Table [dbo].[t_permit_siup]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_siup](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[business_kind] [varchar](255) NULL,
	[siup_type_id] [smallint] NULL,
	[siup_golongan_usaha_id] [smallint] NULL,
	[total] [bigint] NULL,
	[kegiatan_usaha] [varchar](255) NULL,
	[kbli1] [varchar](50) NULL,
	[kbli2] [varchar](5) NULL,
	[kbli3] [varchar](5) NULL,
	[kbli4] [varchar](50) NULL,
	[kbli_tambahan] [varchar](50) NULL,
	[kelembagaan] [varchar](255) NULL,
	[jenis_dagangan] [varchar](1000) NULL,
	[jenis_dagangan2] [varchar](255) NULL,
	[jenis_dagangan3] [varchar](255) NULL,
	[jenis_dagangan4] [varchar](255) NULL,
	[jenis_dagangan5] [varchar](255) NULL,
	[jenis_dagangan6] [varchar](255) NULL,
	[jenis_dagangan7] [varchar](255) NULL,
	[jenis_dagangan8] [varchar](255) NULL,
	[jenis_dagangan9] [varchar](255) NULL,
	[jenis_dagangan10] [varchar](255) NULL,
	[modal] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[kode] [varchar](5) NULL,
	[tenaga_kerja] [varchar](50) NULL,
	[no_seri_sertifikat] [varchar](50) NULL,
	[status_survey_id] [smallint] NULL,
 CONSTRAINT [PK__t_permit_siup__3F115E1A] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_permit_group]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_permit_group](
	[permit_group_id] [smallint] NOT NULL,
	[permit_group_name] [varchar](255) NULL,
	[SPM] [smallint] NULL,
	[ket1] [varchar](50) NULL,
	[ket2] [varchar](50) NULL,
	[ket3] [varchar](50) NULL,
	[permit_group_name2] [varchar](255) NULL,
 CONSTRAINT [d_permit_group_pk] PRIMARY KEY CLUSTERED 
(
	[permit_group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_siup_golongan_usaha]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_siup_golongan_usaha](
	[siup_golongan_usaha_id] [smallint] NOT NULL,
	[siup_golongan_usaha] [varchar](50) NULL,
	[siup_cost] [bigint] NULL,
	[code] [varchar](50) NULL,
 CONSTRAINT [d_siup_golongan_usaha_pk] PRIMARY KEY CLUSTERED 
(
	[siup_golongan_usaha_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[penomoran_SK]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[penomoran_SK] 
( @tanggal_sk datetime, @nomor_urut varchar(10), @permit_group_id int, @permit_id bigint)
RETURNS varchar(30)
AS
BEGIN
  DECLARE @hasil varchar(30);

	DECLARE @vDate datetime
	DECLARE @vID varchar(50)
	DECLARE @vNumber  varchar(6)
	DECLARE @vMonth varchar(4)
	DECLARE @vMonthbap varchar(4)
	DECLARE @vYear varchar(4)
	DECLARE @vYearbap varchar(4)
	DECLARE @vPrint_date datetime
	DECLARE @vBap_date datetime
	DECLARE @vBAP_number varchar(4)
	DECLARE @v_ket1 varchar(10), @v_ket2 varchar(10), @v_ket3 varchar(10) ;
    
    SET @vMonth = dbo.angka_romawi( month(@tanggal_sk) );    
    SET @vYear = cast( year(@tanggal_sk) as varchar);

	SELECT @v_ket1 = ket1, @v_ket2 = ket2, @v_ket3 = ket3
	FROM d_permit_group
	WHERE permit_group_id = @permit_group_id

    IF (@permit_group_id <> 10) 
		AND (@permit_group_id <> 13) 
		AND (@permit_group_id <> 16) 
     SET @hasil = @v_ket1 + @nomor_urut + @v_ket2 + @v_ket3 + @vMonth + '/' + @vYear ;

-- berikut ini untuk penomoran ijin khusus (10, 13, 16)
    ELSE IF (@permit_group_id = 13)  -- SIUP
	 begin    
		DECLARE @vCode varchar(10);
		SELECT @vCode = b.code
		FROM t_permit_siup a
		LEFT OUTER JOIN d_siup_golongan_usaha b ON a.siup_golongan_usaha_id = b.siup_golongan_usaha_id
		WHERE permit_id = @permit_id ;
		SET @hasil = @v_ket1 + @nomor_urut  + @v_ket3 + @vCode + '/' + @vMonth + '/' + @vYear ;
	 end 

    --ELSE IF (@permit_group_id = 16)  -- TDP
	-- begin
	--	SET @hasil = dbo.penomoran_TDP(@permit_id);
	-- end 
    -- Untuk sementara tidak di aktifkan, mulai aktif lagi awal tahun depan-- 
    
    ELSE IF (@permit_group_id = 10)  -- IUJK
	 begin
		SET @hasil = dbo.penomoran_iujk(@permit_id);
	 end      
-- ***
  
  RETURN @hasil; 
  
END
GO
/****** Object:  Table [dbo].[m_company_detail]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[m_company_detail](
	[permit_id] [bigint] IDENTITY(1,1) NOT NULL,
	[company_id] [bigint] NULL,
	[permit_group_id] [smallint] NULL,
	[edit_link] [varchar](255) NULL,
	[edit_txt] [varchar](50) NULL,
	[ketetapan_retribusi] [varchar](255) NULL,
	[cetak_sk_link] [varchar](255) NULL,
	[cetak_sk_txt] [varchar](50) NULL,
	[foto] [varchar](255) NULL,
	[ket] [varchar](255) NULL,
	[strd_retribusi_kurang_bayar] [bigint] NULL,
	[strd_sanksi_administrasi] [bigint] NULL,
	[strd_link] [varchar](255) NULL,
	[strd_txt] [varchar](255) NULL,
	[tanggal_keluar_surat_rekomendasi] [varchar](255) NULL,
	[status_ijin_id] [int] NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_BAP] [varchar](50) NULL,
	[tanggal_perhitungan] [datetime] NULL,
	[tanggal_bayar] [datetime] NULL,
	[tanggal_SK] [datetime] NULL,
	[tanggal_paraf_kasubid_1] [datetime] NULL,
	[tanggal_paraf_kasubid_2] [datetime] NULL,
	[tanggal_paraf_kabid] [datetime] NULL,
	[tanggal_paraf_sekretaris] [datetime] NULL,
	[tanggal_TTD_kepala] [datetime] NULL,
	[tanggal_pengambilan_SK] [datetime] NULL,
	[tanggal_masuk_surat_rekomendasi] [varchar](255) NULL,
	[tanggal_habis_berlaku] [datetime] NULL,
	[retribusi] [bigint] NULL,
	[denda] [bigint] NULL,
	[tanggal_jatuh_tempo] [datetime] NULL,
	[nomor_urut] [varchar](30) NULL,
	[nomor_sk] [varchar](255) NULL,
	[tanggal_register] [datetime] NULL,
	[view_link] [varchar](255) NULL,
	[view_txt] [varchar](255) NULL,
	[no_tbp] [varchar](50) NULL,
	[no_skrd] [varchar](50) NULL,
	[tanggal_setor_retribusi] [datetime] NULL,
	[tanggal_setor] [datetime] NULL,
	[keringanan] [decimal](18, 2) NULL,
	[status_survey_id] [smallint] NULL,
	[input_link] [varchar](255) NULL,
	[input_txt] [varchar](255) NULL,
	[status_rekomendasi_id] [smallint] NULL,
	[tanggal_rekomendasi] [datetime] NULL,
	[tanggal_kajian] [datetime] NULL,
	[tanggal_tolak] [datetime] NULL,
	[nomor_izin_ditarik] [varchar](30) NULL,
	[nama_izin_ditarik] [varchar](30) NULL,
	[tanggal_izin_ditarik] [varchar](30) NULL,
	[nomor_blanko_sk] [varchar](30) NULL,
	[status_persyaratan_id] [int] NULL,
	[status_proses_id] [int] NULL,
 CONSTRAINT [PK__m_compan__38E9A2247F4BDEC0] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_detail_sekretaris]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_sekretaris]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  tanggal_paraf_sekretaris
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_rekomendasi]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_rekomendasi]
AS
SELECT permit_id, company_id, permit_group_id, status_rekomendasi_id, tanggal_rekomendasi, tanggal_BAP, tanggal_kajian, tanggal_bayar, tanggal_SK, 
               tanggal_pengambilan_SK, tanggal_paraf_kasubid_1, tanggal_paraf_kasubid_2, tanggal_paraf_kabid
FROM  dbo.m_company_detail AS a
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 201
               Right = 334
            End
            DisplayFlags = 280
            TopColumn = 21
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_detail_rekomendasi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_detail_rekomendasi'
GO
/****** Object:  View [dbo].[vw_detail_register]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_register]
AS
SELECT 
  a.permit_id,
  a.company_id,
  a.permit_group_id,
  a.cetak_sk_link,
  a.cetak_sk_txt,        
  a.tanggal_register,
  a.tanggal_SK,
  a.tanggal_habis_berlaku,
  a.nomor_urut,
  a.nomor_sk,     
  a.nomor_izin_ditarik,
  a.nama_izin_ditarik,
  a.tanggal_izin_ditarik,
  a.nomor_blanko_sk
  
FROM 
  dbo.m_company_detail a;
GO
/****** Object:  View [dbo].[vw_detail_pengambilan]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_pengambilan]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  edit_link,
  edit_txt 
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_pendaftaran]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_pendaftaran]
as
SELECT 
  permit_id,
  company_id,
  permit_group_id
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_mb]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_mb]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_kepala]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_kepala]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  tanggal_TTD_kepala
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_kajian_1]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_kajian_1]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  d_status_persyaratan,
  edit_link,
  edit_txt 
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_kajian]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_kajian]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  d_status_proses,
  edit_link,
  edit_txt 
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_kabid]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_kabid]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  tanggal_paraf_kabid
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_input_data]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_input_data]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  INPUT_link,
  INPUT_txt 
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_fo]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_fo]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id 
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  View [dbo].[vw_detail_bendahara]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_bendahara]
AS
SELECT 
  permit_id,    
  company_id,
  permit_group_id,
  strd_link,
  strd_txt,
  tanggal_bayar,
  retribusi,
  denda,
  tanggal_jatuh_tempo,
  tanggal_perhitungan,
  no_tbp,
  no_skrd
  
 FROM 
  dbo.m_company_detail 
  WHERE permit_group_id = 3
  OR permit_group_id = 1
  OR permit_group_id = 2
  OR permit_group_id = 17
GO
/****** Object:  View [dbo].[vw_detail_arsip]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_arsip]
AS
SELECT 
  permit_id,
  company_id,
  permit_group_id,
  status_persyaratan_id
FROM 
  dbo.m_company_detail ;
GO
/****** Object:  Table [dbo].[t_permit_IPEMAT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IPEMAT](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[lokasi] [varchar](255) NULL,
	[spesifikasi1] [varchar](500) NULL,
	[spesifikasi2] [varchar](500) NULL,
	[spesifikasi3] [varchar](500) NULL,
	[spesifikasi4] [varchar](500) NULL,
	[spesifikasi5] [varchar](500) NULL,
	[spesifikasi6] [varchar](500) NULL,
	[kegiatan] [varchar](255) NULL,
	[atas_nama] [varchar](255) NULL,
	[petugas_id] [int] NULL,
	[status_survey_id] [smallint] NULL,
	[nomor_BAP] [varchar](20) NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
 CONSTRAINT [t_permit_IPEMAT_pk] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[VW_t_permit_IPEMAT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_t_permit_IPEMAT]
AS
SELECT 
  permit_id,
  company_id,
  nomor_pendaftaran,
  permit_type_id,
  kegiatan
FROM 
  dbo.t_permit_IPEMAT ;
GO
/****** Object:  Table [dbo].[t_permit_IPAT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IPAT](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[kegiatan] [varchar](255) NULL,
	[lokasi] [varchar](255) NULL,
	[spesifikasi1] [varchar](500) NULL,
	[spesifikasi2] [varchar](500) NULL,
	[spesifikasi3] [varchar](500) NULL,
	[spesifikasi4] [varchar](500) NULL,
	[spesifikasi5] [varchar](500) NULL,
	[spesifikasi6] [varchar](500) NULL,
	[atas_nama] [varchar](255) NULL,
	[petugas_id] [int] NULL,
	[status_survey_id] [smallint] NULL,
	[nomor_BAP] [varchar](20) NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
	[tanggal_BAP] [datetime] NULL,
 CONSTRAINT [PK__t_permit_IPAT__0D7A0286] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[VW_t_permit_IPAT]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_t_permit_IPAT]
AS
SELECT 
  permit_id,
  company_id,
  nomor_pendaftaran,
  permit_type_id,
  kegiatan
FROM 
  dbo.t_permit_IPAT ;
GO
/****** Object:  Table [dbo].[t_permit_imb_2012]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_imb_2012](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[letter_number] [varchar](255) NULL,
	[business_kind] [varchar](255) NULL,
	[luas] [real] NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[ukuran] [varchar](255) NULL,
	[sertifikat] [varchar](255) NULL,
	[pondasi] [varchar](255) NULL,
	[tiang] [varchar](255) NULL,
	[dinding] [varchar](255) NULL,
	[lantai] [varchar](255) NULL,
	[kerangka] [varchar](255) NULL,
	[usuk] [varchar](255) NULL,
	[reng] [varchar](255) NULL,
	[atap] [varchar](255) NULL,
	[langit] [varchar](255) NULL,
	[lain] [varchar](255) NULL,
	[pemilik_nama] [varchar](255) NULL,
	[letak_bangunan_luar] [varchar](255) NULL,
	[dari_sumbu_jalan] [varchar](255) NULL,
	[nop] [varchar](255) NULL,
	[letter_date] [datetime] NULL,
	[imb_type_id] [smallint] NULL,
	[it] [decimal](16, 3) NULL,
	[xyz] [datetime] NULL,
	[hsbg_id] [smallint] NULL,
	[if_id] [smallint] NULL,
	[ikl_kbg_id] [smallint] NULL,
	[ikl_kepemilikan_id] [smallint] NULL,
	[ikl_ket_bg_id] [smallint] NULL,
	[ikl_kompleksitas_id] [smallint] NULL,
	[ikl_permanensi_id] [smallint] NULL,
	[ikl_rk_id] [smallint] NULL,
	[ikl_zg_id] [smallint] NULL,
	[iw_id] [smallint] NULL,
	[imb_jenis_id] [int] NULL,
	[IKL] [float] NULL,
	[tahun_pembuatan] [int] NULL,
	[petugas2] [varchar](50) NULL,
	[nip_surveyor] [varchar](50) NULL,
	[atas_nama] [varchar](255) NULL,
	[memperhatikan] [varchar](255) NULL,
	[memperhatikan3] [varchar](255) NULL,
	[memperhatikan4] [varchar](255) NULL,
	[memperhatikan5] [varchar](255) NULL,
	[memperhatikan6] [varchar](255) NULL,
	[memperhatikan7] [varchar](255) NULL,
	[memperhatikan8] [varchar](255) NULL,
	[memperhatikan9] [varchar](255) NULL,
	[ket_fungsi_bangunan] [varchar](255) NULL,
	[RAB] [bigint] NULL,
	[imb_rab_id] [int] NULL,
	[nomor_urut_SK] [smallint] NULL,
	[nomor_urut_BAP] [varchar](30) NULL,
	[sertifikat_tanah] [varchar](255) NULL,
	[no_ippt] [varchar](255) NULL,
	[imb_tidak_berlaku] [varchar](255) NULL,
	[tgl_ippt] [varchar](30) NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_BAP] [varchar](50) NULL,
	[nama_ippt] [varchar](30) NULL,
	[status_survey_id] [smallint] NULL,
	[petugas_id] [varchar](50) NULL,
	[petugas3] [varchar](50) NULL,
 CONSTRAINT [PK__t_permit_imb_201__02084FDA] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_imb_2012]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_t_permit_imb_2012]
as
SELECT 
  permit_id,
  company_id,
  business_kind,
  luas,
  [address],
  kecamatan_id,
  desa_id,
  pemilik_nama,
  nop,
  sertifikat_tanah,
  no_ippt,
  tgl_ippt,
  nama_ippt
FROM 
  dbo.t_permit_imb_2012 ;
GO
/****** Object:  Table [dbo].[t_permit_ho_p]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_ho_p](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[business_kind] [varchar](255) NULL,
	[ho_type_id] [smallint] NULL,
	[luas] [decimal](16, 2) NULL,
	[luas_penambahan] [decimal](16, 2) NULL,
	[nama_pemilik_tanah] [varchar](255) NULL,
	[sertifikat_tanah] [varchar](255) NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[ho_Index_Lokasi_id] [smallint] NULL,
	[ho_Index_Gangguan_id] [smallint] NULL,
	[ho_Index_Luas_id] [smallint] NULL,
	[ig_milik] [varchar](50) NULL,
	[no_seri_sertifikat] [varchar](50) NULL,
	[tahun_keterlambatan] [int] NULL,
	[ho_index_luas_penambahan] [smallint] NULL,
	[ig_nomor] [varchar](50) NULL,
	[ket] [smallint] NULL,
	[ig_tanggal] [datetime] NULL,
	[petugas_id] [int] NULL,
	[status_survey_id] [smallint] NULL,
	[petugas2] [varchar](50) NULL,
	[petugas3] [varchar](50) NULL,
	[nomor_urut_BAP] [varchar](10) NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_BAP] [varchar](50) NULL,
 CONSTRAINT [PK__t_permit_ho_p__7E37BEF6] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[VW_t_permit_ho_p]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_t_permit_ho_p]
AS
SELECT 
  permit_id,
  company_id,
  ig_nomor,
  ig_milik,
  ig_tanggal,
  [address],
  kecamatan_id, 
  desa_id
FROM 
  dbo.t_permit_ho_p ;
GO
/****** Object:  Table [dbo].[t_permit_ho_jenis]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_ho_jenis](
	[permit_jenis_id] [bigint] IDENTITY(1,1) NOT NULL,
	[permit_id] [bigint] NOT NULL,
	[ho_type_id] [smallint] NULL,
	[business_kind] [varchar](255) NULL,
	[ho_Index_Lokasi_id] [smallint] NULL,
	[ho_Index_Gangguan_id] [smallint] NULL,
	[luas] [decimal](16, 2) NULL,
	[tahun_keterlambatan] [int] NULL,
 CONSTRAINT [t_permit_ho_detail_pk] PRIMARY KEY CLUSTERED 
(
	[permit_jenis_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_ho]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_ho](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[business_kind] [varchar](255) NULL,
	[ho_type_id] [smallint] NULL,
	[total_male_local_labor] [varchar](50) NULL,
	[total_female_local_labor] [varchar](50) NULL,
	[total_male_foreign_labor] [varchar](50) NULL,
	[total_female_foreign_labor] [varchar](50) NULL,
	[luas] [decimal](16, 2) NULL,
	[luas_penambahan] [decimal](16, 2) NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[batas_utara] [varchar](255) NULL,
	[batas_timur] [varchar](255) NULL,
	[batas_selatan] [varchar](255) NULL,
	[batas_barat] [varchar](255) NULL,
	[letter_date] [datetime] NULL,
	[ho_Index_Lokasi_id] [smallint] NULL,
	[ho_Index_Gangguan_id] [smallint] NULL,
	[ho_Index_Luas_id] [smallint] NULL,
	[tinggi] [varchar](25) NULL,
	[pelimpahan_dari] [varchar](50) NULL,
	[nama] [varchar](50) NULL,
	[no_sk_lama] [varchar](50) NULL,
	[no_sk_du] [varchar](50) NULL,
	[tgl_sk_du] [datetime] NULL,
	[rekomendasi_date] [varchar](255) NULL,
	[no_seri_sertifikat] [varchar](50) NULL,
	[tahun_keterlambatan] [int] NULL,
	[ho_index_luas_penambahan] [smallint] NULL,
	[atas_nama] [varchar](255) NULL,
	[memperhatikan] [varchar](500) NULL,
	[memperhatikan3] [varchar](255) NULL,
	[memperhatikan4] [varchar](255) NULL,
	[memperhatikan5] [varchar](255) NULL,
	[memperhatikan6] [varchar](255) NULL,
	[memperhatikan7] [varchar](255) NULL,
	[memperhatikan8] [varchar](255) NULL,
	[memperhatikan9] [varchar](255) NULL,
	[memperhatikan10] [varchar](255) NULL,
	[sertifikat_tanah] [varchar](255) NULL,
	[nama_pemilik_tanah] [varchar](255) NULL,
	[no_ippt] [varchar](255) NULL,
	[no_imb] [varchar](255) NULL,
	[ho_tidak_berlaku] [varchar](255) NULL,
	[tgl_ippt] [datetime] NULL,
	[imb_nama] [varchar](255) NULL,
	[nip_petugas_survey_1] [varchar](50) NULL,
	[nama_petugas_survey_2] [varchar](50) NULL,
	[nip_petugas_survey_2] [varchar](50) NULL,
	[nama_petugas_survey_3] [varchar](50) NULL,
	[nip_petugas_survey_3] [varchar](50) NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_BAP] [varchar](50) NULL,
	[nomor_urut_BAP] [varchar](30) NULL,
	[status_survey_id] [smallint] NULL,
	[ig_untuk] [varchar](50) NULL,
	[ho_tidak_berlaku_nama] [varchar](50) NULL,
	[ho_tidak_berlaku_tanggal] [datetime] NULL,
	[petugas_id] [int] NULL,
 CONSTRAINT [t_permit_ho_pk] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_ho]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_t_permit_ho]
AS
SELECT 
  a.permit_id,
  a.sertifikat_tanah,
  a.nama_pemilik_tanah, 
  a.no_ippt,
  a.no_imb,
  a.imb_nama,
  a.ho_tidak_berlaku,
  a.[address], 
  a.kecamatan_id,                       
  a.desa_id,
  a.ig_untuk  
FROM 
  dbo.t_permit_ho a ;
GO
/****** Object:  UserDefinedFunction [dbo].[penomoran_IUJK]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[penomoran_IUJK] ( @permit_id bigint)
RETURNS varchar(50)                    
AS
BEGIN
  DECLARE @hasil varchar(50);      
    
	DECLARE @vDate datetime
	DECLARE @vNumber  varchar(10)
	DECLARE @vCompany_id varchar(50)
	DECLARE @vJenis_usaha_id varchar(4)


	SELECT @vCompany_id = a.company_id, @vJenis_usaha_id = cast(a.jenis_usaha_id as varchar)
	FROM t_permit_iujk a
    WHERE a.permit_id = @permit_id    

	SELECT  @vNumber =
	  CASE
	   WHEN (ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1) / 10 >= 1000
	    THEN rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1) / 10 >= 100
	    THEN '0' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)))        	
	   WHEN (ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1) / 10 >= 10
	    THEN '00' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1) / 10 >= 1
	    THEN '000' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)/ 10 = 0
        THEN '0000' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,17,5)) + 0,0) + 1)))
	  END
	FROM m_company_detail	
    WHERE permit_group_id = 10
/*
	UPDATE t_permit_IUJK
	 SET permit_number = '1-' + dbo.get_company_code_IUJK(@vCompany_id,@vJenis_usaha_id)  + '-3306-' + @vJenis_usaha_id  + '-' + @vNumber
     --  , expired_date = DateAdd(year,3,@vPrint_date)
	WHERE permit_id = @permit_id
	AND (permit_number is null or permit_number = '')
*/
  SET @hasil = '1-' + dbo.get_company_code_IUJK(@vCompany_id,@vJenis_usaha_id)  + '-3306-' + @vJenis_usaha_id  + '-' + @vNumber ;
  
  RETURN @hasil;
END
GO
/****** Object:  Table [dbo].[m_company_subdetail_rekomendasi]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[m_company_subdetail_rekomendasi](
	[rekomendasi_id] [bigint] IDENTITY(1,1) NOT NULL,
	[permit_id] [bigint] NULL,
	[skpd_teknis_id] [smallint] NULL,
	[tanggal_surat_kirim] [datetime] NULL,
	[tanggal_surat_rekomendasi] [datetime] NULL,
	[nomor_surat_kirim] [varchar](25) NULL,
	[cq1] [varchar](255) NULL,
	[cq2] [varchar](255) NULL,
	[cq3] [varchar](255) NULL,
	[tanggal_permintaan_rekomendasi] [datetime] NULL,
	[nomor_surat_rekomendasi] [varchar](30) NULL,
	[nomor_urut_memperhatikan] [varchar](30) NULL,
	[nomor_urut_surat] [varchar](10) NULL,
	[lampiran] [varchar](50) NULL,
	[surat_teknis_untuk] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[rekomendasi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[m_company]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[m_company](
	[company_id] [bigint] IDENTITY(1,1) NOT NULL,
	[company_number] [varchar](50) NULL,
	[input_date] [datetime] NULL,
	[ket_company_name] [varchar](255) NULL,
	[company_name] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[address] [varchar](255) NULL,
	[company_type_id] [smallint] NULL,
	[certificate_number] [varchar](255) NULL,
	[tanggal_pendirian] [datetime] NULL,
	[desc_permit] [varchar](255) NULL,
	[NPWP] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[fax] [varchar](50) NULL,
	[modal] [varchar](50) NULL,
	[bank1] [varchar](255) NULL,
	[bank2] [varchar](255) NULL,
	[company_status_id] [smallint] NULL,
	[kantor_pusat] [varchar](255) NULL,
	[pengesahan_pejabat_berwenang] [varchar](255) NULL,
	[produk] [varchar](255) NULL,
	[omset_pertahun] [varchar](50) NULL,
	[company_kedudukan_id] [smallint] NULL,
	[pemohon_name] [varchar](255) NULL,
	[pemohon_address] [varchar](255) NULL,
	[pemohon_ktp] [varchar](50) NULL,
	[pemohon_phone] [varchar](50) NULL,
	[pemohon_NPWP] [varchar](50) NULL,
	[pemohon_nationality_id] [smallint] NULL,
	[pusat_address] [varchar](255) NULL,
	[untuk] [varchar](255) NULL,
	[peta_lokasi] [varchar](255) NULL,
	[peta_situasi] [varchar](255) NULL,
	[tanggal_turun] [datetime] NULL,
	[tanggal_pengambilan] [datetime] NULL,
	[nama_pengambil] [varchar](255) NULL,
	[nomor_id_pengambil] [varchar](255) NULL,
	[KTP] [varchar](255) NULL,
	[nomor_tlp_pengambil] [varchar](20) NULL,
	[atas_nama] [varchar](50) NULL,
	[alamat_pengambil] [varchar](50) NULL,
	[status_berkas_id] [smallint] NULL,
	[tgl_mb_pendaftaran] [datetime] NULL,
	[tgl_mb_inputdata] [datetime] NULL,
	[tgl_mb_kajian1] [datetime] NULL,
	[tgl_mb_rekomendasi] [datetime] NULL,
	[tgl_mb_surveyor] [datetime] NULL,
	[tgl_mb_kajian2] [datetime] NULL,
	[tgl_mb_register] [datetime] NULL,
	[tgl_mb_kabid] [datetime] NULL,
	[tgl_mb_sekretaris] [datetime] NULL,
	[tgl_mb_kepala] [datetime] NULL,
	[tgl_mb_pengambilan] [datetime] NULL,
	[tgl_mb_arsip] [datetime] NULL,
	[status_mb_pendaftaran] [varchar](50) NULL,
	[status_mb_inputdata] [varchar](50) NULL,
	[status_mb_kajian1] [varchar](50) NULL,
	[status_mb_rekomendasi] [varchar](50) NULL,
	[status_mb_surveyor] [varchar](50) NULL,
	[status_mb_kajian2] [varchar](50) NULL,
	[status_mb_register] [varchar](50) NULL,
	[status_mb_kabid] [varchar](50) NULL,
	[status_mb_sekretaris] [varchar](50) NULL,
	[status_mb_kepala] [varchar](50) NULL,
	[status_mb_pengambilan] [varchar](50) NULL,
	[status_mb_arsip] [varchar](50) NULL,
	[tgl_mb_bendahara] [datetime] NULL,
	[status_mb_bendahara] [varchar](50) NULL,
 CONSTRAINT [PK_m_company] PRIMARY KEY CLUSTERED 
(
	[company_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_company_bendahara]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_bendahara]
as
SELECT 
  a.company_id,
  a.company_number,
  a.input_date,
  a.ket_company_name,
  a.company_name,
  a.kecamatan_id,
  a.desa_id,
  a.[address], 
  a.pemohon_name,
  a.KTP,
  b.permit_group_id,
  b.retribusi,
  a.tgl_mb_bendahara
FROM 
  dbo.m_company a
  LEFT OUTER JOIN m_company_detail b ON a.company_id = b.company_id
  WHERE permit_group_id = 3
  OR permit_group_id = 1
  OR permit_group_id = 2
  OR permit_group_id = 17
GO
/****** Object:  Table [dbo].[Inisial]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inisial](
	[id_perusahaan] [char](10) NOT NULL,
	[perusahaan] [varchar](255) NULL,
	[perusahaan_induk] [varchar](255) NULL,
	[address] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[postcode] [varchar](255) NULL,
	[province] [varchar](255) NULL,
	[country] [varchar](255) NULL,
	[phone] [varchar](255) NULL,
	[fax] [varchar](255) NULL,
	[web] [varchar](255) NULL,
	[email] [varchar](255) NULL,
	[kepala] [varchar](255) NULL,
	[nip_kepala] [varchar](50) NULL,
	[pangkat_kepala] [varchar](255) NULL,
	[kasie_pelayanan] [varchar](255) NULL,
	[nip_kasie_pelayanan] [varchar](50) NULL,
	[kasie_pemrosesan] [varchar](255) NULL,
	[nip_kasie_pemrosesan] [varchar](50) NULL,
	[kasie_tu] [varchar](255) NULL,
	[nip_kasie_tu] [varchar](50) NULL,
	[kasie_data] [varchar](255) NULL,
	[nip_kasie_data] [varchar](50) NULL,
	[bendahara_tu] [varchar](255) NULL,
	[nip_bendahara_tu] [varchar](255) NULL,
	[kasie_perijinan] [varchar](255) NULL,
	[nip_kasie_perijinan] [varchar](50) NULL,
	[bendahara_penerima] [varchar](255) NULL,
	[nip_bendahara_penerima] [varchar](50) NULL,
 CONSTRAINT [Inisial_pk] PRIMARY KEY CLUSTERED 
(
	[id_perusahaan] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_trayek_type]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_trayek_type](
	[ijin_trayek_type_id] [bigint] NOT NULL,
	[trayek_type] [varchar](100) NULL,
	[koef] [real] NULL,
	[trayek_cost] [bigint] NULL,
	[code] [varchar](50) NULL,
 CONSTRAINT [d_trayek_type_pk] PRIMARY KEY CLUSTERED 
(
	[ijin_trayek_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_trayek_klasifikasi]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_trayek_klasifikasi](
	[trayek_klasifikasi_id] [bigint] NOT NULL,
	[trayek_klasifikasi] [varchar](250) NULL,
	[cost] [bigint] NULL,
 CONSTRAINT [d_trayek_klasifikasi_pk] PRIMARY KEY CLUSTERED 
(
	[trayek_klasifikasi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_tdp_type]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_tdp_type](
	[tdp_type_id] [smallint] NOT NULL,
	[tdp_type] [varchar](100) NULL,
	[koef] [real] NULL,
	[tdp_type_label] [varchar](50) NULL,
 CONSTRAINT [d_tdp_type_pk] PRIMARY KEY CLUSTERED 
(
	[tdp_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_tdp_cost]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[d_tdp_cost](
	[tdp_type_id] [smallint] NOT NULL,
	[company_type_id] [smallint] NOT NULL,
	[cost] [bigint] NULL,
 CONSTRAINT [PK_d_tdp_cost] PRIMARY KEY CLUSTERED 
(
	[tdp_type_id] ASC,
	[company_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[d_tdi_type]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_tdi_type](
	[tdi_type_id] [int] NOT NULL,
	[tdi_type] [varchar](50) NULL,
	[koef] [real] NULL,
	[tdi_type_label] [varchar](50) NULL,
 CONSTRAINT [d_tdi_type_pk] PRIMARY KEY CLUSTERED 
(
	[tdi_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_tahun]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[d_tahun](
	[tahun] [int] NOT NULL,
 CONSTRAINT [PK_d_tahun] PRIMARY KEY CLUSTERED 
(
	[tahun] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[d_status_survey]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_survey](
	[status_survey_id] [smallint] NOT NULL,
	[status_BAP] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_survey_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_status_rekomendasi]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_rekomendasi](
	[status_rekomendasi_id] [smallint] NOT NULL,
	[status_rekomendasi] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_rekomendasi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_status_proses]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_proses](
	[status_proses_id] [int] NOT NULL,
	[status_proses] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_proses_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_status_persyaratan]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_persyaratan](
	[status_persyaratan_id] [int] NOT NULL,
	[status_persyaratan] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_persyaratan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_status_ijin]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_ijin](
	[status_ijin_id] [smallint] NOT NULL,
	[status_ijin] [varchar](100) NULL,
	[status_survey_id] [smallint] NULL,
	[status_survey] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_ijin_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [d_status_ijin_uq] UNIQUE NONCLUSTERED 
(
	[status_survey_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_detail_surveyor]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_surveyor]
AS
SELECT 
  a.permit_id,
  a.company_id,
  a.permit_group_id,
  a.edit_link,
  a.edit_txt,
  c.status_survey_id,
  a.retribusi,
  a.strd_link,
  a.strd_txt
FROM 
  dbo.m_company_detail a
  LEFT OUTER JOIN dbo.t_permit_ho c ON a.permit_id = c.permit_id
  LEFT OUTER JOIN dbo.d_status_ijin b ON c.status_survey_id = b.status_survey_id;
GO
/****** Object:  Table [dbo].[d_status_berkas]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_status_berkas](
	[status_berkas_id] [int] NOT NULL,
	[status_berkas] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_berkas_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_skpd_teknis]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_skpd_teknis](
	[skpd_teknis_id] [smallint] IDENTITY(1,1) NOT NULL,
	[skpd_teknis] [varchar](255) NULL,
	[skpd_teknis_singkatan] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[skpd_teknis_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_siup_type]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_siup_type](
	[siup_type_id] [smallint] NOT NULL,
	[siup_type] [varchar](100) NULL,
	[koef] [real] NULL,
	[siup_type_label] [varchar](50) NULL,
 CONSTRAINT [d_siup_type_pk] PRIMARY KEY CLUSTERED 
(
	[siup_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_IUJK_detail]    Script Date: 12/15/2014 12:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IUJK_detail](
	[permit_id] [bigint] NULL,
	[permit_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sub_bidang_id] [int] NULL,
	[nomor_kode] [varchar](255) NULL,
	[tahun_pelaksanaan] [varchar](30) NULL,
	[nilai] [varchar](255) NULL,
	[klasifikasi] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[permit_detail_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_REKLAME_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_REKLAME_type](
	[type_id] [smallint] NOT NULL,
	[jenis_reklame] [varchar](255) NULL,
	[harga_dasar] [float] NULL,
	[lama_pasang] [varchar](50) NULL,
 CONSTRAINT [d_REKLAME_type_pk] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_petugas_survey]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_petugas_survey](
	[petugas_id] [int] NOT NULL,
	[nama_petugas] [varchar](30) NULL,
	[nip_petugas] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[petugas_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_permit_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_permit_type](
	[permit_type_id] [smallint] NOT NULL,
	[permit_type] [varchar](255) NULL,
	[koef] [real] NULL,
	[permit_type_label] [varchar](255) NULL,
	[permit_type_group_id] [smallint] NULL,
 CONSTRAINT [d_permit_type_pk] PRIMARY KEY CLUSTERED 
(
	[permit_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_nationality]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_nationality](
	[nationality_id] [smallint] NOT NULL,
	[nationality] [varchar](50) NULL,
 CONSTRAINT [d_nationality_pk] PRIMARY KEY CLUSTERED 
(
	[nationality_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_kualifikasi]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_kualifikasi](
	[kualifikasi_id] [int] NOT NULL,
	[kualifikasi] [varchar](255) NULL,
 CONSTRAINT [d_kualifikasi_pk] PRIMARY KEY CLUSTERED 
(
	[kualifikasi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klui_sub_golongan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klui_sub_golongan](
	[GOL_ID] [varchar](15) NULL,
	[SUB_GOL] [varchar](15) NOT NULL,
	[SUBGOLONGAN] [varchar](255) NULL,
 CONSTRAINT [d_klui_sub_golongan_pk] PRIMARY KEY CLUSTERED 
(
	[SUB_GOL] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klui_kategori]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klui_kategori](
	[KATEGORI_ID] [varchar](15) NOT NULL,
	[KATEGORI] [varchar](255) NULL,
 CONSTRAINT [d_klui_kategori_pk] PRIMARY KEY CLUSTERED 
(
	[KATEGORI_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klui_golongan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klui_golongan](
	[POKOK_ID] [varchar](255) NULL,
	[GOL_ID] [varchar](255) NOT NULL,
	[GOLONGAN] [varchar](255) NULL,
 CONSTRAINT [d_klui_golongan_pk] PRIMARY KEY CLUSTERED 
(
	[GOL_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klui_gol_pokok]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klui_gol_pokok](
	[KATEGORI_ID] [varchar](15) NULL,
	[POKOK_ID] [varchar](15) NOT NULL,
	[GOL_POKOK] [varchar](200) NULL,
 CONSTRAINT [d_klui_gol_pokok_pk] PRIMARY KEY CLUSTERED 
(
	[POKOK_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klasifikasi_jpk_sub_bidang]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klasifikasi_jpk_sub_bidang](
	[bidang_id] [int] NULL,
	[sub_bidang_id] [int] NOT NULL,
	[sub_bidang] [varchar](255) NULL,
	[keterangan] [varchar](255) NULL,
 CONSTRAINT [d_klasifikasi_jpk_sub_bidang_pk] PRIMARY KEY CLUSTERED 
(
	[sub_bidang_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klasifikasi_jpk_jenis_usaha]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klasifikasi_jpk_jenis_usaha](
	[jenis_usaha_id] [int] NOT NULL,
	[jenis_usaha] [varchar](100) NULL,
 CONSTRAINT [d_klasifikasi_jpk_jenis_usaha_pk] PRIMARY KEY CLUSTERED 
(
	[jenis_usaha_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_klasifikasi_jpk_bidang]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_klasifikasi_jpk_bidang](
	[bidang_id] [int] NOT NULL,
	[bidang] [varchar](255) NULL,
	[jenis_usaha_id] [int] NULL,
 CONSTRAINT [d_klasifikasi_jpk_bidang_pk] PRIMARY KEY CLUSTERED 
(
	[bidang_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_kki]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_kki](
	[kode_kki] [varchar](50) NOT NULL,
	[nama_kki] [varchar](255) NULL,
 CONSTRAINT [d_kki_pk] PRIMARY KEY CLUSTERED 
(
	[kode_kki] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_KECAMATAN]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_KECAMATAN](
	[kecamatan_id] [smallint] NOT NULL,
	[kecamatan] [varchar](50) NULL,
 CONSTRAINT [PK_d_KECAMATAN] PRIMARY KEY CLUSTERED 
(
	[kecamatan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_kbli_kelompok]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_kbli_kelompok](
	[SUB_GOL] [varchar](15) NULL,
	[KELOMPOK_ID] [varchar](15) NOT NULL,
	[KELOMPOK] [varchar](255) NULL,
 CONSTRAINT [d_kbli_kelompok_pk] PRIMARY KEY CLUSTERED 
(
	[KELOMPOK_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_kbli_golongan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_kbli_golongan](
	[POKOK_ID] [varchar](3) NULL,
	[GOL_ID] [varchar](4) NOT NULL,
	[GOLONGAN] [varchar](255) NULL,
 CONSTRAINT [d_kbli_golongan_pk] PRIMARY KEY CLUSTERED 
(
	[GOL_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_iui_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_iui_type](
	[iui_type_id] [smallint] NOT NULL,
	[iui_type] [varchar](50) NULL,
	[koef] [real] NULL,
	[iui_type_label] [varchar](50) NULL,
 CONSTRAINT [d_iui_type_pk] PRIMARY KEY CLUSTERED 
(
	[iui_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_iua_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_iua_type](
	[iua_type_id] [int] NOT NULL,
	[iua_type] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[iua_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_ippt_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_ippt_type](
	[ippt_type_id] [int] NOT NULL,
	[ippt_type] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ippt_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = OFF, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_waktu_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_waktu_2012](
	[iw_id] [smallint] NOT NULL,
	[waktu] [varchar](255) NULL,
	[index_waktu] [decimal](18, 2) NULL,
	[waktu_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_waktu_2012_pk] PRIMARY KEY CLUSTERED 
(
	[iw_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_type](
	[imb_type_id] [smallint] NOT NULL,
	[imb_type] [varchar](255) NULL,
	[koef] [decimal](24, 3) NULL,
	[imb_tittle] [varchar](255) NULL,
	[imb_desc] [varchar](255) NULL,
	[plus] [bigint] NULL,
	[koef_cetak] [varchar](50) NULL,
	[ket_cetak] [varchar](50) NULL,
 CONSTRAINT [d_imb_type_pk] PRIMARY KEY CLUSTERED 
(
	[imb_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_sarana_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_sarana_2012](
	[sarana_id] [smallint] NOT NULL,
	[bangunan] [varchar](255) NULL,
	[index_sarana] [decimal](16, 2) NULL,
	[jenis] [varchar](255) NULL,
 CONSTRAINT [d_imb_sarana_2012_pk] PRIMARY KEY CLUSTERED 
(
	[sarana_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_IMB_RAB]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_IMB_RAB](
	[imb_RAB_id] [int] NOT NULL,
	[IMB_RAB] [varchar](50) NULL,
	[indeks] [int] NULL,
	[batas_bawah] [bigint] NULL,
	[batas_atas] [bigint] NULL,
 CONSTRAINT [d_IMB_RAB_pk] PRIMARY KEY CLUSTERED 
(
	[imb_RAB_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_perubahan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_perubahan](
	[imb_perubahan_id] [int] NOT NULL,
	[imb_perubahan] [varchar](255) NULL,
	[koef] [decimal](10, 3) NULL,
	[imb_perubahan_koef_cetak] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[imb_perubahan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_jenis]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_jenis](
	[imb_jenis_id] [int] NOT NULL,
	[jenis_imb] [varchar](20) NULL,
	[kode_rekening] [varchar](50) NULL,
	[jenis_cetak] [varchar](50) NULL,
 CONSTRAINT [d_imb_jenis_pk] PRIMARY KEY CLUSTERED 
(
	[imb_jenis_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_zona_gempa_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_zona_gempa_2012](
	[ikl_zg_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_zona_gempa] [decimal](18, 3) NULL,
	[hasil] [decimal](18, 3) NULL,
	[zona_gempa_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_zona_gempa_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_zg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_resiko_kebakaran_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_resiko_kebakaran_2012](
	[ikl_rk_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_resiko_kebakaran] [decimal](18, 3) NULL,
	[hasil] [decimal](18, 3) NULL,
	[resiko_kebakaran_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_resiko_kebakaran_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_rk_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_permanensi_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_permanensi_2012](
	[ikl_permanensi_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_permanensi] [decimal](18, 3) NULL,
	[hasil] [decimal](18, 3) NULL,
	[permanensi_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_permanensi_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_permanensi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_kompleksitas_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_kompleksitas_2012](
	[ikl_kompleksitas_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](250) NULL,
	[index_kompleksitas] [decimal](18, 3) NULL,
	[hasil] [decimal](18, 3) NULL,
	[kompleksitas_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_kompleksitas_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_kompleksitas_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_ketinggian_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_ketinggian_2012](
	[ikl_ket_bg_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_ketinggian] [decimal](18, 2) NULL,
	[hasil] [decimal](18, 2) NULL,
	[ketinggian_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_ketinggian_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_ket_bg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_kepemilikan_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_kepemilikan_2012](
	[ikl_kepemilikan_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_kepemilikan] [decimal](18, 3) NULL,
	[hasil] [decimal](18, 3) NULL,
	[kepemilikan_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_kepemilikan_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_kepemilikan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_ikl_kb_gedung_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_ikl_kb_gedung_2012](
	[ikl_kbg_id] [smallint] NOT NULL,
	[parameter_bobot] [varchar](255) NULL,
	[index_kepadatan] [decimal](18, 2) NULL,
	[hasil] [decimal](18, 2) NULL,
	[kepadatan_gedung_cetak] [varchar](25) NULL,
 CONSTRAINT [d_imb_ikl_kb_gedung_2012_pk] PRIMARY KEY CLUSTERED 
(
	[ikl_kbg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_imb_2012_sarana]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_imb_2012_sarana](
	[permit_id] [bigint] NULL,
	[imb_sarana_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sarana_id] [smallint] NULL,
	[V] [decimal](8, 3) NULL,
	[hspbg_id] [smallint] NULL,
	[retribusi] [bigint] NULL,
	[tahun_pembuatan] [varchar](4) NULL,
	[if_id] [smallint] NULL,
	[imb_type_id] [smallint] NULL,
	[RAB] [bigint] NULL,
	[imb_rab_id] [int] NULL,
	[persen_cetak] [smallint] NULL,
	[sudah_ber_imb] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[imb_sarana_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_hspbg_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_hspbg_2012](
	[hspbg_id] [smallint] NOT NULL,
	[jenis_bangunan] [varchar](255) NULL,
	[satuan] [varchar](5) NULL,
	[hspbg] [smallmoney] NULL,
 CONSTRAINT [d_imb_hspbg_2012_pk] PRIMARY KEY CLUSTERED 
(
	[hspbg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_hsbg_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_hsbg_2012](
	[hsbg_id] [smallint] NOT NULL,
	[jenis_bangunan] [varchar](50) NULL,
	[satuan] [varchar](2) NULL,
	[hsbg] [smallmoney] NULL,
 CONSTRAINT [d_imb_hsbg_2012_pk] PRIMARY KEY CLUSTERED 
(
	[hsbg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_imb_2012_bangunan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_imb_2012_bangunan](
	[permit_id] [bigint] NULL,
	[imb_bangunan_id] [bigint] IDENTITY(1,1) NOT NULL,
	[nomor_lantai] [varchar](30) NULL,
	[luas] [decimal](8, 3) NULL,
	[hsbg_id] [smallint] NULL,
	[if_id] [smallint] NULL,
	[ikl_kbg_id] [smallint] NULL,
	[ikl_kepemilikan_id] [smallint] NULL,
	[ikl_ket_bg_id] [smallint] NULL,
	[ikl_kompleksitas_id] [smallint] NULL,
	[ikl_permanensi_id] [smallint] NULL,
	[ikl_rk_id] [smallint] NULL,
	[ikl_zg_id] [smallint] NULL,
	[iw_id] [smallint] NULL,
	[retribusi_belum_final] [decimal](16, 3) NULL,
	[It] [decimal](16, 3) NULL,
	[ikl] [decimal](16, 3) NULL,
	[ikljadi] [decimal](16, 3) NULL,
	[tahun_pembuatan] [int] NULL,
	[imb_type_id] [smallint] NULL,
	[persen_cetak] [smallint] NULL,
	[sudah_ber_imb] [varchar](255) NULL,
	[imb_perubahan_id] [int] NULL,
	[jumlah] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[imb_bangunan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_imb_fungsi_2012]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_imb_fungsi_2012](
	[if_id] [smallint] NOT NULL,
	[fungsi] [varchar](255) NULL,
	[index_fungsi] [decimal](18, 3) NULL,
	[fungsi_cetak] [varchar](255) NULL,
 CONSTRAINT [d_imb_fungsi_2012_pk] PRIMARY KEY CLUSTERED 
(
	[if_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_ho_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_ho_type](
	[ho_type_id] [smallint] NOT NULL,
	[ho_type] [varchar](100) NULL,
	[ho_type_label] [varchar](50) NULL,
	[koef] [decimal](16, 2) NULL,
	[kode] [varchar](5) NULL,
	[ho_type_label_laporan] [varchar](50) NULL,
 CONSTRAINT [d_ho_type_pk] PRIMARY KEY CLUSTERED 
(
	[ho_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_ho_index_luas]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_ho_index_luas](
	[ho_Index_Luas_id] [smallint] NOT NULL,
	[keterangan] [varchar](225) NULL,
	[index_luas] [decimal](16, 2) NULL,
 CONSTRAINT [d_ho_index_luas_pk] PRIMARY KEY CLUSTERED 
(
	[ho_Index_Luas_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_ho_index_lokasi]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_ho_index_lokasi](
	[ho_Index_Lokasi_id] [smallint] NOT NULL,
	[ho_Index_Lokasi] [varchar](50) NULL,
	[index_lokasi] [decimal](16, 2) NULL,
 CONSTRAINT [d_ho_index_lokasi_pk] PRIMARY KEY CLUSTERED 
(
	[ho_Index_Lokasi_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_ho_jenis_detail]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_permit_ho_jenis_detail](
	[permit_jenis_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[permit_jenis_id] [bigint] NULL,
	[permit_id] [bigint] NULL,
	[ho_type_id] [smallint] NULL,
	[luas] [decimal](16, 2) NULL,
	[total] [bigint] NULL,
	[ho_Index_Lokasi_id] [smallint] NULL,
	[ho_Index_Gangguan_id] [smallint] NULL,
	[ho_Index_Luas_Tarif] [int] NULL,
	[tahun_keterlambatan] [int] NULL,
	[tahun_pengali] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[permit_jenis_detail_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[d_ho_index_gangguan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_ho_index_gangguan](
	[ho_Index_Gangguan_id] [smallint] NOT NULL,
	[ho_Index_Gangguan] [varchar](255) NULL,
	[index_gangguan] [decimal](16, 2) NULL,
	[kode_rekening] [varchar](50) NULL,
 CONSTRAINT [d_ho_index_gangguan_pk] PRIMARY KEY CLUSTERED 
(
	[ho_Index_Gangguan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_DESA]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_DESA](
	[desa_id] [smallint] NOT NULL,
	[Kecamatan] [varchar](50) NULL,
	[Desa] [varchar](50) NULL,
	[Kode_Pos] [varchar](50) NULL,
	[kecamatan_id] [smallint] NULL,
 CONSTRAINT [PK_d_DESA] PRIMARY KEY CLUSTERED 
(
	[desa_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_company_type]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_company_type](
	[company_type_id] [smallint] NOT NULL,
	[company_type] [varchar](255) NULL,
	[code] [varchar](50) NULL,
	[company_type_name] [varchar](255) NULL,
	[tdp_code] [varchar](50) NULL,
	[company_type_label] [varchar](50) NULL,
	[company_type_label2] [varchar](255) NULL,
 CONSTRAINT [d_company_type_pk] PRIMARY KEY CLUSTERED 
(
	[company_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_Lap_IPPT]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_IPPT]
AS
SELECT YEAR(dbo.t_permit_IPPT.print_date) AS Tahun, MONTH(dbo.t_permit_IPPT.print_date) AS Bulan, dbo.d_DESA.Kecamatan, dbo.t_permit_IPPT.desa_id, 
               dbo.d_company_type.code AS jenis_perusahaan, dbo.m_company.company_name AS nama_perusahaan, dbo.m_company.pemohon_name AS nama_pemohon, 
               dbo.t_permit_IPPT.address AS alamat, dbo.m_company.input_date AS Tanggal_Daftar, dbo.t_permit_IPPT.print_date AS Tanggal_SK, 
               dbo.t_permit_IPPT.process_date AS Tanggal_Proses, dbo.t_permit_IPPT.expired_date AS Tanggal_Habis_Berlaku, 
               dbo.t_permit_IPPT.permit_number AS nomor_SK
FROM  dbo.t_permit_IPPT INNER JOIN
               dbo.m_company ON dbo.t_permit_IPPT.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.t_permit_IPPT.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_IPPT"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 289
               Bottom = 135
               Right = 563
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 611
               Bottom = 135
               Right = 818
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_IPPT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_IPPT'
GO
/****** Object:  View [dbo].[vw_Lap_IMB]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_IMB]
AS
SELECT YEAR(dbo.t_permit_imb_2012.print_date) AS Tahun, MONTH(dbo.t_permit_imb_2012.print_date) AS Bulan, dbo.d_DESA.Kecamatan, 
               dbo.t_permit_imb_2012.desa_id, dbo.t_permit_imb_2012.imb_type_id, dbo.d_company_type.code AS jenis_perusahaan, 
               dbo.m_company.company_name AS nama_perusahaan, dbo.m_company.pemohon_name AS nama_pemohon, dbo.t_permit_imb_2012.address AS alamat, 
               dbo.m_company.input_date AS Tanggal_Daftar, dbo.t_permit_imb_2012.print_date AS Tanggal_SK, dbo.t_permit_imb_2012.process_date AS Tanggal_Proses, 
               dbo.t_permit_imb_2012.expired_date AS Tanggal_Habis_Berlaku, dbo.t_permit_imb_2012.permit_number AS nomor_SK, dbo.t_permit_imb_2012.total AS retribusi, 
               dbo.t_permit_imb_2012.denda, dbo.t_permit_imb_2012.business_kind AS peruntukan
FROM  dbo.t_permit_imb_2012 INNER JOIN
               dbo.m_company ON dbo.t_permit_imb_2012.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.t_permit_imb_2012.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_imb_2012"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 301
               Bottom = 135
               Right = 575
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 623
               Bottom = 135
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_IMB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_IMB'
GO
/****** Object:  View [dbo].[vw_Lap_HO_P]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_HO_P]
AS
SELECT YEAR(dbo.t_permit_ho_p.print_date) AS Tahun, MONTH(dbo.t_permit_ho_p.print_date) AS Bulan, dbo.t_permit_ho_p.desa_id, dbo.t_permit_ho_p.ho_type_id, 
               dbo.d_company_type.code, dbo.m_company.company_name, dbo.m_company.pemohon_name, dbo.t_permit_ho_p.address, dbo.m_company.input_date, 
               dbo.t_permit_ho_p.print_date, dbo.t_permit_ho_p.process_date, dbo.t_permit_ho_p.expired_date, dbo.t_permit_ho_p.permit_number, dbo.t_permit_ho_p.luas, 
               dbo.t_permit_ho_p.luas_penambahan, dbo.t_permit_ho_p.total, dbo.t_permit_ho_p.denda, dbo.t_permit_ho_p.business_kind, 
               dbo.t_permit_ho_p.nama_pemilik_tanah, dbo.t_permit_ho_p.sertifikat_tanah, dbo.d_DESA.Kecamatan
FROM  dbo.t_permit_ho_p INNER JOIN
               dbo.m_company ON dbo.t_permit_ho_p.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.t_permit_ho_p.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_ho_p"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 342
               Bottom = 135
               Right = 616
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 664
               Bottom = 135
               Right = 871
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_HO_P'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_HO_P'
GO
/****** Object:  View [dbo].[vw_Lap_HO]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_HO]
AS
SELECT YEAR(dbo.t_permit_ho.print_date) AS Tahun, MONTH(dbo.t_permit_ho.print_date) AS Bulan, dbo.t_permit_ho.desa_id, dbo.t_permit_ho.ho_type_id, 
               dbo.d_company_type.code, dbo.m_company.company_name, dbo.m_company.pemohon_name, dbo.t_permit_ho.address, dbo.m_company.input_date, 
               dbo.t_permit_ho.print_date, dbo.t_permit_ho.process_date, dbo.t_permit_ho.expired_date, dbo.t_permit_ho.permit_number, dbo.t_permit_ho.luas, 
               dbo.t_permit_ho.luas_penambahan, dbo.t_permit_ho.total, dbo.t_permit_ho.denda, dbo.t_permit_ho.business_kind, dbo.t_permit_ho.nama_pemilik_tanah, 
               dbo.t_permit_ho.sertifikat_tanah, dbo.d_DESA.Kecamatan
FROM  dbo.t_permit_ho INNER JOIN
               dbo.m_company ON dbo.t_permit_ho.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.t_permit_ho.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_ho"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 197
               Right = 294
            End
            DisplayFlags = 280
            TopColumn = 53
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 342
               Bottom = 135
               Right = 616
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 664
               Bottom = 135
               Right = 871
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 69
               Left = 395
               Bottom = 197
               Right = 568
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_HO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_HO'
GO
/****** Object:  Table [dbo].[d_company_status]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_company_status](
	[company_status_id] [smallint] NOT NULL,
	[company_status] [varchar](50) NULL,
 CONSTRAINT [d_company_status_pk] PRIMARY KEY CLUSTERED 
(
	[company_status_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_company_kedudukan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_company_kedudukan](
	[company_kedudukan_id] [smallint] NOT NULL,
	[company_kedudukan] [varchar](50) NULL,
 CONSTRAINT [d_company_kedudukan_pk] PRIMARY KEY CLUSTERED 
(
	[company_kedudukan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[d_bulan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[d_bulan](
	[bulan_id] [smallint] NOT NULL,
	[bulan] [varchar](50) NULL,
	[ket] [varchar](50) NULL,
 CONSTRAINT [d_bulan_pk] PRIMARY KEY CLUSTERED 
(
	[bulan_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_REKLAME_detail]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_REKLAME_detail](
	[permit_id] [bigint] NULL,
	[permit_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[reklame_type_id] [smallint] NULL,
	[ukuran] [varchar](255) NULL,
	[tulisan] [varchar](255) NULL,
	[jumlah_reklame] [varchar](255) NULL,
	[lokasi] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[permit_detail_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_IUA]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IUA](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[address] [varchar](255) NULL,
	[jenis_usaha_angkutan] [varchar](255) NULL,
	[desa_id] [smallint] NULL,
	[nomor_surat_dishub] [varchar](50) NULL,
	[tanggal_surat_dishub] [datetime] NULL,
	[status_survey_id] [smallint] NULL,
 CONSTRAINT [PK__t_permit_IUA__1F98B2C1] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_IPR]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IPR](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[permit_type_id] [smallint] NULL,
	[peruntukan_tambang] [varchar](255) NULL,
	[luas] [varchar](255) NULL,
	[jenis_tambang] [varchar](255) NULL,
	[batas_utara] [varchar](255) NULL,
	[batas_timur] [varchar](255) NULL,
	[batas_selatan] [varchar](255) NULL,
	[batas_barat] [varchar](255) NULL,
	[status_survey_id] [int] NULL,
	[nomor_BAP] [varchar](20) NULL,
	[tanggal_BAP] [datetime] NULL,
 CONSTRAINT [PK__t_permit_IPR__1AD3FDA4] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_IPLC]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IPLC](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[kegiatan_usaha] [varchar](255) NULL,
	[lokasi_pembuangan] [varchar](255) NULL,
	[atas_nama] [varchar](255) NULL,
	[petugas_id] [int] NULL,
	[status_survey_id] [int] NULL,
	[nomor_BAP] [varchar](20) NULL,
	[tanggal_BAP] [datetime] NULL,
 CONSTRAINT [PK__t_permit_IPLC__1332DBDC] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_tdg]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_tdg](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[siup] [varchar](255) NULL,
	[siup_tempat] [varchar](255) NULL,
	[Lokasi_Gudang] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[isi] [varchar](255) NULL,
	[jalan] [char](50) NULL,
	[letter_date] [datetime] NULL,
	[luas_klasifikasi_gudang] [varchar](50) NULL,
	[klasifikasi_gudang] [varchar](50) NULL,
	[no_sertifikat] [varchar](50) NULL,
	[status_survey_id] [smallint] NULL,
 CONSTRAINT [PK__t_permit_tdg__42E1EEFE] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLogins]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserLogins](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[login_name] [varchar](25) NULL,
	[password] [varchar](100) NULL,
	[user_level] [smallint] NULL,
 CONSTRAINT [PK_UsersLogin] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserLevels]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLevels](
	[UserLevelID] [int] NOT NULL,
	[UserLevelName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PKUserLevels] PRIMARY KEY CLUSTERED 
(
	[UserLevelID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLevelPermissions]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLevelPermissions](
	[UserLevelID] [int] NOT NULL,
	[TableName] [nvarchar](255) NOT NULL,
	[Permission] [int] NOT NULL,
 CONSTRAINT [PKUserLevelPermissions] PRIMARY KEY CLUSTERED 
(
	[UserLevelID] ASC,
	[TableName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[TERBILANG]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TERBILANG] (@the_amount money)
RETURNS varchar(250) AS
BEGIN

DECLARE @divisor	bigint,
	@large_amount	money,
	@tiny_amount	money,
	@dividen	money,
	@dummy		money,
	@the_word	varchar(250),
	@weight	varchar(100),
	@unit		varchar(30),
	@follower	varchar(50),
	@prefix	varchar(10),
	@sufix		varchar(10)

--SET NOCOUNT ON
SET @the_word = ''
SET @large_amount = FLOOR(ABS(@the_amount) )
SET @tiny_amount = ROUND((ABS(@the_amount) - @large_amount ) * 100.00,0)
SET @divisor = 1000000000000.00

IF @large_amount > @divisor * 1000.00
	RETURN 'OUT OF RANGE'

WHILE @divisor >= 1
BEGIN	
	SET @dividen = FLOOR(@large_amount / @divisor)
	
	SET @large_amount = CONVERT(bigint,@large_amount) % @divisor
	
	SET @unit = ''
	IF @dividen > 0.00
		SET @unit=(CASE @divisor
			WHEN 1000000000000.00 THEN 'TRILYUN '
			WHEN 1000000000.00 THEN 'MILYAR '			
			WHEN 1000000.00 THEN 'JUTA '				
			WHEN 1000.00 THEN 'RIBU '
			ELSE @unit
		END )

	SET @weight = ''	
	SET @dummy = @dividen
	IF @dummy >= 100.00
		SET @weight = (CASE FLOOR(@dummy / 100.00)
			WHEN 1 THEN 'SE'
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END ) + 'RATUS '

	SET @dummy = CONVERT(bigint,@dividen) % 100

	IF @dummy < 10.00
	BEGIN
		IF @dummy = 1.00 AND @unit = 'RIBU'
		BEGIN
			IF @dividen=@dummy
				SET @weight = @weight + 'SE'
			ELSE
				SET @weight = @weight + 'SATU '
		END
		ELSE
		IF @dummy > 0.00
			SET @weight = @weight + (CASE @dummy
				WHEN 1 THEN 'SATU '
				WHEN 2 THEN 'DUA '
				WHEN 3 THEN 'TIGA '
				WHEN 4 THEN 'EMPAT '
				WHEN 5 THEN 'LIMA '
				WHEN 6 THEN 'ENAM '
				WHEN 7 THEN 'TUJUH '
				WHEN 8 THEN 'DELAPAN '
				ELSE 'SEMBILAN ' END)
	END
	ELSE
	IF @dummy BETWEEN 11 AND 19
		SET @weight = @weight + (CASE CONVERT(bigint,@dummy) % 10
			WHEN 1 THEN 'SE'
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END ) + 'BELAS '
	ELSE
	BEGIN
		SET @weight = @weight + (CASE FLOOR(@dummy / 10)
			WHEN 1 THEN 'SE'
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END ) + 'PULUH '
		IF CONVERT(bigint,@dummy) % 10 > 0
			SET @weight = @weight + (CASE CONVERT(bigint,@dummy) % 10
				WHEN 1 THEN 'SATU '
				WHEN 2 THEN 'DUA '
				WHEN 3 THEN 'TIGA '
				WHEN 4 THEN 'EMPAT '
				WHEN 5 THEN 'LIMA '
				WHEN 6 THEN 'ENAM '
				WHEN 7 THEN 'TUJUH '
				WHEN 8 THEN 'DELAPAN '
				ELSE 'SEMBILAN ' END )
	END
	
	SET @the_word = @the_word + @weight + @unit
	SET @divisor = @divisor / 1000.00
END

IF FLOOR(@the_amount) = 0.00
	SET @the_word = 'NOL '

SET @follower = ''
IF @tiny_amount < 10.00
BEGIN	
	IF @tiny_amount > 0.00
		SET @follower = 'KOMA NOL ' + (CASE @tiny_amount
			WHEN 1 THEN 'SATU '
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END)
END
ELSE
BEGIN
	SET @follower = 'KOMA ' + (CASE FLOOR(@tiny_amount / 10.00)
			WHEN 1 THEN 'SATU '
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END)
	IF CONVERT(bigint,@tiny_amount) % 10 > 0
		SET @follower = @follower + (CASE CONVERT(bigint,@tiny_amount) % 10
			WHEN 1 THEN 'SATU '
			WHEN 2 THEN 'DUA '
			WHEN 3 THEN 'TIGA '
			WHEN 4 THEN 'EMPAT '
			WHEN 5 THEN 'LIMA '
			WHEN 6 THEN 'ENAM '
			WHEN 7 THEN 'TUJUH '
			WHEN 8 THEN 'DELAPAN '
			ELSE 'SEMBILAN ' END)
END
	
SET @the_word = @the_word + @follower

IF @the_amount < 0.00
	SET @the_word = 'MINUS ' + @the_word
	
RETURN @the_word
END
GO
/****** Object:  Table [dbo].[t_tanda_terima]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_tanda_terima](
	[permit_id] [bigint] IDENTITY(1,1) NOT NULL,
	[no_pendaftaran] [varchar](50) NULL,
	[Lengkap] [varchar](30) NULL,
	[Tidak_lengkap] [varchar](30) NULL,
	[persyaratan1] [varchar](255) NULL,
	[persyaratan2] [varchar](255) NULL,
	[persyaratan3] [varchar](255) NULL,
	[persyaratan4] [varchar](255) NULL,
	[Jenis_izin] [varchar](100) NULL,
	[company_id] [bigint] NULL,
	[tanggal_selesai] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_skrd]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_skrd](
	[no_skrd] [varchar](10) NULL,
	[tgl_cetak_skrd] [datetime] NULL,
	[permit_imb_id] [varchar](50) NULL,
	[permit_ho_id] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_PAMERAN]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_PAMERAN](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[nomor_pendaftaran] [varchar](50) NULL,
	[permit_type_id] [smallint] NULL,
	[total] [bigint] NULL,
	[letter_date] [datetime] NULL,
	[jenis_pameran] [varchar](255) NULL,
	[nama_penyelenggara] [varchar](255) NULL,
	[lokasi] [varchar](255) NULL,
	[begin_date] [datetime] NULL,
	[finish_date] [datetime] NULL,
	[jam_mulai] [varchar](50) NULL,
	[memperhatikan1] [varchar](500) NULL,
	[memperhatikan2] [varchar](500) NULL,
	[memperhatikan3] [varchar](500) NULL,
	[memperhatikan4] [varchar](500) NULL,
	[memperhatikan5] [varchar](500) NULL,
	[memperhatikan6] [varchar](500) NULL,
	[memperhatikan7] [varchar](500) NULL,
	[memperhatikan8] [varchar](500) NULL,
	[memperhatikan9] [varchar](500) NULL,
	[memperhatikan10] [varchar](500) NULL,
	[memperhatikan11] [varchar](500) NULL,
	[memperhatikan12] [varchar](500) NULL,
	[memperhatikan13] [varchar](500) NULL,
	[memperhatikan14] [varchar](500) NULL,
	[atas_nama] [varchar](255) NULL,
	[jam_akhir] [varchar](50) NULL,
	[status_survey_id] [smallint] NULL,
	[tanggal_BAP] [datetime] NULL,
	[nomor_BAP] [varchar](20) NULL,
 CONSTRAINT [PK__t_permit_PAMERAN__339FAB6E] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_kecamatan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_kecamatan]
AS
SELECT DISTINCT Kecamatan
FROM  dbo.d_DESA
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_kecamatan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_kecamatan'
GO
/****** Object:  View [dbo].[vw_detail_rekomendasi_sub]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_detail_rekomendasi_sub]
AS
  SELECT 
  a.*
  from m_company_subdetail_rekomendasi a
GO
/****** Object:  View [dbo].[vw_company_arsip]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_arsip]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_arsip

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_surveyor]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_surveyor]
AS
SELECT 
  a.company_id,
  a.company_number,
  a.company_name,
  a.kecamatan_id,
  a.desa_id,
  a.address,
  a.company_type_id,
  a.pemohon_name,   
  a.untuk,
  a.peta_lokasi,
  a.peta_situasi,
  a.KTP,
  a.tgl_mb_surveyor
FROM 
  dbo.m_company a
GO
/****** Object:  View [dbo].[vw_company_sekretaris]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_sekretaris]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_sekretaris

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_rekomendasi]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_rekomendasi]
as
SELECT 
  a.company_id,
  a.company_number,
  a.input_date,
  a.ket_company_name,
  a.company_name,
  a.kecamatan_id,
  a.desa_id,
  a.[address], 
  a.pemohon_name,
  a.KTP,
  a.tgl_mb_rekomendasi
FROM 
  dbo.m_company a
GO
/****** Object:  View [dbo].[vw_company_register]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_register]
as
SELECT 
  company_id,
  company_number,
  input_date,
  ket_company_name,
  company_name,
  kecamatan_id,
  desa_id,
  [address],
  pemohon_name,
  KTP,
  certificate_number,
  tgl_mb_register

FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_pengambilan]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_pengambilan]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  tanggal_turun,
  tanggal_pengambilan,
  nomor_id_pengambil,
  nama_pengambil,
  alamat_pengambil,
  nomor_tlp_pengambil,
  tgl_mb_pengambilan 

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_pendaftaran]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_pendaftaran]
as
SELECT 
  company_id,
  company_number,
  input_date,
  ket_company_name,
  company_name,
  kecamatan_id,
  desa_id,
  [address],
  company_type_id,
  certificate_number,
  tanggal_pendirian,
  desc_permit,
  NPWP,
  phone,
  fax,
  modal,
  bank1,
  bank2,
  company_status_id,
  kantor_pusat,
  pengesahan_pejabat_berwenang,
  produk,
  omset_pertahun,
  company_kedudukan_id,
  pemohon_name,
 
  pemohon_address,
  pemohon_ktp,
  pemohon_phone,
  pemohon_NPWP,
  pemohon_nationality_id,
  
  pusat_address,
  
  untuk,
  peta_lokasi,
  peta_situasi,
  KTP,
  tgl_mb_pendaftaran
  
  
  
FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_mb]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_mb]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
tgl_mb_pendaftaran ,
tgl_mb_inputdata ,
tgl_mb_kajian1 ,
tgl_mb_rekomendasi ,
tgl_mb_surveyor ,
tgl_mb_kajian2 ,
tgl_mb_register ,
tgl_mb_kabid ,
tgl_mb_sekretaris ,
tgl_mb_kepala ,
tgl_mb_pengambilan ,
tgl_mb_arsip ,
status_mb_pendaftaran  ,
status_mb_inputdata  ,
status_mb_kajian1  ,
status_mb_rekomendasi  ,
status_mb_surveyor  ,
status_mb_kajian2  ,
status_mb_register  ,
status_mb_kabid  ,
status_mb_sekretaris  ,
status_mb_kepala  ,
status_mb_pengambilan  ,
status_mb_arsip  

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_kepala]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_kepala]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_kepala

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_kajian_1]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_kajian_1]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_kajian2

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_kajian]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_kajian]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_kajian1

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_kabid]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_kabid]
as
SELECT 
  company_id,
  company_number,
  pemohon_name, 
  company_name,
  address, 
  kecamatan_id,
  desa_id,
  tgl_mb_kabid

  FROM 
  dbo.m_company ;
GO
/****** Object:  View [dbo].[vw_company_input_data]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_company_input_data]
AS
SELECT 
  company_id,
  company_number,
  company_name,
  kecamatan_id,
  desa_id,
  [address],
  company_type_id,
  pemohon_name,   
  untuk,
  tgl_mb_inputdata
FROM 
  dbo.m_company
GO
/****** Object:  Table [dbo].[t_permit_tdp]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_tdp](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[business_kind] [varchar](255) NULL,
	[tdp_type_id] [smallint] NULL,
	[tdp_cost] [bigint] NULL,
	[total] [bigint] NULL,
	[tdp_ke_angka1] [char](2) NULL,
	[KELOMPOK_ID] [varchar](15) NULL,
	[letter_date] [datetime] NULL,
	[pengesahan] [varchar](255) NULL,
	[pengesahan_menteri] [varchar](255) NULL,
	[pengesahan_menteri_atas_perubahan_AD] [varchar](255) NULL,
	[pengesahan_menteri_DATE] [datetime] NULL,
	[pengesahan_menteri_atas_perubahan_AD_DATE] [datetime] NULL,
	[agenda_pendaftaran_NOMOR] [varchar](255) NULL,
	[agenda_pendaftaran_TANGGAL] [datetime] NULL,
	[no_sertifikat] [varchar](51) NULL,
	[tenaga_kerja_WNI] [varchar](50) NULL,
	[modal_usaha] [bigint] NULL,
	[status_survey_id] [smallint] NULL,
	[status_kantor] [varchar](50) NULL,
	[tdp_ke_angka2] [char](2) NULL,
 CONSTRAINT [PK__t_permit_tdp__4B7734FF] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[penomoran_TDP]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[penomoran_TDP] (@permit_id bigint)
RETURNS  varchar(50)
AS
BEGIN

	DECLARE @vDate datetime
	DECLARE @vKELOMPOK_ID varchar(4)
	DECLARE @vNumber  varchar(5)
	DECLARE @vMonth varchar(4)
	DECLARE @vYear varchar(4)
	DECLARE @vCode varchar(50) 
    DECLARE @hasil varchar(50)   

	SELECT  
    	@vCode = c.tdp_code, 
	    @vKELOMPOK_ID = substring(KELOMPOK_ID,1,2)
	FROM t_permit_TDP a
	LEFT OUTER JOIN m_company b ON a.company_id = b.company_id
	LEFT OUTER JOIN d_company_type c ON b.company_type_id = c.company_type_id
    WHERE a.permit_id = @permit_id ;

	SELECT  @vNumber =
	  CASE
	   WHEN (ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1) / 10 >= 1000
	    THEN  rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1) / 10 >= 100
	    THEN '0' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1) / 10 >= 10
	    THEN '00' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))
	   WHEN (ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1) / 10 = 1
	    THEN '000' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))
       WHEN (ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1) / 10 = 0
	    THEN '0000' + rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))
	   ELSE rtrim(ltrim(str(ISNULL(max(substring(nomor_sk,12,5)) + 0,0) + 1)))		  	
	  END
	FROM m_company_detail a
	LEFT OUTER JOIN m_company b ON a.company_id = b.company_id
	LEFT OUTER JOIN d_company_type c ON b.company_type_id = c.company_type_id
    WHERE 	c.tdp_code = @vCode 
    AND a.permit_group_id = 16
    -- TDP nomornya berlanjut terus, tidak ada penomoran dari awal walaupun berganti tahun

/*
	UPDATE t_permit_tdp
	SET permit_number = '10.30.' + @vCode +'.'+ @vKELOMPOK_ID +'.'+ @vNumber
	    , expired_date = @vExpired_date
	WHERE  permit_id = @permit_id
	AND (permit_number is null or permit_number = '')
	AND print_date is not null
*/

 SET @hasil = '10.30.' + @vCode +'.'+ @vKELOMPOK_ID +'.'+ @vNumber ;
 RETURN @hasil;
   
END
GO
/****** Object:  Table [dbo].[t_permit_tdi]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_tdi](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[KKI_1] [varchar](50) NULL,
	[nilai_invest] [bigint] NULL,
	[kapasitas_produk] [varchar](50) NULL,
	[letter_date] [datetime] NULL,
	[produk] [varchar](255) NULL,
	[omset_pertahun] [varchar](50) NULL,
	[total] [bigint] NULL,
	[jenis_usaha] [varchar](255) NULL,
	[business_kind] [varchar](255) NULL,
	[NIPIK] [int] NULL,
	[Lokasi_Pabrik] [varchar](255) NULL,
	[peralatan_utama] [varchar](255) NULL,
	[peralatan_pembantu] [varchar](50) NULL,
	[tenaga_penggerak] [varchar](50) NULL,
	[tdi_type_id] [int] NULL,
	[KELOMPOK_ID] [varchar](15) NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[KKI_2] [varchar](50) NULL,
	[KKI_3] [varchar](50) NULL,
	[KKI_4] [varchar](50) NULL,
	[KKI_TAMBAHAN] [varchar](50) NULL,
	[status_survey_id] [smallint] NULL,
 CONSTRAINT [t_permit_tdi_pk] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_permit_IUI]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_permit_IUI](
	[permit_id] [bigint] NOT NULL,
	[company_id] [bigint] NULL,
	[NPWP] [varchar](50) NULL,
	[klui] [varchar](50) NULL,
	[KKI_1] [varchar](50) NULL,
	[NIPIK] [varchar](50) NULL,
	[nilai_invest] [bigint] NULL,
	[kapasitas_produk] [varchar](50) NULL,
	[tenaga_penggerak] [varchar](50) NULL,
	[peralatan_utama] [varchar](50) NULL,
	[peralatan_pembantu] [varchar](50) NULL,
	[owner_name] [varchar](255) NULL,
	[owner_address] [varchar](255) NULL,
	[permit_type_id] [nchar](10) NULL,
	[jenis] [varchar](50) NULL,
	[letter_date] [datetime] NULL,
	[luas] [bigint] NULL,
	[address] [varchar](255) NULL,
	[kecamatan_id] [smallint] NULL,
	[desa_id] [smallint] NULL,
	[produk] [varchar](50) NULL,
	[omset_pertahun] [varchar](50) NULL,
	[merk] [varchar](50) NULL,
	[tenaga_kerja_WNA] [bigint] NULL,
	[tenaga_kerja_WNI] [bigint] NULL,
	[KKI_2] [varchar](50) NULL,
	[KKI_3] [varchar](50) NULL,
	[KKI_4] [varchar](50) NULL,
	[KKI_TAMBAHAN] [varchar](50) NULL,
	[KELOMPOK_ID] [smallint] NULL,
	[iui_type_id] [smallint] NULL,
	[status_survey_id] [smallint] NULL,
 CONSTRAINT [PK__t_permit_iui__236943A5] PRIMARY KEY CLUSTERED 
(
	[permit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_t_permit_IUA]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_IUA] 
AS

SELECT 
  permit_id,
  company_id,
  jenis_usaha_angkutan,
  tanggal_surat_dishub,
  nomor_surat_dishub
FROM 
  dbo.t_permit_IUA ;
GO
/****** Object:  View [dbo].[vw_t_permit_IPR]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_IPR] 
AS

SELECT 
  permit_id,
  company_id,
  permit_type_id,
peruntukan_tambang,
  luas,
  jenis_tambang,
  batas_utara,
  batas_timur,
  batas_selatan,
  batas_barat
FROM 
  dbo.t_permit_IPR ;
GO
/****** Object:  View [dbo].[VW_t_permit_IPLC]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_t_permit_IPLC]
AS

SELECT 
  permit_id,
  company_id,
  kegiatan_usaha,
  lokasi_pembuangan
FROM 
  dbo.t_permit_IPLC ;
GO
/****** Object:  View [dbo].[vw_t_permit_PAMERAN]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_PAMERAN]
AS
SELECT 
  permit_id,
  company_id,
  nomor_pendaftaran,
  permit_type_id,
  total,
  letter_date,
  jenis_pameran,
  nama_penyelenggara,
  lokasi,
  begin_date,
  finish_date,
  jam_mulai,
  jam_akhir,
  atas_nama
FROM 
  dbo.t_permit_PAMERAN ;
GO
/****** Object:  View [dbo].[vw_t_permit_tdg]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_tdg]
AS
SELECT 
  permit_id,
  company_id,
  luas_klasifikasi_gudang,
  klasifikasi_gudang
FROM 
  dbo.t_permit_tdg ;
GO
/****** Object:  View [dbo].[vw_t_permit_tdp]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_tdp]
AS
SELECT 
  permit_id,
  company_id,
  tdp_type_id,
  tdp_ke_angka1,
  tdp_ke_angka2,
  KELOMPOK_ID
FROM 
  dbo.t_permit_tdp ;
GO
/****** Object:  View [dbo].[vw_t_permit_tdi]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_tdi]
AS
SELECT 
  permit_id,
  company_id,
  KKI_1,
  KKI_2,
  KKI_3,
  KKI_4,
  KKI_TAMBAHAN,
  nilai_invest,
  NIPIK,
  tdi_type_id,
  KELOMPOK_ID,
  peralatan_utama,
  peralatan_pembantu,
  tenaga_penggerak,
  kapasitas_produk,
  [address],
  kecamatan_id,
  desa_id
FROM 
  dbo.t_permit_tdi ;
GO
/****** Object:  View [dbo].[vw_t_permit_siup]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_siup]
AS
SELECT 
  permit_id,
  company_id,
  business_kind,
  siup_type_id,
  siup_golongan_usaha_id,
  kbli1,
  kbli2,
  kbli3,
  kelembagaan,
  jenis_dagangan,
  modal
FROM 
  dbo.t_permit_siup ;
GO
/****** Object:  View [dbo].[vw_t_permit_IUI]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW   [dbo].[vw_t_permit_IUI]
AS
SELECT 
  permit_id,
  company_id,
  KKI_1,
  KKI_2,
  KKI_3,
  KKI_4,
  KKI_TAMBAHAN,
  nilai_invest,
  NIPIK,
  iui_type_id,
  KELOMPOK_ID,
  peralatan_utama,
  peralatan_pembantu,
  tenaga_penggerak,
  kapasitas_produk,
  [address],
  kecamatan_id,
  desa_id
FROM 
  dbo.t_permit_IUI ;
GO
/****** Object:  View [dbo].[vw_Lap_TDP]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_TDP]
AS
SELECT YEAR(dbo.t_permit_tdp.print_date) AS Tahun, MONTH(dbo.t_permit_tdp.print_date) AS Bulan, dbo.d_DESA.Kecamatan, dbo.m_company.desa_id, 
               dbo.t_permit_tdp.tdp_type_id, dbo.d_company_type.code AS Jenis_Perusahaan, dbo.m_company.company_name AS Nama_Perusahaan, 
               dbo.m_company.pemohon_name AS Nama_Pemohon, dbo.m_company.address AS alamat, dbo.m_company.input_date AS TGL_Daftar, 
               dbo.t_permit_tdp.print_date AS Tanggal_SK, dbo.t_permit_tdp.process_date AS Tanggal_Proses, dbo.t_permit_tdp.expired_date AS Tanggal_Habis_Berlaku, 
               dbo.t_permit_tdp.permit_number AS Nomor_SK, dbo.t_permit_tdp.business_kind AS jenis_usaha
FROM  dbo.t_permit_tdp INNER JOIN
               dbo.m_company ON dbo.t_permit_tdp.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.m_company.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_tdp"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 412
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 460
               Bottom = 135
               Right = 734
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 303
               Bottom = 268
               Right = 476
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_TDP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_TDP'
GO
/****** Object:  View [dbo].[vw_Lap_TDI]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_TDI]
AS
SELECT YEAR(dbo.t_permit_tdi.print_date) AS Tahun, MONTH(dbo.t_permit_tdi.print_date) AS Bulan, dbo.d_DESA.Kecamatan, dbo.t_permit_tdi.desa_id, 
               dbo.d_company_type.code AS jenis_perusahaan, dbo.m_company.company_name AS nama_perusahaan, dbo.m_company.pemohon_name AS nama_pemohon, 
               dbo.t_permit_tdi.address AS alamat, dbo.m_company.input_date AS Tanggal_Daftar, dbo.t_permit_tdi.print_date AS Tanggal_SK, 
               dbo.t_permit_tdi.process_date AS Tanggal_Proses, dbo.t_permit_tdi.expired_date AS Tanggal_Habis_Berlaku, 
               dbo.t_permit_tdi.permit_number AS nomor_SK
FROM  dbo.t_permit_tdi INNER JOIN
               dbo.m_company ON dbo.t_permit_tdi.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.t_permit_tdi.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_tdi"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 298
               Bottom = 135
               Right = 572
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 620
               Bottom = 135
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_TDI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_TDI'
GO
/****** Object:  View [dbo].[vw_Lap_SIUP]    Script Date: 12/15/2014 12:55:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Lap_SIUP]
AS
SELECT YEAR(dbo.t_permit_siup.print_date) AS Tahun, MONTH(dbo.t_permit_siup.print_date) AS Bulan, dbo.d_DESA.Kecamatan, dbo.m_company.desa_id, 
               dbo.t_permit_siup.siup_golongan_usaha_id, dbo.d_company_type.code AS Jenis_Perusahaan, dbo.m_company.company_name AS Nama_Perusahaan, 
               dbo.m_company.pemohon_name AS Nama_Pemohon, dbo.m_company.address AS alamat, dbo.m_company.input_date AS TGL_Daftar, 
               dbo.t_permit_siup.print_date AS Tanggal_SK, dbo.t_permit_siup.process_date AS Tanggal_Proses, dbo.t_permit_siup.expired_date AS Tanggal_Habis_Berlaku, 
               dbo.t_permit_siup.permit_number AS Nomor_SK, dbo.t_permit_siup.business_kind AS jenis_usaha
FROM  dbo.t_permit_siup INNER JOIN
               dbo.m_company ON dbo.t_permit_siup.company_id = dbo.m_company.company_id INNER JOIN
               dbo.d_company_type ON dbo.m_company.company_type_id = dbo.d_company_type.company_type_id INNER JOIN
               dbo.d_DESA ON dbo.m_company.desa_id = dbo.d_DESA.desa_id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t_permit_siup"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 135
               Right = 272
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m_company"
            Begin Extent = 
               Top = 7
               Left = 320
               Bottom = 135
               Right = 594
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_company_type"
            Begin Extent = 
               Top = 7
               Left = 642
               Bottom = 135
               Right = 849
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d_DESA"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 268
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_SIUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Lap_SIUP'
GO
/****** Object:  Default [DF__m_company__edit___1209AD79]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__edit___1209AD79]  DEFAULT ('EDIT') FOR [edit_txt]
GO
/****** Object:  Default [DF__m_company__cetak__13F1F5EB]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__cetak__13F1F5EB]  DEFAULT ('CETAK SK') FOR [cetak_sk_link]
GO
/****** Object:  Default [DF__m_company__cetak__14E61A24]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__cetak__14E61A24]  DEFAULT ('CETAK SK') FOR [cetak_sk_txt]
GO
/****** Object:  Default [DF__m_company__strd___16CE6296]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__strd___16CE6296]  DEFAULT ((0)) FOR [strd_retribusi_kurang_bayar]
GO
/****** Object:  Default [DF__m_company__strd___17C286CF]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__strd___17C286CF]  DEFAULT ((0)) FOR [strd_sanksi_administrasi]
GO
/****** Object:  Default [DF__m_company__strd___18B6AB08]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company_detail] ADD  CONSTRAINT [DF__m_company__strd___18B6AB08]  DEFAULT ('Cetak STRD') FOR [strd_txt]
GO
/****** Object:  Default [DF__t_permit___tahun__4DE98D56]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[t_permit_ho_jenis] ADD  CONSTRAINT [DF__t_permit___tahun__4DE98D56]  DEFAULT ((0)) FOR [tahun_keterlambatan]
GO
/****** Object:  Default [DF__m_company__statu__7E57BA87]    Script Date: 12/15/2014 12:55:11 ******/
ALTER TABLE [dbo].[m_company] ADD  DEFAULT ('BELUM') FOR [status_mb_pendaftaran]
GO
/****** Object:  Default [DF__t_permit___tahun__52AE4273]    Script Date: 12/15/2014 12:55:12 ******/
ALTER TABLE [dbo].[t_permit_ho_jenis_detail] ADD  CONSTRAINT [DF__t_permit___tahun__52AE4273]  DEFAULT ((0)) FOR [tahun_keterlambatan]
GO
