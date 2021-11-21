/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE FATURAMENTO MENSAL DOS CHALÉS
**************************************************************************************************************************************
*************************************************************************************************************************************/
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
/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE FATURAMENTO MENSAL DOS CHALÉS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE PERFORMANCE DOS FUNCIONÁRIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspRelatorioPerformanceFuncionarios]
	
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure que gera uma relatório de perfomance dos funcionários, pegando a quantidade total de check-ins e check-outs rea-
		   lizados por cada funcionário.
Data.....: 26/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

		WITH

		[TotalCheckIns]

		(

			 IdFuncionario
			,NomeFuncionario
			,TotalCheckIns

		)

		AS

		(

			SELECT		 FUNC_ID_INT
						,FUNC_NOME_STR
						,COUNT(CHECKIN_FUNC_ID_INT) AS 'Total de check-ins'
			FROM		CHECKIN		AS C
			INNER JOIN	FUNCIONARIO AS F ON C.CHECKIN_FUNC_ID_INT = F.FUNC_ID_INT
			GROUP BY	CHECKIN_FUNC_ID_INT, FUNC_ID_INT, FUNC_NOME_STR
		
		),

		[TotalCheckOuts]

		(

			 IdFuncionario
			,NomeFuncionario
			,TotalCheckOuts

		)

		AS

		(

			SELECT		 FUNC_ID_INT
						,FUNC_NOME_STR
						,COUNT(CHECKOUT_FUNC_ID_INT) AS 'Total de check-outs'
			FROM		CHECKOUT	AS C
			INNER JOIN	FUNCIONARIO AS F ON C.CHECKOUT_FUNC_ID_INT = F.FUNC_ID_INT
			GROUP BY	CHECKOUT_FUNC_ID_INT, FUNC_ID_INT, FUNC_NOME_STR

		),

		[DadosFuncionario]

		(
		
			 IdFuncionario
			,Cpf
			,Cargo
			,Setor
			,Excluido

		)

		AS

		(

			SELECT	 FUNC_ID_INT
					,FUNC_CPF_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_EXCLUIDO_BIT
			FROM	FUNCIONARIO

		)

		SELECT		 TCO.IdFuncionario		AS 'Funcionário Id'
					,TCO.NomeFuncionario	AS 'Nome do funcionário'
					,DF.Cpf					AS 'CPF do funcionário'
					,DF.Setor				AS 'Setor'
					,DF.Cargo				AS 'Cargo'
					,CASE
						WHEN DF.Excluido = 0 THEN 'Não'
						ELSE 'Sim'
					 END					AS 'Funcionário está excluído'
					,TCI.TotalCheckIns		AS 'Total de check-ins'
					,TCO.TotalCheckOuts		AS 'Total de check-outs'
		FROM		TotalCheckIns		AS TCI
		INNER JOIN	TotalCheckOuts		AS TCO	ON TCI.IdFuncionario = TCO.IdFuncionario
		INNER JOIN	DadosFuncionario	AS DF	ON TCI.IdFuncionario = DF.IdFuncionario;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE PERFORMANCE DOS FUNCIONÁRIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE VISÃO GERAL MENSAL
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspRelatorioVisaoGeralMensal]
	 @DataInicio	date
	,@DataFim		date
AS
	BEGIN
