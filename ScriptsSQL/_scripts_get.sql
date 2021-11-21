/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA OBTER CONTA
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspEsqueciMinhaSenha_EncontrarConta]
	@Cpf	nchar(11)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, na primeira validação do processo de "Esqueci Minha Senha", onde será validado
		   se o CPF do usuário está cadastrado no sistema.
Data.....: 22/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @IdUsuario	int;
		DECLARE @Codigo		int;
		DECLARE @Mensagem	nvarchar(255);

/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		SELECT		@IdUsuario = U.USU_ID_INT
		FROM		HOSPEDE	AS H
		INNER JOIN	USUARIO AS U ON H.HSP_USU_ID_INT = U.USU_ID_INT
		WHERE		H.HSP_CPF_CHAR = @Cpf;

		IF @IdUsuario IS NOT NULL
			BEGIN
				SELECT	@Cpf AS CPF
						,PERG_SEG_PERGUNTA_STR
						,PERG_SEG_RESPOSTA_STR
				FROM	PERGUNTA_SEGURANCA
				WHERE	PERG_SEG_USU_ID_INT = @IdUsuario;
			END;
		ELSE
			BEGIN
				SELECT		@IdUsuario = U.USU_ID_INT
				FROM		FUNCIONARIO	AS F
				INNER JOIN	USUARIO		AS U ON F.FUNC_USU_ID_INT = U.USU_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf;

				IF @IdUsuario IS NOT NULL
				BEGIN
					SELECT	 @Cpf AS CPF
							,PERG_SEG_PERGUNTA_STR
							,PERG_SEG_RESPOSTA_STR
					FROM	PERGUNTA_SEGURANCA
					WHERE	PERG_SEG_USU_ID_INT = @IdUsuario;
				END;
			END;

/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA OBTER CONTA
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA OBTER ACOMODAÇÕES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterAcomodacoes]
	 @Tipo	int
	,@Id	int	= NULL
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter Acomodações (no momento, apenas na API).
Data.....: 30/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Codigo		INT;

