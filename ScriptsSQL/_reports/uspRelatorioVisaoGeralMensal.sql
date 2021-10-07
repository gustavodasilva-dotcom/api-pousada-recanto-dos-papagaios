USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspRelatorioVisaoGeralMensal]
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