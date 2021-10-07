USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspObterReserva]
	 @IdReserva	int = NULL
	,@IdHospede	int = NULL
	,@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para obter reservas (no momento, apenas na API).
Data.....: 01/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
CASO 1 - Caso o tipo selecionado seja o primeiro:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			WITH

			ObterReservaPorID
			(
				RES_ID_INT,							RES_DATA_RESERVA_DATE,				RES_DATA_CHECKIN_DATE,			RES_DATA_CHECKOUT_DATE,			RES_ACOMPANHANTES_ID_INT,
				RES_VALOR_UNITARIO_FLOAT,			RES_VALOR_RESERVA_FLOAT,			ST_RES_ID_INT,					ST_RES_DESCRICAO_STR,			HSP_ID_INT,
				HSP_NOME_STR,						HSP_CPF_CHAR,						ACO_ID_INT,						ACO_NOME_STR,					ST_ACOMOD_ID_INT,
				ST_ACOMOD_DESCRICAO_STR,			INFO_ACOMOD_METROS_QUADRADOS_FLOAT,	INFO_ACOMOD_CAPACIDADE_INT,		INFO_ACOMOD_TIPO_DE_CAMA_STR,	INFO_ACOMOD_PRECO_FLOAT,
				CAT_ACOMOD_ID_INT,					CAT_ACOMOD_DESCRICAO_STR,			TPPGTO_ID_INT,					TPPGTO_TIPO_PAGAMENTO_STR,		ST_PGTO_ID_INT,
				ST_PGTO_DESCRICAO_STR
			)

			AS

			(

				SELECT		 R.RES_ID_INT
							,R.RES_DATA_RESERVA_DATE
							,R.RES_DATA_CHECKIN_DATE
							,R.RES_DATA_CHECKOUT_DATE
							,R.RES_ACOMPANHANTES_ID_INT
							,IA.INFO_ACOMOD_PRECO_FLOAT AS RES_VALOR_UNITARIO_FLOAT
							,R.RES_VALOR_RESERVA_FLOAT
							,SR.ST_RES_ID_INT
							,SR.ST_RES_DESCRICAO_STR
							,H.HSP_ID_INT
							,H.HSP_NOME_STR
							,H.HSP_CPF_CHAR
							,A.ACO_ID_INT
							,A.ACO_NOME_STR
							,SA.ST_ACOMOD_ID_INT
							,SA.ST_ACOMOD_DESCRICAO_STR
							,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
							,IA.INFO_ACOMOD_CAPACIDADE_INT
							,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
							,IA.INFO_ACOMOD_PRECO_FLOAT
							,CA.CAT_ACOMOD_ID_INT
							,CA.CAT_ACOMOD_DESCRICAO_STR
							,TP.TPPGTO_ID_INT
							,TP.TPPGTO_TIPO_PAGAMENTO_STR
							,SP.ST_PGTO_ID_INT
							,SP.ST_PGTO_DESCRICAO_STR
				FROM		RESERVA					AS R
				INNER JOIN	STATUS_RESERVA			AS SR	ON R.RES_ST_RES_INT					= SR.ST_RES_ID_INT
				INNER JOIN	ACOMODACAO				AS A	ON R.RES_ACO_ID_INT					= A.ACO_ID_INT
				INNER JOIN	STATUS_ACOMODACAO		AS SA	ON A.ACO_ST_ACOMOD_INT				= SA.ST_ACOMOD_ID_INT
				INNER JOIN	INFORMACOES_ACOMODACAO	AS IA	ON A.ACO_INFO_ACOMOD_ID_INT			= IA.INFO_ACOMOD_ID_INT
				INNER JOIN	CATEGORIA_ACOMODACAO	AS CA	ON IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT = CA.CAT_ACOMOD_ID_INT
				INNER JOIN	HOSPEDE					AS H	ON R.RES_HSP_ID_INT					= H.HSP_ID_INT
				INNER JOIN	PAGAMENTO_RESERVA		AS PR	ON PR.PGTO_RES_ID_INT				= R.RES_ID_INT
				INNER JOIN	TIPO_PAGAMENTO			AS TP	ON PR.PGTO_RES_TPPGTO_ID_INT		= TP.TPPGTO_ID_INT
				INNER JOIN	STATUS_PAGAMENTO		AS SP	ON PR.PGTO_RES_ST_PGTO_ID_INT		= SP.ST_PGTO_ID_INT
				WHERE		RES_EXCLUIDO_BIT = 0

			)

			SELECT * FROM ObterReservaPorID WHERE RES_ID_INT = @IdReserva;

		END;