/*************************************************************************************************************
Descrição: Procedure utilizada para obter relatórios de todas as reservas feitas em um período.
Data.....: 08/09/2021
*************************************************************************************************************/

		WITH

		ReservasDeSucesso

		(
			
			 CodigoDaReserva
			,DataDaReserva
			,DataDeCheckIn
			,DataDeCheckOut
			,DataDeCheckOutExecutado
			,IdHospede
			,IdAcomodacao
			,ValorReserva
			,ValorTotal

		)	

			AS

		(
		
			SELECT		 R.RES_ID_INT							AS CodigoDaReserva
						,R.RES_DATA_RESERVA_DATE				AS DataDaReserva
						,R.RES_DATA_CHECKIN_DATE				AS DataDeCheckIn
						,R.RES_DATA_CHECKOUT_DATE				AS DataDeCheckOut
						,CO.CHECKOUT_DATA_CADASTRO_DATETIME		AS DataDeCheckOutExecutado
						,R.RES_HSP_ID_INT						AS IdHospede
						,R.RES_ACO_ID_INT						AS IdAcomodacao
						,R.RES_VALOR_RESERVA_FLOAT				AS ValorReserva
						,CO.CHECKOUT_VALOR_TOTAL_FLOAT			AS ValorTotal
			FROM		RESERVA		AS R
			INNER JOIN	CHECKIN		AS CI ON R.RES_ID_INT		= CI.CHECKIN_RES_ID_INT
			INNER JOIN	CHECKOUT	AS CO ON CI.CHECKIN_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
			  AND		R.RES_EXCLUIDO_BIT = 0
		),

		HospedeComReserva

		(

			 IdHospede
			,NomeCompleto
			,Cpf
			,EnderecoCompleto

		)

			AS

		(

			SELECT		 H.HSP_ID_INT		AS IdHospede
						,H.HSP_NOME_STR		AS NomeCompleto
						,H.HSP_CPF_CHAR		AS Cpf
						
						,CASE
							WHEN E.END_COMPLEMENTO_STR IS NULL
								THEN
								(
									CONCAT
									(
										E.END_LOGRADOURO_STR,	', ',
										E.END_NUMERO_CHAR,		' - ',
										E.END_CIDADE_STR,		', ',
										E.END_BAIRRO_STR,		' - ',
										E.END_ESTADO_CHAR,		' - ',
										E.END_PAIS_STR
									)
								)
							ELSE
								(
									CONCAT
									(
										E.END_LOGRADOURO_STR,	', ',
										E.END_NUMERO_CHAR,		' - ',
										E.END_COMPLEMENTO_STR,	' - ',
										E.END_CIDADE_STR,		', ',
										E.END_BAIRRO_STR,		' - ',
										E.END_ESTADO_CHAR,		' - ',
										E.END_PAIS_STR
									)
								)
						 END AS EnderecoCompleto

			FROM		HOSPEDE		AS H
			INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT = E.END_ID_INT

		),

		AcomodacaoDaReserva

		(

			 IdAcomodacao
			,NomeChale
			,ValorChale
			,Categoria

		)

		AS

		(

			SELECT		 A.ACO_ID_INT					AS IdAcomodacao
						,A.ACO_NOME_STR					AS NomeChale
						,IA.INFO_ACOMOD_PRECO_FLOAT		AS ValorChale
						,CA.CAT_ACOMOD_DESCRICAO_STR	AS Categoria
			FROM		ACOMODACAO				AS A
			INNER JOIN	INFORMACOES_ACOMODACAO	AS IA ON A.ACO_INFO_ACOMOD_ID_INT			= IA.INFO_ACOMOD_ID_INT
			INNER JOIN	CATEGORIA_ACOMODACAO	AS CA ON IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT	= CA.CAT_ACOMOD_ID_INT

		)


		SELECT		 CodigoDaReserva									AS 'Código da reserva'
					,CONVERT(varchar, DataDaReserva				, 103)	AS 'Data da reserva'
					,CONVERT(varchar, DataDeCheckIn				, 103)	AS 'Data de check-in'
					,CONVERT(varchar, DataDeCheckOut			, 103)	AS 'Data de check-out'
					,CONVERT(varchar, DataDeCheckOutExecutado	, 103)	AS 'Data de check-out executado'
					,H.IdHospede										AS 'Código do hóspede'
					,NomeCompleto										AS 'Nome do hóspede'
					,Cpf												AS 'CPF do hóspede'
					,EnderecoCompleto									AS 'Endereço do hóspede'
					,NomeChale											AS 'Chalé'
					,Categoria											AS 'Categoria do chalé'
					,ValorReserva										AS 'Valor da reserva'
					,ValorTotal											AS 'Total (reserva + check-in)'
		FROM		ReservasDeSucesso	AS R
		INNER JOIN	HospedeComReserva	AS H ON H.IdHospede		= R.IdHospede
		INNER JOIN	AcomodacaoDaReserva AS A ON R.IdAcomodacao	= A.IdAcomodacao
		WHERE		R.DataDaReserva BETWEEN @DataInicio AND @DataFim;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA CRIAR O RELATÓRIO DE VISÃO GERAL MENSAL
**************************************************************************************************************************************
*************************************************************************************************************************************/