/*************************************************************************************************************************************
INÍCIO: TIPO 1 - Selecionar todas as acomodações:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			IF @Id IS NULL
			BEGIN

				WITH
				STATUSDETODASASACOMODACOES
				(
					 Codigo
					,ACO_ID_INT
					,ACO_NOME_STR
					,ST_ACOMOD_ID_INT
					,ST_ACOMOD_DESCRICAO_STR
					,INFO_ACOMOD_ID_INT
					,INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					,INFO_ACOMOD_CAPACIDADE_INT
					,INFO_ACOMOD_TIPO_DE_CAMA_STR
					,INFO_ACOMOD_PRECO_FLOAT
					,CAT_ACOMOD_ID_INT
					,CAT_ACOMOD_DESCRICAO_STR

				)

				AS

				(

					SELECT		 200
								,A.ACO_ID_INT
								,A.ACO_NOME_STR
								,SA.ST_ACOMOD_ID_INT
								,SA.ST_ACOMOD_DESCRICAO_STR
								,IA.INFO_ACOMOD_ID_INT
								,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
								,IA.INFO_ACOMOD_CAPACIDADE_INT
								,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
								,IA.INFO_ACOMOD_PRECO_FLOAT
								,CA.CAT_ACOMOD_ID_INT
								,CA.CAT_ACOMOD_DESCRICAO_STR
					FROM		ACOMODACAO				AS A
					INNER JOIN	STATUS_ACOMODACAO		AS SA ON A.ACO_ST_ACOMOD_INT		= SA.ST_ACOMOD_ID_INT
					INNER JOIN	INFORMACOES_ACOMODACAO	AS IA ON A.ACO_INFO_ACOMOD_ID_INT	= IA.INFO_ACOMOD_ID_INT
					INNER JOIN	CATEGORIA_ACOMODACAO	AS CA ON CA.CAT_ACOMOD_ID_INT		= IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT
					WHERE		A.ACO_EXCLUIDO_BIT = 0

				)

				SELECT * FROM STATUSDETODASASACOMODACOES

			END;

		END;
/*************************************************************************************************************************************
FIM: TIPO 1 - Selecionar todas as acomodações.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
INÍCIO: TIPO 2 - Selecionar uma única acomodações:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN
				
			IF @Id IS NOT NULL
			BEGIN

				WITH
				STATUSDEUMAUNICAACOMODACAO
				(
					
					 Codigo
					,ACO_ID_INT
					,ACO_NOME_STR
					,ST_ACOMOD_ID_INT
					,ST_ACOMOD_DESCRICAO_STR
					,INFO_ACOMOD_ID_INT
					,INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					,INFO_ACOMOD_CAPACIDADE_INT
					,INFO_ACOMOD_TIPO_DE_CAMA_STR
					,INFO_ACOMOD_PRECO_FLOAT
					,CAT_ACOMOD_ID_INT
					,CAT_ACOMOD_DESCRICAO_STR
				)

				AS

				(

					SELECT		 200
								,A.ACO_ID_INT
								,A.ACO_NOME_STR
								,SA.ST_ACOMOD_ID_INT
								,SA.ST_ACOMOD_DESCRICAO_STR
								,IA.INFO_ACOMOD_ID_INT
								,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
								,IA.INFO_ACOMOD_CAPACIDADE_INT
								,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
								,IA.INFO_ACOMOD_PRECO_FLOAT
								,CA.CAT_ACOMOD_ID_INT
								,CA.CAT_ACOMOD_DESCRICAO_STR								
					FROM		ACOMODACAO				AS A
					INNER JOIN	STATUS_ACOMODACAO		AS SA ON A.ACO_ST_ACOMOD_INT		= SA.ST_ACOMOD_ID_INT
					INNER JOIN	INFORMACOES_ACOMODACAO	AS IA ON A.ACO_INFO_ACOMOD_ID_INT	= IA.INFO_ACOMOD_ID_INT
					INNER JOIN	CATEGORIA_ACOMODACAO	AS CA ON CA.CAT_ACOMOD_ID_INT		= IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT
					WHERE		A.ACO_EXCLUIDO_BIT = 0

				)

				SELECT * FROM STATUSDEUMAUNICAACOMODACAO WHERE ACO_ID_INT = @Id;

			END;

		END;
/*************************************************************************************************************************************
FIM: TIPO 2 - Selecionar uma única acomodações.
*************************************************************************************************************************************/

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA OBTER ACOMODAÇÕES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA OBTER CHECK-INS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterCheckIns]
	 @IdReserva int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter check-ins (no momento, apenas na API).
