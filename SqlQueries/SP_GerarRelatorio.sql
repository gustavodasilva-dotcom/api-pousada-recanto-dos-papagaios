USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[SP_GerarRelatorio]
	@Perido_De date		= NULL,
	@Periodo_Ate date	= NULL,
	@Tipo int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure responsável por gerar os relatórios para à administração da pousada.
Data.....: 11/07/2021
*************************************************************************************************************************************/
		
--***********************************************************************************************************************************
--Início: 1: Relatório mensal de todas as reservas.
--***********************************************************************************************************************************
		IF @Tipo = 1
			BEGIN
				SELECT *
				FROM  [RECPAPAGAIOS].[dbo].[RESERVA]
				WHERE RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END
--***********************************************************************************************************************************
--Fim: 1: Relatório mensal de todas as reservas.
--***********************************************************************************************************************************


--***********************************************************************************************************************************
-- Início: 2: Relatório de reservas que não sofreram check-in (reservas canceladas).
--***********************************************************************************************************************************
		IF @Tipo = 2
			BEGIN
				SELECT *
				FROM		[RECPAPAGAIOS].[dbo].[RESERVA] AS R
				LEFT JOIN	[RECPAPAGAIOS].[dbo].[CHECKIN] AS C ON R.RES_ID_INT = C.CHECKIN_RES_ID_INT
				WHERE		C.CHECKIN_ID_INT IS NULL
				  AND		R.RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END
--***********************************************************************************************************************************
--Fim: 2: Relatório de reservas que não sofreram check-in (reservas canceladas).
--***********************************************************************************************************************************


--***********************************************************************************************************************************
--Início: 3: Relatório de mensal de reservas que passarão pelo check-in e pelo check-out
--***********************************************************************************************************************************
		IF @Tipo = 3
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[RESERVA]  AS R
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKIN]  AS CI ON CI.CHECKIN_RES_ID_INT	   = R.RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKOUT] AS CO ON CO.CHECKOUT_CHECKIN_ID_INT = CI.CHECKIN_ID_INT
				WHERE	   R.RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate;
			END
--***********************************************************************************************************************************
--Fim: 3: Relatório de mensal de reservas que passarão pelo check-in e pelo check-out
--***********************************************************************************************************************************


--***********************************************************************************************************************************
--Início: 4: Check-ins realizados por funcionário.
--***********************************************************************************************************************************
		IF @Tipo = 4
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[CHECKIN]	  AS C
				INNER JOIN [RECPAPAGAIOS].[dbo].[RESERVA]	  AS R ON R.RES_ID_INT  = C.CHECKIN_RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[FUNCIONARIO] AS F ON F.FUNC_ID_INT = C.CHECKIN_FUNC_ID_INT
				ORDER BY C.CHECKIN_FUNC_ID_INT;
			END
--***********************************************************************************************************************************
--Fim: 4: Check-ins realizados por funcionário.
--***********************************************************************************************************************************


--***********************************************************************************************************************************
--Início: 5: Check-outs realizados por funcionário.
--***********************************************************************************************************************************
		IF @Tipo = 5
			BEGIN
				SELECT *
				FROM	   [RECPAPAGAIOS].[dbo].[CHECKOUT]	  AS CO
				INNER JOIN [RECPAPAGAIOS].[dbo].[CHECKIN]	  AS CI ON CI.CHECKIN_ID_INT = CO.CHECKOUT_CHECKIN_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[RESERVA]	  AS R  ON R.RES_ID_INT		 = CI.CHECKIN_RES_ID_INT
				INNER JOIN [RECPAPAGAIOS].[dbo].[FUNCIONARIO] AS F  ON F.FUNC_ID_INT	 = CO.CHECKOUT_FUNC_ID_INT
				ORDER BY CO.CHECKOUT_FUNC_ID_INT;
			END
--***********************************************************************************************************************************
--Fim: 5: Check-outs realizados por funcionário.
--***********************************************************************************************************************************


--***********************************************************************************************************************************
--Início: 6: Relatório dos chalés mais reservados e o faturamento deles (por período).
--***********************************************************************************************************************************
		IF @Tipo = 6
			BEGIN
				DROP TABLE IF EXISTS #RESULTADO_CHALES_MAIS_RESERVADOS;
				
				SELECT		A.ACO_NOME_STR													AS 'Nome do chalé',
							COUNT(R.RES_ACO_ID_INT)											AS 'Reservas por acomodação',
							COUNT(CI.CHECKIN_ID_INT)										AS 'Check-ins por acomodação',
							COUNT(CO.CHECKOUT_ID_INT)										AS 'Check-outs por acomodação',
							SUM(R.RES_VALOR_RESERVA_FLOAT)									AS 'Total (R$) em check-ins',
							SUM(CO.CHECKOUT_VALOR_TOTAL_FLOAT)								AS 'Total (R$) em check-outs',
							SUM(R.RES_VALOR_RESERVA_FLOAT + CO.CHECKOUT_VALOR_TOTAL_FLOAT)	AS 'Faturamento por chalé'
				INTO		#RESULTADO_CHALES_MAIS_RESERVADOS
				FROM		[RECPAPAGAIOS].[dbo].[ACOMODACAO]	AS A
				LEFT JOIN	[RECPAPAGAIOS].[dbo].[RESERVA]		AS R	ON A.ACO_ID_INT					= R.RES_ACO_ID_INT
				LEFT JOIN	[RECPAPAGAIOS].[dbo].[CHECKIN]		AS CI	ON CI.CHECKIN_RES_ID_INT		= R.RES_ID_INT
				LEFT JOIN	[RECPAPAGAIOS].[dbo].[CHECKOUT]		AS CO	ON CO.CHECKOUT_CHECKIN_ID_INT	= CI.CHECKIN_ID_INT
				    WHERE	A.ACO_EXCLUIDO_BIT = 0
				      AND	R.RES_DATA_RESERVA_DATE BETWEEN @Perido_De AND @Periodo_Ate
				GROUP BY	A.ACO_NOME_STR

				SELECT * FROM #RESULTADO_CHALES_MAIS_RESERVADOS;
			END

--***********************************************************************************************************************************
--Fim: 6: Relatório dos chalés mais reservados e o faturamento deles (por período).
--***********************************************************************************************************************************

	END
GO