/*************************************************************************************************************************************
CASO 2 - Caso o tipo selecionado seja o segundo:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN

			WITH

			ObterReservaPorID
			(
				RES_ID_INT,							RES_DATA_RESERVA_DATE,				RES_DATA_CHECKIN_DATE,			RES_DATA_CHECKOUT_DATE,			RES_ACOMPANHANTES_ID_INT,
				RES_VALOR_UNITARIO_FLOAT,			RES_VALOR_RESERVA_FLOAT,			ST_RES_ID_INT,					ST_RES_DESCRICAO_STR,			HSP_ID_INT,
				HSP_NOME_STR,						HSP_CPF_CHAR,						ACO_ID_INT,						ACO_NOME_STR,					ST_ACOMOD_ID_INT,
				ST_ACOMOD_DESCRICAO_STR,			INFO_ACOMOD_METROS_QUADRADOS_FLOAT,	INFO_ACOMOD_CAPACIDADE_INT,		INFO_ACOMOD_TIPO_DE_CAMA_STR,	INFO_ACOMOD_PRECO_FLOAT,
				CAT_ACOMOD_ID_INT,					CAT_ACOMOD_DESCRICAO_STR,			TPPGTO_ID_INT,					TPPGTO_TIPO_PAGAMENTO_STR,		ST_PGTO_ID_INT,
				ST_PGTO_DESCRICAO_STR
			)

			AS

			(

				SELECT		 R.RES_ID_INT
							,R.RES_DATA_RESERVA_DATE
							,R.RES_DATA_CHECKIN_DATE
							,R.RES_DATA_CHECKOUT_DATE
							,R.RES_ACOMPANHANTES_ID_INT
							,IA.INFO_ACOMOD_PRECO_FLOAT AS RES_VALOR_UNITARIO_FLOAT
							,R.RES_VALOR_RESERVA_FLOAT
							,SR.ST_RES_ID_INT
							,SR.ST_RES_DESCRICAO_STR
							,H.HSP_ID_INT
							,H.HSP_NOME_STR
							,H.HSP_CPF_CHAR
							,A.ACO_ID_INT
							,A.ACO_NOME_STR
							,SA.ST_ACOMOD_ID_INT
							,SA.ST_ACOMOD_DESCRICAO_STR
							,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
							,IA.INFO_ACOMOD_CAPACIDADE_INT
							,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
							,IA.INFO_ACOMOD_PRECO_FLOAT
							,CA.CAT_ACOMOD_ID_INT
							,CA.CAT_ACOMOD_DESCRICAO_STR
							,TP.TPPGTO_ID_INT
							,TP.TPPGTO_TIPO_PAGAMENTO_STR
							,SP.ST_PGTO_ID_INT
							,SP.ST_PGTO_DESCRICAO_STR
				FROM		RESERVA					AS R
				INNER JOIN	STATUS_RESERVA			AS SR	ON R.RES_ST_RES_INT					= SR.ST_RES_ID_INT
				INNER JOIN	ACOMODACAO				AS A	ON R.RES_ACO_ID_INT					= A.ACO_ID_INT
				INNER JOIN	STATUS_ACOMODACAO		AS SA	ON A.ACO_ST_ACOMOD_INT				= SA.ST_ACOMOD_ID_INT
				INNER JOIN	INFORMACOES_ACOMODACAO	AS IA	ON A.ACO_INFO_ACOMOD_ID_INT			= IA.INFO_ACOMOD_ID_INT
				INNER JOIN	CATEGORIA_ACOMODACAO	AS CA	ON IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT = CA.CAT_ACOMOD_ID_INT
				INNER JOIN	HOSPEDE					AS H	ON R.RES_HSP_ID_INT					= H.HSP_ID_INT
				INNER JOIN	PAGAMENTO_RESERVA		AS PR	ON PR.PGTO_RES_ID_INT				= R.RES_ID_INT
				INNER JOIN	TIPO_PAGAMENTO			AS TP	ON PR.PGTO_RES_TPPGTO_ID_INT		= TP.TPPGTO_ID_INT
				INNER JOIN	STATUS_PAGAMENTO		AS SP	ON PR.PGTO_RES_ST_PGTO_ID_INT		= SP.ST_PGTO_ID_INT
				WHERE		RES_EXCLUIDO_BIT = 0

			)

			SELECT * FROM ObterReservaPorID WHERE HSP_ID_INT = @IdHospede ORDER BY RES_ID_INT DESC;

		END;

	END;
GO