Data.....: 08/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

		WITH

		[CheckInResultado]

		(

			 CHECKIN_ID_INT
			,RES_ID_INT
			,RES_DATA_RESERVA_DATE
			,RES_DATA_CHECKIN_DATE
			,RES_DATA_CHECKOUT_DATE
			,RES_ACOMPANHANTES_ID_INT
			,RES_VALOR_UNITARIO_FLOAT
			,RES_VALOR_RESERVA_FLOAT
			,ST_RES_ID_INT
			,ST_RES_DESCRICAO_STR
			,HSP_ID_INT
			,HSP_NOME_STR
			,HSP_CPF_CHAR
			,ACO_ID_INT
			,ACO_NOME_STR
			,ST_ACOMOD_ID_INT
			,ST_ACOMOD_DESCRICAO_STR
			,INFO_ACOMOD_METROS_QUADRADOS_FLOAT
			,INFO_ACOMOD_CAPACIDADE_INT
			,INFO_ACOMOD_TIPO_DE_CAMA_STR
			,INFO_ACOMOD_PRECO_FLOAT
			,CAT_ACOMOD_ID_INT
			,CAT_ACOMOD_DESCRICAO_STR
			,TPPGTO_ID_INT
			,TPPGTO_TIPO_PAGAMENTO_STR
			,ST_PGTO_ID_INT
			,ST_PGTO_DESCRICAO_STR
			,USU_NOME_USUARIO_STR

		)

		AS

		(

			SELECT		 C.CHECKIN_ID_INT
						,R.RES_ID_INT
						,R.RES_DATA_RESERVA_DATE
						,R.RES_DATA_CHECKIN_DATE
						,R.RES_DATA_CHECKOUT_DATE
						,R.RES_ACOMPANHANTES_ID_INT
						,IA.INFO_ACOMOD_PRECO_FLOAT		AS RES_VALOR_UNITARIO_FLOAT
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
						,U.USU_NOME_USUARIO_STR
			FROM		CHECKIN					AS C
			INNER JOIN	RESERVA					AS R	ON C.CHECKIN_RES_ID_INT				= R.RES_ID_INT
			INNER JOIN	STATUS_RESERVA			AS SR	ON R.RES_ST_RES_INT					= SR.ST_RES_ID_INT
			INNER JOIN	ACOMODACAO				AS A	ON R.RES_ACO_ID_INT					= A.ACO_ID_INT
			INNER JOIN	STATUS_ACOMODACAO		AS SA	ON A.ACO_ST_ACOMOD_INT				= SA.ST_ACOMOD_ID_INT
			INNER JOIN	INFORMACOES_ACOMODACAO	AS IA	ON A.ACO_INFO_ACOMOD_ID_INT			= IA.INFO_ACOMOD_ID_INT
			INNER JOIN	CATEGORIA_ACOMODACAO	AS CA	ON IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT = CA.CAT_ACOMOD_ID_INT
			INNER JOIN	HOSPEDE					AS H	ON R.RES_HSP_ID_INT					= H.HSP_ID_INT
			INNER JOIN	PAGAMENTO_RESERVA		AS PR	ON PR.PGTO_RES_ID_INT				= R.RES_ID_INT
			INNER JOIN	TIPO_PAGAMENTO			AS TP	ON PR.PGTO_RES_TPPGTO_ID_INT		= TP.TPPGTO_ID_INT
			INNER JOIN	STATUS_PAGAMENTO		AS SP	ON PR.PGTO_RES_ST_PGTO_ID_INT		= SP.ST_PGTO_ID_INT
			INNER JOIN	FUNCIONARIO				AS F	ON C.CHECKIN_FUNC_ID_INT			= F.FUNC_ID_INT
			INNER JOIN	USUARIO					AS U	ON F.FUNC_USU_ID_INT				= U.USU_ID_INT
			WHERE		C.CHECKIN_RES_ID_INT	= @IdReserva
			  AND		C.CHECKIN_EXCLUIDO_BIT	= 0
			  AND		R.RES_EXCLUIDO_BIT		= 0

		)

		SELECT * FROM CheckInResultado;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA OBTER CHECK-INS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA OBTER CHECK-OUTS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterCheckOut]
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
/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA OBTER CHECK-OUTS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA OBTER FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterFNRH]
	 @Id		int
	,@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter FNRHs (no momento, apenas na API).
Data.....: 26/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE	@IdHospede	int;
		DECLARE	@IdFNRH		int;

/*************************************************************************************************************************************
INÍCIO: Obter todas as FNRHs de um hóspede:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			SET @IdHospede = @Id;

			WITH

			[GetTipo1]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		 F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_ID_INT = @IdHospede

			)

			SELECT * FROM GetTipo1;

		END;
/*************************************************************************************************************************************
FIM: Obter todas as FNRHs de um hóspede.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
INÍCIO: Obter última FNRH por hóspede:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN

			SET @IdHospede = @Id;

			WITH

			[GetTipo2]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		TOP 1
				
							F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_ID_INT = @IdHospede
				ORDER BY	F.FNRH_ID_INT DESC

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
FIM: Obter última FNRH por hóspede.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Obter FNRH por id:
*************************************************************************************************************************************/
		IF @Tipo = 3
		BEGIN
			
			SET @IdFNRH = @Id;

			WITH

			[GetTipo3]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT	= 0
				AND			F.FNRH_ID_INT = @IdFNRH

			)

			SELECT * FROM GetTipo3;

		END;
