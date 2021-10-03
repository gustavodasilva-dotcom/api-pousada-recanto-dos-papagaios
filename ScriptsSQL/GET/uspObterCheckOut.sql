USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspObterCheckOut]
	@IdReserva int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter check-out (no momento, apenas na API).
Data.....: 07/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declarando variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	nvarchar(255);		
		DECLARE @Codigo		int;

/*************************************************************************************************************************************
Obter check-out:
*************************************************************************************************************************************/
		WITH
		
		InformacoesCheckOut
		
		(
			 CHECKOUT_ID_INT
			,CHECKOUT_VALORES_ADICIONAIS_FLOAT
			,CHECKOUT_VALOR_TOTAL_FLOAT
			,CHECKIN_ID_INT
			,RES_ID_INT
			,RES_DATA_RESERVA_DATE
			,RES_DATA_CHECKIN_DATE
			,RES_DATA_CHECKOUT_DATE
			,INFO_ACOMOD_PRECO_FLOAT
			,RES_VALOR_RESERVA_FLOAT
			,HSP_NOME_STR
			,HSP_CPF_CHAR
			,ACO_ID_INT
			,ACO_NOME_STR
			,RES_ACOMPANHANTES_ID_INT
			,FUNC_NOME_STR
			,USU_NOME_USUARIO_STR
			,PGTO_COUT_ID_INT
		)
		
		AS
		
		(
		
			SELECT		 CO.CHECKOUT_ID_INT
						,CO.CHECKOUT_VALORES_ADICIONAIS_FLOAT
						,CO.CHECKOUT_VALOR_TOTAL_FLOAT
						
						,CI.CHECKIN_ID_INT
			
						,R.RES_ID_INT
						,R.RES_DATA_RESERVA_DATE
						,R.RES_DATA_CHECKIN_DATE
						,R.RES_DATA_CHECKOUT_DATE
						,IA.INFO_ACOMOD_PRECO_FLOAT
						,R.RES_VALOR_RESERVA_FLOAT
			
						,H.HSP_NOME_STR
						,H.HSP_CPF_CHAR
			
						,A.ACO_ID_INT
						,A.ACO_NOME_STR
			
						,R.RES_ACOMPANHANTES_ID_INT
			
						,F.FUNC_NOME_STR
						,U.USU_NOME_USUARIO_STR
			
						,PCO.PGTO_COUT_ID_INT
			FROM		CHECKOUT				AS CO
			INNER JOIN	CHECKIN					AS CI	ON CI.CHECKIN_ID_INT		= CO.CHECKOUT_CHECKIN_ID_INT
			INNER JOIN	RESERVA					AS R	ON R.RES_ID_INT				= CI.CHECKIN_RES_ID_INT
			INNER JOIN	ACOMODACAO				AS A	ON R.RES_ACO_ID_INT			= A.ACO_ID_INT
			INNER JOIN	INFORMACOES_ACOMODACAO	AS IA	ON A.ACO_INFO_ACOMOD_ID_INT	= IA.INFO_ACOMOD_ID_INT
			INNER JOIN	FUNCIONARIO				AS F	ON F.FUNC_ID_INT			= CO.CHECKOUT_FUNC_ID_INT
			INNER JOIN	USUARIO					AS U	ON F.FUNC_USU_ID_INT		= U.USU_ID_INT
			INNER JOIN	HOSPEDE					AS H	ON R.RES_HSP_ID_INT			= H.HSP_ID_INT
			LEFT JOIN	PAGAMENTO_CHECK_OUT		AS PCO	ON CO.CHECKOUT_ID_INT		= PCO.PGTO_COUT_CHECK_OUT_ID_INT
		
		),

		PagamentoAdicionalCheckOut

		(
			 PGTO_COUT_ID_INT
			,TPPGTO_ID_INT
			,TPPGTO_TIPO_PAGAMENTO_STR
			,ST_PGTO_ID_INT
			,ST_PGTO_DESCRICAO_STR

		)

		AS

		(

			SELECT		 CO.PGTO_COUT_ID_INT

						,TP.TPPGTO_ID_INT
						,TP.TPPGTO_TIPO_PAGAMENTO_STR
						
						,SP.ST_PGTO_ID_INT
						,SP.ST_PGTO_DESCRICAO_STR

			FROM		PAGAMENTO_CHECK_OUT	AS CO
			INNER JOIN	TIPO_PAGAMENTO		AS TP ON CO.PGTO_COUT_TPPGTO_ID_INT		= TP.TPPGTO_ID_INT
			INNER JOIN	STATUS_PAGAMENTO	AS SP ON CO.PGTO_COUT_ST_PGTO_ID_INT	= SP.ST_PGTO_ID_INT

		)


		SELECT		 IC.CHECKOUT_ID_INT
					,IC.CHECKOUT_VALORES_ADICIONAIS_FLOAT
					,IC.CHECKOUT_VALOR_TOTAL_FLOAT
					,IC.CHECKIN_ID_INT
					,IC.RES_ID_INT
					,IC.RES_DATA_RESERVA_DATE
					,IC.RES_DATA_CHECKIN_DATE
					,IC.RES_DATA_CHECKOUT_DATE
					,IC.INFO_ACOMOD_PRECO_FLOAT
					,IC.RES_VALOR_RESERVA_FLOAT
					,IC.HSP_NOME_STR
					,IC.HSP_CPF_CHAR
					,IC.ACO_ID_INT
					,IC.ACO_NOME_STR
					,IC.RES_ACOMPANHANTES_ID_INT
					,IC.FUNC_NOME_STR
					,IC.USU_NOME_USUARIO_STR

					,CASE
						WHEN PA.PGTO_COUT_ID_INT IS NULL THEN 0
						ELSE PA.PGTO_COUT_ID_INT
					 END AS PGTO_COUT_ID_INT

					,CASE
						WHEN PA.TPPGTO_ID_INT IS NULL THEN 0
						ELSE PA.TPPGTO_ID_INT
					 END AS TPPGTO_ID_INT

					,CASE
						WHEN PA.TPPGTO_TIPO_PAGAMENTO_STR IS NULL THEN 'Sem pagamentos adicionais'
						ELSE PA.TPPGTO_TIPO_PAGAMENTO_STR
					 END AS TPPGTO_TIPO_PAGAMENTO_STR

					,CASE
						WHEN PA.ST_PGTO_ID_INT IS NULL THEN 0
						ELSE PA.ST_PGTO_ID_INT
					 END AS ST_PGTO_ID_INT

					,CASE
						WHEN PA.ST_PGTO_DESCRICAO_STR IS NULL THEN 'Sem pagamentos adicionais'
						ELSE PA.ST_PGTO_DESCRICAO_STR
					 END AS ST_PGTO_DESCRICAO_STR

		FROM		InformacoesCheckOut			AS IC
		LEFT JOIN	PagamentoAdicionalCheckOut	AS PA ON IC.PGTO_COUT_ID_INT = PA.PGTO_COUT_ID_INT
		WHERE		IC.RES_ID_INT = @IdReserva;

	END;
GO