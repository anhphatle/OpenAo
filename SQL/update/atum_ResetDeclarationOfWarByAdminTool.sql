USE [atum2_db_1]
GO
/****** Object:  StoredProcedure [dbo].[atum_ResetDeclarationOfWarByAdminTool]    Script Date: 29/09/2017 12:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--------------------------------------------------------------------------------
-- PROCEDURE NAME	: dbo.atum_ResetDeclarationOfWarByAdminTool
-- DESC				: Â¼Â±Ã€Ã¼ Ã†Ã·Â°Ã­ ÃÃ¶ÂµÂµÃ€Ãš ÃƒÃŠÂ±Ã¢ÃˆÂ­Â¶Â§ ÃƒÃŠÂ±Ã¢ÃˆÂ­ÂµÃˆÂ´Ã™.
-- 2009-01-14 by dhjin,
--------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[atum_ResetDeclarationOfWarByAdminTool]
AS
	DELETE FROM dbo.td_DeclarationOfWar WHERE MSWarStep = 1 or MSWarStep = 2 or MSWarStep = 3 or MSWarStep = 4 or MSWarStep = 5 OR MSWarStep = 99

	DECLARE @DATE DATETIME,@GETDATE DATETIME,@MONTHSTDATE DATETIME,@STARTDATE DATETIME, @NUMSATURDAY INT
	SET DATEFIRST 6
	SET @STARTDATE=GETDATE()
	SELECT @MONTHSTDATE = CONVERT(DATETIME, CONVERT(VARCHAR(5),DATEPART(MM, @STARTDATE)) + '/01/' + CONVERT(VARCHAR(5),DATEPART(YYYY, @STARTDATE)) +' ' + '07:30:00 PM')
	PRINT @MONTHSTDATE
	PRINT DATEPART(DW,@MONTHSTDATE)
	SET @GETDATE=@MONTHSTDATE - CASE WHEN DATEPART(DW,@MONTHSTDATE) = 1 THEN 0
	ELSE (DATEPART(DW,@MONTHSTDATE)-8)
	END
	PRINT @GETDATE 
	SET @GETDATE = DateAdd(day, -3, @GETDATE)
	PRINT @GETDATE;

	;with dates as
		(
			select dateadd(month,DATEPART(MM,@MONTHSTDATE)-1,dateadd(year,DATEPART(YYYY,@MONTHSTDATE)-1900,0)) as StartDate
			union all
			select startdate + 1 from dates where month(startdate+1) = DATEPART(MM,@MONTHSTDATE)
		) 
		select @NUMSATURDAY = count(*) from dates where datediff(dd,0,startdate)%7 in (5)

	PRINT @NUMSATURDAY

	DECLARE @WEEKS INT
	SET @WEEKS = 0

	WHILE @WEEKS <= @NUMSATURDAY 
	BEGIN
		IF (@WEEKS = @NUMSATURDAY)
		BEGIN
			INSERT INTO dbo.td_DeclarationOfWar (Influence, MSWarStep, NCP, MSNum, MSAppearanceMap, MSWarStepStartTime, MSWarStepEndTime, MSWarStartTime, MSWarEndTime, SelectCount, GiveUp, MSWarEndState)
				VALUES (2, 99, 0, 0, 0, DateAdd(day, @WEEKS*7, @GETDATE), DateAdd(day, (@WEEKS +1)*7, @GETDATE), DateAdd(day, (@WEEKS*7)+3, @GETDATE), NULL, 3, 0, 0)
			INSERT INTO dbo.td_DeclarationOfWar (Influence, MSWarStep, NCP, MSNum, MSAppearanceMap, MSWarStepStartTime, MSWarStepEndTime, MSWarStartTime, MSWarEndTime, SelectCount, GiveUp, MSWarEndState)
				VALUES (4, 99, 0, 0, 0, DateAdd(day, @WEEKS*7, @GETDATE), DateAdd(day, (@WEEKS +1)*7, @GETDATE), DateAdd(day, (@WEEKS*7)+3, @GETDATE), NULL, 3, 0, 0)
		END
		ELSE
		BEGIN
			INSERT INTO dbo.td_DeclarationOfWar (Influence, MSWarStep, NCP, MSNum, MSAppearanceMap, MSWarStepStartTime, MSWarStepEndTime, MSWarStartTime, MSWarEndTime, SelectCount, GiveUp, MSWarEndState)
				VALUES (2, @WEEKS+1, 0, 0, 0, DateAdd(day, @WEEKS*7, @GETDATE), DateAdd(day, (@WEEKS +1)*7, @GETDATE), DateAdd(day, (@WEEKS*7)+3, @GETDATE), NULL, 3, 0, 0)
			INSERT INTO dbo.td_DeclarationOfWar (Influence, MSWarStep, NCP, MSNum, MSAppearanceMap, MSWarStepStartTime, MSWarStepEndTime, MSWarStartTime, MSWarEndTime, SelectCount, GiveUp, MSWarEndState)
				VALUES (4, @WEEKS+1, 0, 0, 0, DateAdd(day, @WEEKS*7, @GETDATE), DateAdd(day, (@WEEKS +1)*7, @GETDATE), DateAdd(day, (@WEEKS*7)+3, @GETDATE), NULL, 3, 0, 0)
		END
		SET @WEEKS = @WEEKS + 1
	END