/*************************************************************************************************************************************
FIM: Obter FNRH por id.
*************************************************************************************************************************************/

	END
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA OBTER FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA OBTER FUNCIONARIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterFuncionarios]
	 @Cpf			nchar(11)	= NULL
	,@IdFuncionario	int			= NULL
	,@Pagina		int			= NULL
	,@Quantidade	int			= NULL
	,@Tipo			int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada obter todos os funcionários (até o momento, procedure utilizada na API).

Sumário..:
- Tipo 1: obtém todos os funcionários, caso as variáveis @Pagina e @Quantidade não forem nulas;
  Tipo 1: obtém um funcionário pelo id, caso as variáveis @Pagina e Quantidade sejam nulas, e @IdFuncionario não seja nulo;
- Tipo 2: obtém um funcionário através do CPF.

Data.....: 29/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
1 - INÍCIO -- Obter todos os funcionários:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

		IF ((@Pagina IS NOT NULL) AND (@Quantidade IS NOT NULL) AND (@IdFuncionario IS NULL))
			BEGIN

				WITH

				[GetTipo1]

				(

					 FUNC_ID_INT
					,FUNC_NOME_STR
					,FUNC_CPF_CHAR
					,FUNC_NACIONALIDADE_STR
					,FUNC_DTNASC_DATE
					,FUNC_SEXO_CHAR
					,FUNC_RG_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_SALARIO_FLOAT
					,USU_NOME_USUARIO_STR
					,CATACESSO_DESCRICAO_STR
					,CONT_EMAIL_STR
					,CONT_CELULAR_CHAR
					,CONT_TELEFONE_CHAR
					,END_CEP_CHAR
					,END_LOGRADOURO_STR
					,END_NUMERO_CHAR
					,END_COMPLEMENTO_STR
					,END_BAIRRO_STR
					,END_CIDADE_STR
					,END_ESTADO_CHAR
					,END_PAIS_STR
					,DADOSBC_BANCO_STR
					,DADOSBC_AGENCIA_STR
					,DADOSBC_NUMERO_CONTA_STR

				)

				AS

				(

					SELECT		 F.FUNC_ID_INT
								,F.FUNC_NOME_STR
								,F.FUNC_CPF_CHAR
								,F.FUNC_NACIONALIDADE_STR
								,F.FUNC_DTNASC_DATE
								,F.FUNC_SEXO_CHAR
								,F.FUNC_RG_CHAR
								,F.FUNC_CARGO_STR
								,F.FUNC_SETOR_STR
								,F.FUNC_SALARIO_FLOAT
								,U.USU_NOME_USUARIO_STR
								,CA.CATACESSO_DESCRICAO_STR
								,C.CONT_EMAIL_STR
					
								,CASE
									WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
										THEN 'Sem celular'
									ELSE TRIM(C.CONT_CELULAR_CHAR)
								 END AS CONT_CELULAR_CHAR
					
								,CASE
									WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
										THEN 'Sem telefone'
									ELSE TRIM(C.CONT_TELEFONE_CHAR)
								 END AS CONT_TELEFONE_CHAR
					
								,E.END_CEP_CHAR
								,E.END_LOGRADOURO_STR
								,E.END_NUMERO_CHAR
					
								,CASE
									WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
										THEN 'Complemento não cadastrado'
									ELSE E.END_COMPLEMENTO_STR
								 END AS END_COMPLEMENTO_STR
					
								,E.END_BAIRRO_STR
								,E.END_CIDADE_STR
								,E.END_ESTADO_CHAR
								,E.END_PAIS_STR

								,CASE
									WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
										THEN 'Banco não informado'
									ELSE DB.DADOSBC_BANCO_STR
								 END AS DADOSBC_BANCO_STR

								,CASE
									WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
										THEN 'Agência não informada'
									ELSE DB.DADOSBC_AGENCIA_STR
								 END AS DADOSBC_AGENCIA_STR

								,CASE
									WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
										THEN 'Número da conta não informado.'
									ELSE DB.DADOSBC_NUMERO_CONTA_STR
								 END AS DADOSBC_NUMERO_CONTA_STR

					FROM		FUNCIONARIO			AS F
					INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
					INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
					INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
					INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
					INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
					WHERE		F.FUNC_EXCLUIDO_BIT = 0
					ORDER BY	F.FUNC_ID_INT OFFSET ((@Pagina - 1) * @Quantidade) ROWS FETCH NEXT @Quantidade ROWS ONLY

				)

				SELECT * FROM GetTipo1;

			END;

		ELSE

			BEGIN

				WITH

				[GetTipo1]

				(

					 FUNC_ID_INT
					,FUNC_NOME_STR
					,FUNC_CPF_CHAR
					,FUNC_NACIONALIDADE_STR
					,FUNC_DTNASC_DATE
					,FUNC_SEXO_CHAR
					,FUNC_RG_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_SALARIO_FLOAT
					,USU_NOME_USUARIO_STR
					,CATACESSO_DESCRICAO_STR
					,CONT_EMAIL_STR
					,CONT_CELULAR_CHAR
					,CONT_TELEFONE_CHAR
					,END_CEP_CHAR
					,END_LOGRADOURO_STR
					,END_NUMERO_CHAR
					,END_COMPLEMENTO_STR
					,END_BAIRRO_STR
					,END_CIDADE_STR
					,END_ESTADO_CHAR
					,END_PAIS_STR
					,DADOSBC_BANCO_STR
					,DADOSBC_AGENCIA_STR
					,DADOSBC_NUMERO_CONTA_STR

				)

				AS

				(

				SELECT		 F.FUNC_ID_INT
							,F.FUNC_NOME_STR
							,F.FUNC_CPF_CHAR
							,F.FUNC_NACIONALIDADE_STR
							,F.FUNC_DTNASC_DATE
							,F.FUNC_SEXO_CHAR
							,F.FUNC_RG_CHAR
							,F.FUNC_CARGO_STR
							,F.FUNC_SETOR_STR
							,F.FUNC_SALARIO_FLOAT
							,U.USU_NOME_USUARIO_STR
							,CA.CATACESSO_DESCRICAO_STR
							,C.CONT_EMAIL_STR
				
							,CASE
								WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
									THEN 'Sem celular'
								ELSE TRIM(C.CONT_CELULAR_CHAR)
							 END AS CONT_CELULAR_CHAR
					
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								ELSE TRIM(C.CONT_TELEFONE_CHAR)
							 END AS CONT_TELEFONE_CHAR
				
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
				
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
				
							,E.END_BAIRRO_STR
							,E.END_CIDADE_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR

							,CASE
								WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
									THEN 'Banco não informado'
								ELSE DB.DADOSBC_BANCO_STR
							 END AS DADOSBC_BANCO_STR

							,CASE
								WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
									THEN 'Agência não informada'
								ELSE DB.DADOSBC_AGENCIA_STR
							 END AS DADOSBC_AGENCIA_STR

							,CASE
								WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
									THEN 'Número da conta não informado.'
								ELSE DB.DADOSBC_NUMERO_CONTA_STR
							 END AS DADOSBC_NUMERO_CONTA_STR

				FROM		FUNCIONARIO			AS F
				INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
				INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
				INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
				INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
				INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
				WHERE		F.FUNC_EXCLUIDO_BIT = 0
				AND			F.FUNC_ID_INT = @IdFuncionario

				)

				SELECT * FROM GetTipo1;

			END;

		END;
