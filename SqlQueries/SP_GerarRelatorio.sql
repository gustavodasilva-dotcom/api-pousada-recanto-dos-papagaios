USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[SP_GerarRelatorio]
	@Perido_De date		= NULL,
	@Periodo_Ate date	= NULL,
	@Tipo int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure respons�vel por gerar os relat�rios para � administra��o da pousada.
Data.....: 11/07/2021
*************************************************************************************************************************************/


		-- 1: Relat�rio mensal de todas as reservas.
		IF @Tipo = 1
			BEGIN
				SELECT *
				FROM  [RECPAPAGAIOS].[dbo].[RESERVA]
				WHERE RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END

		-- 2: Relat�rio de reservas que n�o sofreram check-in (reservas canceladas).
		IF @Tipo = 2
			BEGIN
				SELECT *
				FROM		[RECPAPAGAIOS].[dbo].[RESERVA] AS R
				LEFT JOIN	[RECPAPAGAIOS].[dbo].[CHECKIN] AS C ON R.RES_ID_INT = C.CHECKIN_RES_ID_INT
				WHERE		C.CHECKIN_ID_INT IS NULL
				  AND		R.RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END

		-- 3: Relat�rio de mensal de reservas que passar�o pelo check-in e pelo check-out
		IF @Tipo = 3
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[RESERVA]  AS R
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKIN]  AS CI ON CI.CHECKIN_RES_ID_INT	   = R.RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKOUT] AS CO ON CO.CHECKOUT_CHECKIN_ID_INT = CI.CHECKIN_ID_INT
				WHERE	   R.RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END

		-- 4: Check-ins realizados por funcion�rio.
		IF @Tipo = 4
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[CHECKIN]	  AS C
				INNER JOIN [RECPAPAGAIOS].[dbo].[RESERVA]	  AS R ON R.RES_ID_INT  = C.CHECKIN_RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[FUNCIONARIO] AS F ON F.FUNC_ID_INT = C.CHECKIN_FUNC_ID_INT
				ORDER BY C.CHECKIN_FUNC_ID_INT;
			END

		-- 5: Check-outs realizados por funcion�rio.
		IF @Tipo = 5
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[CHECKOUT]	  AS CO
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKIN]	  AS CI ON CI.CHECKIN_ID_INT = CO.CHECKOUT_CHECKIN_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[RESERVA]	  AS R  ON R.RES_ID_INT		 = CI.CHECKIN_RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[FUNCIONARIO] AS F  ON F.FUNC_ID_INT	 = CO.CHECKOUT_FUNC_ID_INT
				ORDER BY CO.CHECKOUT_FUNC_ID_INT;
			END

		--6: Chal�s mais reservados em um determinado per�odo.
		IF @Tipo = 6
			BEGIN
				-- TODO: Escrever a query que gera esse relat�rio.
			END
	END
GO