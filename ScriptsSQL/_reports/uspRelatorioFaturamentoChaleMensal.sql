USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspRelatorioFaturamentoChaleMensal]
	 @DataInicio	date
	,@DataFim		date
AS
	BEGIN
/*************************************************************************************************************
Descrição: Procedure utilizada para obter relatórios do faturamento por chalé em um período.
Data.....: 09/09/2021
*************************************************************************************************************/

		WITH

		RelatorioFaturamentoChaleMensal
		
		(

			 IdAcomodacao
			,NomeChale
			,QuantidadeReservas
			,DiasReservados
			,TotalPorChale
			,MesResultado

		)

		AS

		(

			SELECT		 A.ACO_ID_INT		 AS IdAcomodacao
						,A.ACO_NOME_STR		 AS NomeChale
						,COUNT(R.RES_ID_INT) AS QuantidadeReservas
						
						,(
							SELECT
							SUM
							(
								DATEDIFF
								(
									DAY,
									R.RES_DATA_CHECKIN_DATE,
									R.RES_DATA_CHECKOUT_DATE
								)
							)
						 ) AS DiasReservados
						
						,SUM(CO.CHECKOUT_VALOR_TOTAL_FLOAT) AS TotalPorChale
						
						,CASE
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 1  THEN 'Resultados de janeiro'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 2  THEN 'Resultados de fevereiro'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 3  THEN 'Resultados de março'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 4  THEN 'Resultados de abril'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 5  THEN 'Resultados de maio'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 6  THEN 'Resultados de junho'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 7  THEN 'Resultados de julho'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 8  THEN 'Resultados de agosto'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 9  THEN 'Resultados de setembro'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 10 THEN 'Resultados de outubro'
							WHEN MONTH(R.RES_DATA_CADASTRO_DATETIME) = 11 THEN 'Resultados de novembro'
							ELSE 'Resultados de dezembro'
						 END AS MesResultado

			FROM		RESERVA					AS R
			INNER JOIN	CHECKIN					AS CI	ON R.RES_ID_INT						= CI.CHECKIN_RES_ID_INT
			INNER JOIN	CHECKOUT				AS CO	ON CI.CHECKIN_ID_INT				= CO.CHECKOUT_CHECKIN_ID_INT
			INNER JOIN	ACOMODACAO				AS A	ON R.RES_ACO_ID_INT					= A.ACO_ID_INT
			INNER JOIN	INFORMACOES_ACOMODACAO	AS IA	ON A.ACO_INFO_ACOMOD_ID_INT			= IA.INFO_ACOMOD_ID_INT
			INNER JOIN	CATEGORIA_ACOMODACAO	AS CA	ON IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT	= CA.CAT_ACOMOD_ID_INT
			WHERE		R.RES_DATA_CADASTRO_DATETIME BETWEEN @DataInicio AND @DataFim
			GROUP BY	A.ACO_ID_INT, A.ACO_NOME_STR, RES_DATA_CADASTRO_DATETIME

		)


		SELECT		 IdAcomodacao		AS 'Id da acomodação'
					,NomeChale			AS 'Nome do chalé'
					,QuantidadeReservas	AS 'Quantidade de reservas'
					,DiasReservados		AS 'Dias reservados'
					,TotalPorChale		AS 'Total por Chalé (R$)'
					,MesResultado		AS 'Mês de resultado'
		FROM		RelatorioFaturamentoChaleMensal
		ORDER BY	IdAcomodacao ASC;


	END;
GO