/*************************************************************************************************************************************
1 - FIM -- Obter todos os funcionários.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
2 - INÍCIO -- Obter funcionário por CPF:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN

			WITH

			[GetTipo2]

			(

				 FUNC_ID_INT
				,FUNC_NOME_STR
				,FUNC_CPF_CHAR
				,FUNC_NACIONALIDADE_STR
				,FUNC_DTNASC_DATE
				,FUNC_SEXO_CHAR
				,FUNC_RG_CHAR
				,FUNC_CARGO_STR
				,FUNC_SETOR_STR
				,FUNC_SALARIO_FLOAT
				,USU_NOME_USUARIO_STR
				,CATACESSO_DESCRICAO_STR
				,CONT_EMAIL_STR
				,CONT_CELULAR_CHAR
				,CONT_TELEFONE_CHAR
				,END_CEP_CHAR
				,END_LOGRADOURO_STR
				,END_NUMERO_CHAR
				,END_COMPLEMENTO_STR
				,END_BAIRRO_STR
				,END_CIDADE_STR
				,END_ESTADO_CHAR
				,END_PAIS_STR
				,DADOSBC_BANCO_STR
				,DADOSBC_AGENCIA_STR
				,DADOSBC_NUMERO_CONTA_STR

			)

			AS

			(

				SELECT		 F.FUNC_ID_INT
							,F.FUNC_NOME_STR
							,F.FUNC_CPF_CHAR
							,F.FUNC_NACIONALIDADE_STR
							,F.FUNC_DTNASC_DATE
							,F.FUNC_SEXO_CHAR
							,F.FUNC_RG_CHAR
							,F.FUNC_CARGO_STR
							,F.FUNC_SETOR_STR
							,F.FUNC_SALARIO_FLOAT
							,U.USU_NOME_USUARIO_STR
							,CA.CATACESSO_DESCRICAO_STR
							,C.CONT_EMAIL_STR
				
							,CASE
								WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
									THEN 'Sem celular'
								ELSE TRIM(C.CONT_CELULAR_CHAR)
							 END AS CONT_CELULAR_CHAR
					
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								ELSE TRIM(C.CONT_TELEFONE_CHAR)
							 END AS CONT_TELEFONE_CHAR
				
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
				
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
				
							,E.END_BAIRRO_STR
							,E.END_CIDADE_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR

							,CASE
								WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
									THEN 'Banco não informado'
								ELSE DB.DADOSBC_BANCO_STR
							 END AS DADOSBC_BANCO_STR

							,CASE
								WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
									THEN 'Agência não informada'
								ELSE DB.DADOSBC_AGENCIA_STR
							 END AS DADOSBC_AGENCIA_STR

							,CASE
								WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
									THEN 'Número da conta não informado.'
								ELSE DB.DADOSBC_NUMERO_CONTA_STR
							 END AS DADOSBC_NUMERO_CONTA_STR

				FROM		FUNCIONARIO			AS F
				INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
				INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
				INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
				INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
				INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
2 - FIM -- Obter funcionário por CPF.
*************************************************************************************************************************************/

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA OBTER FUNCIONARIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
7 - PROCEDURE UTILIZADA PARA OBTER HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterHospedes]
	@Pagina		int			= NULL,
	@Quantidade int			= NULL,
	@IdHospede	int			= NULL,
	@Cpf		char(11)	= NULL,
	@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada obter todos os hóspedes.
Data.....: 21/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
INÍCIO: Obter lista de hóspedes, com base na quantidade e páginas providas pela query:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			IF ((@Pagina IS NOT NULL) AND (@Quantidade IS NOT NULL) AND (@IdHospede IS NULL))
				BEGIN

					WITH

					[GetTipo1]

					(

						 HSP_ID_INT
						,HSP_NOME_STR
						,HSP_CPF_CHAR
						,HSP_DTNASC_DATE
						,USU_NOME_USUARIO_STR
						,CONT_EMAIL_STR
						,CONT_CELULAR_CHAR
						,CONT_TELEFONE_CHAR
						,END_CEP_CHAR
						,END_LOGRADOURO_STR
						,END_NUMERO_CHAR
						,END_COMPLEMENTO_STR	
						,END_CIDADE_STR
						,END_BAIRRO_STR
						,END_ESTADO_CHAR
						,END_PAIS_STR

					)

					AS

					(

						SELECT		 H.HSP_ID_INT
									,H.HSP_NOME_STR
									,H.HSP_CPF_CHAR
									,H.HSP_DTNASC_DATE

									,CASE
										WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
											THEN 'Sem nome de usuário'
										ELSE U.USU_NOME_USUARIO_STR
									 END AS USU_NOME_USUARIO_STR
									
									
									,C.CONT_EMAIL_STR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem celular'
										WHEN LEN(C.CONT_CELULAR_CHAR) = 13
											THEN '+'									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
									 END AS CONT_CELULAR_CHAR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
											THEN '+'									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
									 END AS CONT_TELEFONE_CHAR
							
									,E.END_CEP_CHAR
									,E.END_LOGRADOURO_STR
									,E.END_NUMERO_CHAR
							
									,CASE
										WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
											THEN 'Complemento não cadastrado'
										ELSE E.END_COMPLEMENTO_STR
									 END AS END_COMPLEMENTO_STR
							
									,E.END_CIDADE_STR
									,E.END_BAIRRO_STR
									,E.END_ESTADO_CHAR
									,E.END_PAIS_STR
						FROM		HOSPEDE		AS H
						LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
						INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
						INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
						WHERE		H.HSP_EXCLUIDO_BIT = 0
						ORDER BY	H.HSP_ID_INT OFFSET ((@Pagina - 1) * @Quantidade) ROWS FETCH NEXT @Quantidade ROWS ONLY

					)

					SELECT * FROM GetTipo1;

				END
			ELSE
				BEGIN
					
					WITH

					[GetTipo1]

					(

						 HSP_ID_INT
						,HSP_NOME_STR
						,HSP_CPF_CHAR
						,HSP_DTNASC_DATE
						,USU_NOME_USUARIO_STR
						,CONT_EMAIL_STR
						,CONT_CELULAR_CHAR
						,CONT_TELEFONE_CHAR
						,END_CEP_CHAR
						,END_LOGRADOURO_STR
						,END_NUMERO_CHAR
						,END_COMPLEMENTO_STR	
						,END_CIDADE_STR
						,END_BAIRRO_STR
						,END_ESTADO_CHAR
						,END_PAIS_STR

					)

					AS

					(

						SELECT		 H.HSP_ID_INT
									,H.HSP_NOME_STR
									,H.HSP_CPF_CHAR
									,H.HSP_DTNASC_DATE

									,CASE
										WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
											THEN 'Sem nome de usuário'
										ELSE U.USU_NOME_USUARIO_STR
									 END AS USU_NOME_USUARIO_STR
									
									,C.CONT_EMAIL_STR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_CELULAR_CHAR) = 13
											THEN '+'									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
									 END AS CONT_CELULAR_CHAR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
											THEN '+'									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
									 END AS CONT_TELEFONE_CHAR
							
									,E.END_CEP_CHAR
									,E.END_LOGRADOURO_STR
									,E.END_NUMERO_CHAR
							
									,CASE
										WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
											THEN 'Complemento não cadastrado'
										ELSE E.END_COMPLEMENTO_STR
									 END AS END_COMPLEMENTO_STR
							
									,E.END_CIDADE_STR
									,E.END_BAIRRO_STR
									,E.END_ESTADO_CHAR
									,E.END_PAIS_STR
						FROM		HOSPEDE		AS H
						LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
						INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
						INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
						WHERE		H.HSP_EXCLUIDO_BIT = 0
						AND			H.HSP_ID_INT = @IdHospede

					)

					SELECT * FROM GetTipo1;

				END;

		END;
/*************************************************************************************************************************************
FIM: Obter lista de hóspedes, com base na quantidade e páginas providas pela query.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Obter um hóspedes através do CPF:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN
			
			WITH
			
			[GetTipo2]

			(

				 HSP_ID_INT
				,HSP_NOME_STR
				,HSP_CPF_CHAR
				,HSP_DTNASC_DATE
				,USU_NOME_USUARIO_STR
				,CONT_EMAIL_STR
				,CONT_CELULAR_CHAR
				,CONT_TELEFONE_CHAR
				,END_CEP_CHAR
				,END_LOGRADOURO_STR
				,END_NUMERO_CHAR
				,END_COMPLEMENTO_STR	
				,END_CIDADE_STR
				,END_BAIRRO_STR
				,END_ESTADO_CHAR
				,END_PAIS_STR

			)

			AS

			(

				SELECT		 H.HSP_ID_INT
							,H.HSP_NOME_STR
							,H.HSP_CPF_CHAR
							,H.HSP_DTNASC_DATE

							,CASE
								WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
									THEN 'Sem nome de usuário'
								ELSE U.USU_NOME_USUARIO_STR
							 END AS USU_NOME_USUARIO_STR
							
							,C.CONT_EMAIL_STR
							
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								WHEN LEN(C.CONT_CELULAR_CHAR) = 13
									THEN '+'									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
										 ' ('									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
								ELSE	 '('									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
							 END AS CONT_CELULAR_CHAR
							
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
									THEN '+'									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
										 ' ('									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
										 ') '									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
								ELSE	 '('									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
							 END AS CONT_TELEFONE_CHAR
							
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
							
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
							
							,E.END_CIDADE_STR
							,E.END_BAIRRO_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR
				FROM		HOSPEDE		AS H
				LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
				INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
				INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
				WHERE		H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_CPF_CHAR = @Cpf

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
FIM: Obter um hóspedes através do CPF.
*************************************************************************************************************************************/

	END
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
7 - PROCEDURE UTILIZADA PARA OBTER HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
8 - PROCEDURE UTILIZADA PARA OBTER RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterReserva]
	 @IdReserva	int		 = NULL
	,@IdHospede	int		 = NULL
	,@Cpf		char(11) = NULL
	,@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter reservas (no momento, apenas na API).
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


/*************************************************************************************************************************************
CASO 2 - Caso o tipo selecionado seja o segundo:
*************************************************************************************************************************************/
		IF @Tipo = 3
		BEGIN

			WITH

			ObterReservaPorCPF
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

			)

			SELECT * FROM ObterReservaPorCPF WHERE HSP_CPF_CHAR = @Cpf ORDER BY RES_ID_INT DESC;

		END;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
8 - PROCEDURE UTILIZADA PARA OBTER RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
9 - PROCEDURE UTILIZADA PARA OBTER PERGUNTAS DE SEGURANÇA
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspPerguntaDeSeguranca]
	 @Cpf		nchar(11)
	,@Reposta	nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, para validar se a resposta inserida pelo usuário, na funcionalidade Esqueci
		   Minha Senha, está em acordo com a cadastrada na base de dados.
Data.....: 23/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @RespostaCadastrada	nvarchar(max);
		DECLARE @Mensagem			nvarchar(255);
		DECLARE @Codigo				int;

/*************************************************************************************************************************************
SELECT principal que atribui valor às variáveis:
*************************************************************************************************************************************/
		SELECT		@RespostaCadastrada = P.PERG_SEG_RESPOSTA_STR
		FROM		FUNCIONARIO			AS F
		INNER JOIN	USUARIO				AS U ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
		INNER JOIN	PERGUNTA_SEGURANCA	AS P ON U.USU_ID_INT		= P.PERG_SEG_USU_ID_INT
		WHERE		F.FUNC_CPF_CHAR = @Cpf;

/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		IF RTRIM(LTRIM(@Reposta)) = @RespostaCadastrada
			BEGIN

				SET @Mensagem = 'A resposta está em acordo com a resposta cadastrada.';

				SET @Codigo = 200;

			END;
			
		ELSE

			BEGIN

				SET @Mensagem = 'A resposta não está de acordo com a resposta cadastrada.';

				SET @Codigo = 404;

			END;
/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/

		SELECT @Mensagem AS Mensagem, @Codigo AS Codigo;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
9 - PROCEDURE UTILIZADA PARA OBTER PERGUNTAS DE SEGURANÇA
**************************************************************************************************************************************
*************************************************************************************************************************************/