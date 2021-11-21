USE RECPAPAGAIOS;
GO


/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA CADASTRAR ALERTAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspCadastrarAlerta]
	 @Titulo		varchar(50)
	,@Corpo			varchar(200)
	,@IdFuncionario	int
	,@Json			varchar(500)
AS
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastrar novos alertas.
Data.....: 13/10/2021
*************************************************************************************************************************************/
	BEGIN
		
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(200);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @Codigo		int;
		DECLARE @IdAlerta	int;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de alertas.'
		
		SET @Entidade	= 'Alertas';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o id do funcionário corresponde a um funcionário na base de dados:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não foi encontrado funcionário para o id ' + CAST(@IdFuncionario AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela ALERTAS.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY
				
					INSERT INTO ALERTAS
					VALUES
					(
						 @Titulo
						,@Corpo
						,@IdFuncionario
						,0
						,GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdAlerta = @@IDENTITY;

		END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ALERTAS.
*************************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Alerta cadastrado com sucesso no id ' + CAST(@IdAlerta AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdAlerta,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA CADASTRAR ALERTAS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA CADASTRAR CHECK-INS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspCadastrarCheckIn]
	 @IdReserva		int
	,@IdFuncionario	int
	,@CheckOutJson	varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para executar o check-in sobre reservas (no momento, apenas na aplicação desktop).
Data.....: 27/09/2021

-- ALTERAÇÕES:
-- Correção #01 (2021-11-20):
-- Toda reserva que estiver com o status de pagamento diferente de "Aprovado", será atualizado para "Aprovado".
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @DescricaoPagamento		nvarchar(255);
		DECLARE @StatusPagamento		nvarchar(255);
		DECLARE @StatusReserva			nvarchar(255);
		DECLARE @Entidade				nvarchar(255);
		DECLARE @Acao					nvarchar(255);
		DECLARE @DataCheckIn			date;
		DECLARE @Codigo					int;
		DECLARE @IdStatusPagamento		int;
		DECLARE @IdStatusReserva		int;
		DECLARE @IdReservaCadastrada	int;
		DECLARE @IdCheckIn				int;
		DECLARE @IdCheckOut				int;
		DECLARE @IdPagamento			int;
		DECLARE @IdAcomodacao			int;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro do check-out referente à reserva ' + CAST(@IdReserva AS VARCHAR) + '.';
		
		SET @Entidade	= 'Check-in';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @CheckOutJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
SELECT prinicpal que atribui valor às variáveis:
*************************************************************************************************************************************/
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@IdCheckIn				= CI.CHECKIN_ID_INT
					,@IdCheckOut			= CO.CHECKOUT_ID_INT
					,@IdPagamento			= PR.PGTO_RES_ID_INT
					,@IdAcomodacao			= R.RES_ACO_ID_INT
					,@DataCheckIn			= R.RES_DATA_CHECKIN_DATE
					,@DescricaoPagamento	= TP.TPPGTO_TIPO_PAGAMENTO_STR
					,@IdStatusPagamento		= PR.PGTO_RES_ST_PGTO_ID_INT
					,@StatusPagamento		= ST.ST_PGTO_DESCRICAO_STR
					,@IdStatusReserva		= R.RES_ST_RES_INT
					,@StatusReserva			= SR.ST_RES_DESCRICAO_STR
		FROM		RESERVA				AS R
		INNER JOIN	PAGAMENTO_RESERVA	AS PR ON R.RES_ID_INT				= PR.PGTO_RES_RES_ID_INT
		INNER JOIN	STATUS_PAGAMENTO	AS ST ON PR.PGTO_RES_ST_PGTO_ID_INT	= ST.ST_PGTO_ID_INT
		INNER JOIN	STATUS_RESERVA		AS SR ON R.RES_ST_RES_INT			= SR.ST_RES_ID_INT
		INNER JOIN	TIPO_PAGAMENTO		AS TP ON PR.PGTO_RES_TPPGTO_ID_INT	= TP.TPPGTO_ID_INT
		LEFT JOIN	CHECKIN				AS CI ON R.RES_ID_INT				= CI.CHECKIN_RES_ID_INT
		LEFT JOIN	CHECKOUT			AS CO ON CI.CHECKIN_ID_INT			= CO.CHECKOUT_CHECKIN_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;


		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '-------------------------------------- PROCEDIMENTO DE EXECUÇÃO DE CHECK-IN -----------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
Imprimindo o valor das variáveis para validação interna:
*************************************************************************************************************************************/
		PRINT 'Id da reserva: ' + CAST(@IdReservaCadastrada AS VARCHAR);
		PRINT 'Data de check-in: ' + CAST(@DataCheckIn AS VARCHAR);
		PRINT 'Data de check-out: ' + CASE WHEN @IdCheckOut IS NULL THEN 'Não há check-out.' ELSE 'CAST(@IdCheckOut AS VARCHAR)' END;
		PRINT 'Id do pagamento: ' + CAST(@IdPagamento AS VARCHAR);
		PRINT 'Descrição do pagamento: ' + @DescricaoPagamento;
		PRINT 'Status do pagamento: ' + @DescricaoPagamento;
		PRINT 'Status da reserva: ' + @StatusReserva;

/*************************************************************************************************************************************
Validando se a reserva existe no sistema:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'Não existe, no sistema, reserva com o id ' + CAST(@IdReserva AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @CheckOutJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Validando se a reserva está cancelada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdStatusReserva <> 1
			BEGIN
				SET @Codigo = 409;	
				SET @Mensagem = 'A reserva está ' + @StatusReserva + '. Sendo assim, não é possível executar o check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a reserva já possui check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdCheckIn IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' já possui check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;
		
/*************************************************************************************************************************************
Verificando se a reserva já possui check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdCheckOut IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' já possui check-out.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;
		
/*************************************************************************************************************************************
Verificando se a data de check-in da reserva é igual a data do dia (GETDATE()):
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @DataCheckIn < CONVERT(date, GETDATE(), 121)
			BEGIN
				SET @Codigo = 422;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' passou da data de check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;

		END;

/*************************************************************************************************************************************
Verificando os dados de pagamento da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @IdStatusPagamento <> 1
			BEGIN
				
				-- Correção #01:
				-- 2021-11-20
				BEGIN TRANSACTION;

					BEGIN TRY;

						UPDATE	PAGAMENTO_RESERVA
						SET
								PGTO_RES_ST_PGTO_ID_INT = 1
						WHERE	PGTO_RES_RES_ID_INT = @IdReserva;

					END TRY

					BEGIN CATCH
						
						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();

						IF @@TRANCOUNT > 0 
							ROLLBACK TRANSACTION;

						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @CheckOutJson,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;

		END;

/*************************************************************************************************************************************
Verificando se o funcionário informado existe no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'O id ' + CAST(@IdFuncionario AS VARCHAR) + ' não corresponde a um funcionário.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;
		

/*************************************************************************************************************************************
********************************************* INSERINDO E ATUALIZANDO AS DEVIDAS TABELAS: ********************************************
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela CHECKIN:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO CHECKIN
					VALUES
					(
						 @IdReserva
						,@IdFuncionario
						,0
						,GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @CheckOutJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Inserindo na tabela CHECKIN.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							RES_ST_RES_INT	= 2
					WHERE	RES_ID_INT		= @IdReserva;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @CheckOutJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SELECT @IdCheckIn = CHECKIN_ID_INT FROM CHECKIN WHERE CHECKIN_RES_ID_INT = @IdReserva
/*************************************************************************************************************************************
FIM: Atualizando na tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ACOMODACAO:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	ACOMODACAO
					SET
							ACO_ST_ACOMOD_INT = 2
					WHERE	ACO_ID_INT = @IdAcomodacao;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @CheckOutJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

/*************************************************************************************************************************************
FIM: Atualizando na tabela ACOMODACAO.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
********************************************* INSERINDO E ATUALIZANDO AS DEVIDAS TABELAS. ********************************************
*************************************************************************************************************************************/
		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '-------------------------------------- PROCEDIMENTO DE EXECUÇÃO DE CHECK-IN -----------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';


		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Check-in da reserva ' + CAST(@IdReserva AS VARCHAR) + ' realizado com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @CheckOutJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdCheckIn,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA CADASTRAR CHECK-INS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA CADASTRAR CHECK-OUTS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspCadastrarCheckOut]
	 @IdReserva				int
	,@IdFuncionario			int
	,@PagamentoAdicional	bit
	,@TipoPagamento			int				= NULL
	,@ValorAdicional		float(2)		= NULL
	,@CheckOutJson			nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para executar o check-out sobre reservas (no momento, apenas na API).
Data.....: 05/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @IdCheckIn				int;
		DECLARE @IdCheckOut				int;
		DECLARE @IdPagamentoCheckOut	int;
		DECLARE @StatusCode				int;
		DECLARE @Codigo					int;
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @StatusPagamento		int;
		DECLARE @DescricaoPagamento		nvarchar(50);
		DECLARE @ValorReserva			float(2);
		DECLARE @ValorTotal				float(2);
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo = 0;
		
		SET @Mensagem	= 'Início da análise para cadastro do check-out referente à reserva ' + CAST(@IdReserva AS VARCHAR) + '.';
		
		SET @Entidade	= 'Check-out';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @CheckOutJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= 0;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
Validando caso os parâmetros @TipoPagamento ou @ValorAdicional estejam nulos:
*************************************************************************************************************************************/
		IF @PagamentoAdicional = 1 AND @TipoPagamento IS NULL
		BEGIN
			SET @Codigo = 422
			SET @Mensagem = 'O tipo de pagamento não pode estar nulo quando houver pagamento adicional.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @CheckOutJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
		BEGIN
			IF @PagamentoAdicional = 1 AND @ValorAdicional IS NULL
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'Os valores adicionais não podem estar nulos quando houver pagamento adicional.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se a reserva existe no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM RESERVA WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET @Mensagem = 'O id ' + CAST(@IdReserva AS VARCHAR) + ' não corresponde a uma reserva.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;
		

/*************************************************************************************************************************************
Validando se o funcionário existe no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET @Mensagem = 'O id ' + CAST(@IdFuncionario AS VARCHAR) + ' não corresponde a um funcionário.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se a reserva possui check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @IdCheckIn = CHECKIN_ID_INT FROM CHECKIN WHERE CHECKIN_RES_ID_INT = @IdReserva AND CHECKIN_EXCLUIDO_BIT = 0;

			IF @IdCheckIn IS NULL	
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' não possui check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se, no check-in, pagamentos adicionais serão feitos:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @IdCheckOut = CHECKOUT_ID_INT FROM CHECKOUT WHERE CHECKOUT_CHECKIN_ID_INT = @IdCheckIn AND CHECKOUT_EXCLUIDO_BIT = 0;

			IF @IdCheckOut IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' já possui check-out: ' + CAST(@IdCheckOut AS VARCHAR) + '.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se a reserva está com algum pagamento pendente:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @StatusPagamento = PGTO_RES_ST_PGTO_ID_INT FROM PAGAMENTO_RESERVA WHERE PGTO_RES_RES_ID_INT = @IdReserva;

			SELECT @DescricaoPagamento = ST_PGTO_DESCRICAO_STR FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = @StatusPagamento;

			IF @StatusPagamento <> 1
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' está com o status ' + @DescricaoPagamento + '.'
							  + ' Portanto, não é possível prosseguir com o check-out.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Atribuindo valor à variável @ValorTotal:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @PagamentoAdicional = 1 AND @TipoPagamento IS NOT NULL AND @ValorAdicional IS NOT NULL
				BEGIN

					-- CHECK OUT COM PAGAMENTO ADICIONAL.

					SELECT @ValorReserva = RES_VALOR_RESERVA_FLOAT FROM RESERVA WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0;

					SET @ValorTotal = @ValorReserva + @ValorAdicional;

				END;
	
			ELSE

				BEGIN

					-- CHECK OUT SEM PAGAMENTO ADICIONAL.

					SELECT @ValorTotal = RES_VALOR_RESERVA_FLOAT FROM RESERVA WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0;

					SET @ValorAdicional = 0;

				END;
		END;

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela de CHECKOUT:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO CHECKOUT
					VALUES
					(
						@ValorAdicional,
						@ValorTotal,
						@IdCheckIn,
						@IdFuncionario,
						0,
						GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @CheckOutJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdCheckOut = @@IDENTITY;

/*************************************************************************************************************************************
FIM: Inserindo na tabela de CHECKOUT.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela de PAGAMENTO_CHECK_OUT:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @PagamentoAdicional = 1
				BEGIN
					
					-- COM PAGAMENTOS ADICIONAIS:
					
					/*********************************************************************************************************************
					* Validando caso os parâmetros @TipoPagamento ou @ValorAdicional estejam nulos: **************************************
					*********************************************************************************************************************/
					IF @TipoPagamento = 1 OR @TipoPagamento = 2
						BEGIN
							SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 1);
						END;
					ELSE
						IF @TipoPagamento = 3 OR @TipoPagamento = 4 OR @TipoPagamento = 5 OR @TipoPagamento = 6
						BEGIN
							SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 4);
						END;


					BEGIN TRANSACTION;

						BEGIN TRY

							INSERT INTO PAGAMENTO_CHECK_OUT
							VALUES
							(
								@TipoPagamento,
								@IdReserva,
								@StatusPagamento,
								@IdCheckOut,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();

							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @CheckOutJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdPagamentoCheckOut = @@IDENTITY;
				END;
			END;

/*************************************************************************************************************************************
FIM: Inserindo na tabela de PAGAMENTO_CHECK_OUT.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela de RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
				
					BEGIN TRY

						UPDATE	RESERVA
						SET
								RES_ST_RES_INT	= 3
						WHERE	RES_ID_INT		= @IdReserva;

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();

						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;

						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @CheckOutJson,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela de RESERVA.
*************************************************************************************************************************************/
		END;

/*************************************************************************************************************************************
Por último, executar procedure que validará e colocará como "Disponível" as acomodações não possuírem check-in dos próximos três dias:
*************************************************************************************************************************************/
		EXEC [uspMarcarAcomodacaoComoDisponivel];


/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Check-out com id ' + CAST(@IdCheckOut AS VARCHAR(8)) + ' gerado com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @CheckOutJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdCheckOut,
			@StatusCode	= @Codigo;
		END;
		
		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/
	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA CADASTRAR CHECK-OUTS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA CADASTRAR FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspCadastrarFNRH]
	 @IdHospede			int
	,@Profissao			nvarchar(255)
	,@Nacionalidade		nvarchar(255)
	,@Sexo				nchar(1)
	,@Rg				nchar(9)
	,@ProximoDestino	nvarchar(255)
	,@UltimoDestino		nvarchar(255)
	,@MotivoViagem		nvarchar(255)
	,@MeioDeTransporte	nvarchar(255)
	,@PlacaAutomovel	nvarchar(255)
	,@NumAcompanhantes	int
	,@FNRHJson			nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastrar novas FNRHs de um hóspede em sistema (até o momento, procedure utilizada na API).
Data.....: 25/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(255);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @IdFNRH		int;
		DECLARE @Codigo		int;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de FNRH.'
		
		SET @Entidade	= 'FNRH';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @FNRHJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o hóspede existe em sistema:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'Não existe, em sistema, hóspede cadastrado para o id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Setando as variáveis como nulas, caso tenham encontrado com os valores vazios ou string.
*************************************************************************************************************************************/
		IF (@Profissao  = '' OR @Profissao = 'string')
		BEGIN
			SET @Profissao = NULL;
		END;

		IF (@Nacionalidade  = '' OR @Nacionalidade = 'string')
		BEGIN
			SET @Nacionalidade = NULL;
		END;

		IF (@Sexo  = '' OR @Sexo = 'string')
		BEGIN
			SET @Sexo = NULL;
		END;

		IF (@Rg  = '' OR @Rg = 'string')
		BEGIN
			SET @Rg = NULL;
		END;

		IF (@ProximoDestino  = '' OR @ProximoDestino = 'string')
		BEGIN
			SET @ProximoDestino = NULL;
		END;

		IF (@UltimoDestino  = '' OR @UltimoDestino = 'string')
		BEGIN
			SET @UltimoDestino = NULL;
		END;

		IF (@MotivoViagem  = '' OR @MotivoViagem = 'string')
		BEGIN
			SET @MotivoViagem = NULL;
		END;

		IF (@MeioDeTransporte  = '' OR @MeioDeTransporte = 'string')
		BEGIN
			SET @MeioDeTransporte = NULL;
		END;

		IF (@PlacaAutomovel  = '' OR @PlacaAutomovel = 'string')
		BEGIN
			SET @PlacaAutomovel = NULL;
		END;


/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela FNRH.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO FNRH
					VALUES
					(
						@Profissao,
						@Nacionalidade,
						@Sexo,
						@Rg,
						@ProximoDestino,
						@UltimoDestino,
						@MotivoViagem,
						@MeioDeTransporte,
						@PlacaAutomovel,
						@NumAcompanhantes,
						@IdHospede,
						0,
						GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @FNRHJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdFNRH = @@IDENTITY;

		END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela FNRH.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'FNRH cadastrada com sucesso. Id: ' + CAST(@IdFNRH AS VARCHAR(8)) + ' referente ao hóspede ' + CAST(@IdHospede AS VARCHAR(8));
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFNRH,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA CADASTRAR FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA CADASTRAR FUNCIONARIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspCadastrarFuncionario]
	 @Nome				nvarchar(255)
	,@Cpf				nchar(11)
	,@Nacionalidade		nvarchar(255)
	,@DataDeNascimento	date
	,@Sexo				nchar(1)
	,@Rg				nchar(9)
	,@Cargo				nvarchar(50)
	,@Setor				nvarchar(50)
	,@Salario			float(2)
	,@Cep				nvarchar(255)
	,@Logradouro		nvarchar(255)
	,@Numero			nvarchar(8)
	,@Complemento		nvarchar(255)
	,@Bairro			nvarchar(255)
	,@Cidade			nvarchar(255)
	,@Estado			nvarchar(255)
	,@Pais				nvarchar(255)
	,@NomeUsuario		nvarchar(45)
	,@Senha				nvarchar(255)
	,@Email				nvarchar(50)
	,@Celular			nvarchar(13)
	,@Telefone			nvarchar(12)
	,@CategoriaAcesso	int
	,@Banco				nvarchar(50)
	,@Agencia			nvarchar(50)
	,@NumeroConta		nvarchar(50)
	,@PerguntaSeguranca nvarchar(255)
	,@RespostaSeguranca nvarchar(255)
	,@Json				varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastro de funcionários (até o momento, na aplicação desktop).
Data.....: 25/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem		VARCHAR(255);
		DECLARE @Entidade		VARCHAR(50);
		DECLARE @Acao			VARCHAR(50);
		DECLARE @Codigo			INT;
		DECLARE @IdUsuario		INT;
		DECLARE @IdEndereco		INT;
		DECLARE @IdContatos		INT;
		DECLARE @IdFuncionario	INT;


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de hóspede.';
		
		SET @Entidade	= 'Funcionário';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/


		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '---------------------------------------------- CADASTRO DE FUNCIONÁRIOS ---------------------------------------------';
/*************************************************************************************************************************************
INÍCIO: Validações do CPF:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_EXCLUIDO_BIT = 0) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'Já existe um funcionário cadastrado no sistema com o CPF ' + @Cpf + '.'

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;


		IF @Mensagem IS NULL
		BEGIN
			
			IF LEN(@Cpf) <> 11
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O CPF deve conter, exatamente, 11 caracteres.';
			END;

			IF @Cpf IS NULL OR @Cpf = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O CPF não pode estar vazio.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O CPF está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do CPF.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do nome de usuário:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM USUARIO WHERE USU_NOME_USUARIO_STR = @NomeUsuario) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'Já existe um usuário cadastrado com o nome de usuário ' + @NomeUsuario + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
		BEGIN
			IF @NomeUsuario IS NULL OR @NomeUsuario = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O nome de usuário não pode estar vazio.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O nome de usuário está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do nome de usuário.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações da data de nascimento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataDeNascimento IS NULL OR @DataDeNascimento = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A data de nascimento não pode estar vazia.';
			END;

			IF @DataDeNascimento >= DATEADD(YEAR, -18, GETDATE())
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'Não é permitido cadastro de funcionários menores de idade.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'A data de nascimento está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações da data de nascimento.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do RG:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Rg IS NULL OR @Rg = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O RG não pode estar vazio.';
			END;

			IF LEN(@Rg) <> 9
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O RG deve ter, exatamente, 9 caracteres.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'A RG está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do RG.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do CEP:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Cep IS NULL OR @Cep = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O CEP não pode estar vazio.';
			END;

			IF LEN(@Cep) <> 8
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O CEP deve conter, exatamente, 8 caracteres.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O CEP está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do CEP.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do telefone:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
				IF @Telefone = ''
					SET @Telefone = NULL;

				IF @Telefone IS NOT NULL
				BEGIN
					IF LEN(@Telefone) < 10 OR LEN(@Telefone) > 12
					BEGIN
						SET @Codigo = 422;
						SET @Mensagem = 'O tamanho do número de telefone deve ser entre 10 e 12 caracteres.';
					END;
				END;
			ELSE
				BEGIN
					PRINT 'Funcionário optou por não cadastrar um número de telefone fixo.';
				END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O telefone está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do telefone.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do celular:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Celular IS NULL OR @Celular = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O número de celular não pode estar vazio.';
			END;

			IF LEN(@Celular) < 11 OR LEN(@Celular) > 13
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O celular deve conter um tamanho entre 11 e 13 dígitos.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O celular está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do celular.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações dos dados restantes (se estão nulos e etc):
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @Nome IS NULL OR @Nome = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O nome do hóspede não pode estar vazio.';
			END;

			IF @Nacionalidade IS NULL OR @Nacionalidade = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A nacionalidade não pode estar vazia.';
			END;

			IF LEN(@Sexo) > 1 OR @Sexo IS NULL OR @Sexo = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O sexo deve conter, apenas, um caracter e não pode estar vazio.';
			END;

			IF @Cargo IS NULL OR @Cargo = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O cargo não pode estar vazio ou nulo.';
			END;

			IF @Setor IS NULL OR @Setor = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O setor não pode estar vazio ou nulo.';
			END;

			IF @Salario IS NULL OR @Salario = 0 OR @Salario < 0
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'Verificar o salário inserido, pois está inválido.';
			END;

			IF @Logradouro IS NULL OR @Logradouro = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O logradouro não pode estar vazio.';
			END;

			IF @Numero IS NULL OR @Numero = '' OR ISNUMERIC(@Numero) = 0
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'Verificar o número do endereço, pois está inválido.';
			END;

			IF @Bairro IS NULL OR @Bairro = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O bairro não pode estar vazio.';
			END;

			IF @Cidade IS NULL OR @Cidade = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O cidade não pode estar vazio.';
			END;

			IF @Estado IS NULL OR @Estado = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O estado não pode estar vazio.';
			END;

			IF LEN(@Estado) > 2
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O estado deve conter, apenas, 2 caracteres.';
			END;

			IF @Pais IS NULL OR @Pais = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O país não pode estar vazio.';
			END;

			IF @Senha IS NULL OR @Senha = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A senha não pode estar vazio.';
			END;

			IF @Email IS NULL OR @Email = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O e-mail não pode estar vazio.';
			END;

			IF @CategoriaAcesso IS NULL OR @CategoriaAcesso = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A caterogia de acesso não pode estar vazia.';
			END;

			IF @Banco IS NULL OR @Banco = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O banco não pode estar vazio.';
			END;

			IF @Agencia IS NULL OR @Agencia = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A agência não pode estar vazia.';
			END;

			IF @NumeroConta IS NULL OR @NumeroConta = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O número da conta não pode estar vazio.';
			END;

			IF @PerguntaSeguranca IS NULL OR @PerguntaSeguranca = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A pergunta de segurança não pode estar vazia.';
			END;

			IF @RespostaSeguranca IS NULL OR @RespostaSeguranca = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A resposta da pergunta de segurança não pode estar vazia.';
			END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;
		
		IF @Mensagem IS NULL
			BEGIN
				PRINT 'Os dados restantes estão válidos.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações dos dados restantes (se estão nulos e etc).
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validação dos caracteres de senha:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF OBJECT_ID('TEMPDB..#VALIDA_SENHA_E_EMAIL') IS NOT NULL DROP TABLE #VALIDA_SENHA_E_EMAIL;
			
			CREATE TABLE #VALIDA_SENHA_E_EMAIL
			(
				 SENHA VARCHAR(MAX)
				,EMAIL VARCHAR(MAX)
			);

			INSERT INTO #VALIDA_SENHA_E_EMAIL VALUES(@Senha, @Email);

			IF (SELECT SENHA FROM #VALIDA_SENHA_E_EMAIL WHERE SENHA LIKE '%[a-z][A-Z][0-9]%') IS NULL
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A senha deve conter, no mínimo, um caracter maiúsculo, um minusculo e um número.';
				END;
			ELSE
				BEGIN
					PRINT 'A senha está válida, dentro dos padrões estabelecidos pela Pousada.';
				END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Validação dos caracteres de senha.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validação dos caracteres de e-mail:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT EMAIL FROM #VALIDA_SENHA_E_EMAIL WHERE EMAIL LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%') IS NULL
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'O email deve estar no seguinte formato: email@email.com.';
				END;
			ELSE
				BEGIN
					PRINT 'O e-mail está válido.';
				END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Validação dos caracteres de e-mail.
*************************************************************************************************************************************/
		
/*************************************************************************************************************************************
INÍCIO: Validação da categoria de acesso (se existe no banco):
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM CATEGORIA_ACESSO WHERE CATACESSO_ID_INT = @CategoriaAcesso AND CATACESSO_EXCLUIDO_BIT = 0) IS NULL
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A categoria de acesso está inválida.';
				END;
			ELSE
				BEGIN
					PRINT 'A categoria de acesso está válida';
				END;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Validação da categoria de acesso (se existe no banco).
*************************************************************************************************************************************/

/*************************************************************************************************************************************
******************************************************** INSERÇÃO NAS TABELAS *******************************************************
*************************************************************************************************************************************/
/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela ENDERECO:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (@Complemento IS NULL) OR (@Complemento = '') OR (@Complemento = 'string')
				BEGIN
					BEGIN TRANSACTION;

						BEGIN TRY

							INSERT INTO ENDERECO
							(
								END_CEP_CHAR,
								END_LOGRADOURO_STR,
								END_NUMERO_CHAR,
								END_CIDADE_STR,
								END_BAIRRO_STR,
								END_ESTADO_CHAR,
								END_PAIS_STR,
								END_EXCLUIDO_BIT,
								END_DATA_CADASTRO_DATETIME
							)
							VALUES
							(
								@Cep,
								@Logradouro,
								@Numero,
								@Cidade,
								@Bairro,
								@Estado,
								@Pais,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
						
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Mensagem = ERROR_MESSAGE();
							SELECT @Codigo = ERROR_NUMBER();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
			ELSE
				BEGIN;
					BEGIN TRANSACTION;

						BEGIN TRY

							INSERT INTO ENDERECO
							VALUES
							(
								@Cep,
								@Logradouro,
								@Numero,
								@Complemento,
								@Cidade,
								@Bairro,
								@Estado,
								@Pais,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
						
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Mensagem = ERROR_MESSAGE();
							SELECT @Codigo = ERROR_NUMBER();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;

			SET @IdEndereco = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela USUARIO:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;
		
				BEGIN TRY

					INSERT INTO USUARIO
					VALUES
					(
						@Cpf,
						@NomeUsuario,
						ENCRYPTBYPASSPHRASE('key', @Senha),
						0,
						GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();
				
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
				
					SELECT @Mensagem = ERROR_MESSAGE();
					SELECT @Codigo = ERROR_NUMBER();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdUsuario = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela PERGUNTA_SEGURANCA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO PERGUNTA_SEGURANCA
					VALUES
					(
						 @PerguntaSeguranca
						,@RespostaSeguranca
						,@IdUsuario
						,0
						,GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();
				
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
				
					SELECT @Mensagem = ERROR_MESSAGE();
					SELECT @Codigo = ERROR_NUMBER();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Inserindo na tabela PERGUNTA_SEGURANCA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela CONTATOS:
*************************************************************************************************************************************/
			IF (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
				BEGIN
					BEGIN TRANSACTION

						BEGIN TRY
							
							INSERT INTO CONTATOS
							(
								CONT_EMAIL_STR,
								CONT_CELULAR_CHAR,
								CONT_EXCLUIDO_BIT,
								CONT_DATA_CADASTRO_DATETIME
							)
							VALUES
							(
								@Email,
								@Celular,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;
							
							SELECT @Mensagem = ERROR_MESSAGE();
							SELECT @Codigo = ERROR_NUMBER();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;
				END
			ELSE
				BEGIN
					BEGIN TRANSACTION;
						
						BEGIN TRY

							INSERT INTO CONTATOS
							VALUES
							(
								@Email,
								@Celular,
								@Telefone,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();

							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Mensagem = ERROR_MESSAGE();
							SELECT @Codigo = ERROR_NUMBER();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;
				END

			SET @IdContatos = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela FUNCIONARIO:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO FUNCIONARIO
					VALUES
					(
						 @Nome
						,@Cpf
						,@Nacionalidade
						,@DataDeNascimento
						,@Sexo
						,@Rg
						,@Cargo
						,@Setor
						,@Salario
						,@IdEndereco
						,@IdUsuario
						,@CategoriaAcesso
						,@IdContatos
						,0
						,GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
					
					SELECT @Mensagem = ERROR_MESSAGE();
					SELECT @Codigo = ERROR_NUMBER();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdFuncionario = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela FUNCIONARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela DADOSBANCARIOS:
*************************************************************************************************************************************/
			BEGIN TRANSACTION

				BEGIN TRY

					INSERT INTO DADOSBANCARIOS
					VALUES
					(
						@Banco,
						@Agencia,
						@NumeroConta,
						@IdFuncionario,
						0,
						GETDATE()
					);	

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
					
					SELECT @Mensagem = ERROR_MESSAGE();
					SELECT @Codigo = ERROR_NUMBER();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
		
/*************************************************************************************************************************************
FIM: Inserindo na tabela DADOSBANCARIOS.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
******************************************************** INSERÇÃO NAS TABELAS *******************************************************
*************************************************************************************************************************************/

		PRINT '---------------------------------------------- CADASTRO DE FUNCIONÁRIOS ---------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Funcionário cadastrado com sucesso no id ' + CAST(@IdFuncionario AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdFuncionario,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA CADASTRAR FUNCIONARIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA CADASTRAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspCadastrarHospede]
	 @NomeCompleto		nvarchar(255)
	,@Cpf				char(11)
	,@DataDeNascimento	date
	,@Email				nvarchar(50)
	,@Celular			nvarchar(13)
	,@Telefone			nvarchar(12)
	,@NomeUsuario		nvarchar(45)
	,@Senha				nvarchar(255)
	,@Cep				nvarchar(255)
	,@Logradouro		nvarchar(255)
	,@Numero			nvarchar(8)
	,@Complemento		nvarchar(255)
	,@Bairro			nvarchar(255)
	,@Cidade			nvarchar(255)
	,@Estado			nvarchar(255)
	,@Pais				nvarchar(255)
	,@Json				varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastro de hóspedes.
Data.....: 26/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @Codigo		INT;
		DECLARE @IdUsuario	INT;
		DECLARE @IdEndereco	INT;
		DECLARE @IdContatos	INT;
		DECLARE @IdHospede	INT;


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de hóspede.';
		
		SET @Entidade	= 'Hóspede';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/


		PRINT '------------------------------------------------ CADASTRO DE HÓSPEDES -----------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
Verificando se já existe um hóspede cadastrado com o CPF da entrada:
*************************************************************************************************************************************/
/*************************************************************************************************************************************
INÍCIO: Validações do CPF:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_CPF_CHAR = @Cpf) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'Já existe um hóspede cadastrado no sistema com o CPF ' + @Cpf + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O CPF está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do CPF.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Validações do nome de usuário:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM USUARIO WHERE USU_NOME_USUARIO_STR = @NomeUsuario) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'Já existe um usuário cadastrado com o nome de usuário ' + @NomeUsuario + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O nome de usuário está válido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Validações do nome de usuário.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
******************************************************** INSERÇÃO NAS TABELAS *******************************************************
*************************************************************************************************************************************/
/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela ENDERECO.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF (@Complemento IS NULL) OR (@Complemento = '') OR (@Complemento = 'string')
				BEGIN
					BEGIN TRANSACTION;

						BEGIN TRY

							INSERT INTO ENDERECO
							(
								END_CEP_CHAR,
								END_LOGRADOURO_STR,
								END_NUMERO_CHAR,
								END_CIDADE_STR,
								END_BAIRRO_STR,
								END_ESTADO_CHAR,
								END_PAIS_STR,
								END_EXCLUIDO_BIT,
								END_DATA_CADASTRO_DATETIME
							)
							VALUES
							(
								@Cep,
								@Logradouro,
								@Numero,
								@Cidade,
								@Bairro,
								@Estado,
								@Pais,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
						
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdEndereco = @@IDENTITY;
				END;
			ELSE
				BEGIN;
					BEGIN TRANSACTION;

						BEGIN TRY

							INSERT INTO ENDERECO
							VALUES
							(
								@Cep,
								@Logradouro,
								@Numero,
								@Complemento,
								@Cidade,
								@Bairro,
								@Estado,
								@Pais,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
						
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdEndereco = @@IDENTITY;
				END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/
			IF @NomeUsuario <> '' AND @Senha <> ''
			BEGIN
				BEGIN TRANSACTION;
		
					BEGIN TRY

						INSERT INTO USUARIO
						VALUES
						(
							@Cpf,
							@NomeUsuario,
							ENCRYPTBYPASSPHRASE('key', @Senha),
							0,
							GETDATE()
						);

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();
					
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
					
						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

				SET @IdUsuario = @@IDENTITY;
			END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela CONTATOS.
*************************************************************************************************************************************/
			IF  (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
				OR
				(@Celular IS NULL) OR (@Celular = '') OR (@Celular = 'string')
				BEGIN
					BEGIN TRANSACTION

						BEGIN TRY
						
							INSERT INTO CONTATOS
							(
								CONT_EMAIL_STR,
								CONT_EXCLUIDO_BIT,
								CONT_DATA_CADASTRO_DATETIME
							)
							VALUES
							(
								@Email,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
						
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;
						
							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdContatos = @@IDENTITY;
				END
			ELSE
				BEGIN
					BEGIN TRANSACTION;
					
						BEGIN TRY

							INSERT INTO CONTATOS
							VALUES
							(
								@Email,
								@Celular,
								@Telefone,
								0,
								GETDATE()
							);

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();

							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@StatusCode	= @Codigo;
						
						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdContatos = @@IDENTITY;
				END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela HOSPEDE.
*************************************************************************************************************************************/
			BEGIN TRANSACTION;
		
				BEGIN TRY
				
					INSERT INTO HOSPEDE
					VALUES
					(
						@NomeCompleto,
						@Cpf,
						@DataDeNascimento,
						@IdEndereco,
						@IdUsuario,
						@IdContatos,
						0,
						GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();
				
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
				
					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdHospede = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela HOSPEDE.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
******************************************************** INSERÇÃO NAS TABELAS *******************************************************
*************************************************************************************************************************************/

		PRINT '------------------------------------------------ CADASTRO DE HÓSPEDES -----------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Hóspede cadastrado com sucesso. Id: ' + CAST(@IdHospede AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdHospede,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA CADASTRAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
7 - PROCEDURE UTILIZADA PARA CADASTRAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspCadastrarReserva]
	 @IdHospede		int
	,@Chale			int
	,@Pagamento		int
	,@DataCheckIn	date
	,@DataCheckOut	date
	,@Acompanhantes	int
	,@Json	varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastro de reservas.
Data.....: 26/09/2021

2021-11-02: Correções #01
Validação que verifica se o check-in e check-out serão feitos no mesmo dia. Em caso positivo, é adicionado um dia a mais na data de
check-out, para que, no DATEDIFF, a diferença de dias seja um, e não zero.

2021-11-02: Correções #02 [ATUALIZAÇÃO REMOVIDA]
No caso da aplicação web, será passado, por padrão, id de pagamento 7. Nesse caso, o status será 3, ou seja, não autorizado. Isso
poderá ser corrigido atualizando a reserva por aplicação desktop.

2021-11-05: Correções #03
Removendo trava para permitir que reservas com data de check-in para mais de três dias além da data de registro da reserva, sejam
registradas.
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem			varchar(255);
		DECLARE @Entidade			varchar(255);
		DECLARE @Acao				varchar(255);
		DECLARE @Codigo				int;
		DECLARE @Acomodacao			int;
		DECLARE @ChaleOcupado		int;
		DECLARE @StatusPagamento	int;
		DECLARE @IdReserva			int;
		DECLARE @ValorAcomodacao	float(2);
		DECLARE @ValorTotal			float(2);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de reserva.';
		
		SET @Entidade	= 'Reserva';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '----------------------------------------------- CADASTRO DE RESERVAS ------------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
INÍCIO: Validação geral dos dados:
*************************************************************************************************************************************/
		IF @IdHospede IS NULL OR @IdHospede = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'O id do hóspede não pode estar vazio.';
		END;

		IF @Chale IS NULL OR @Chale = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'É necessário selecionar um chalé.';
		END;

		IF @Pagamento IS NULL OR @Pagamento = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'É necessário selecionar uma forma de pagamento.';
		END;

		IF @DataCheckIn IS NULL OR @DataCheckIn = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'A data de check-in está ínválida.';
		END;

		IF @DataCheckOut IS NULL OR @DataCheckOut = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'A data de check-out está ínválida.';
		END;

		IF @Acompanhantes IS NULL OR @Acompanhantes = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'O número de acompanhantes está inválido.';
		END;

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;
/*************************************************************************************************************************************
FIM: Validação geral dos dados.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o hóspede está cadastrado no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'Não há hóspede cadastrado com o id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se ambos os dias do check-in ou dia do check-out são menores do que o dia atual:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND @DataCheckIn < CAST(GETDATE() AS DATE) OR @DataCheckOut < CAST(GETDATE() AS DATE)
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'As data de check-in e check-out não podem ser menores do que o dia atual.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se o dia do check-in está a mais de 3 dias de distância do dia em que a reserva está sendo realizada:
*************************************************************************************************************************************/
		/* 2021-11-05: Correções #03 
		 *
		 * IF @Mensagem IS NULL AND @DataCheckIn > DATEADD(DAY, 3, GETDATE())
		 * BEGIN
		 * 	SET @Codigo = 422;
		 * 	SET	@Mensagem = 'A data de check-in selecionada está a mais do que 3 dias de hoje. ' +
		 * 						'Em casos assim, deve-se contatar a Pousada para realizar a reserva.'
		 * 
		 * 	EXEC [dbo].[uspGravarLog]
		 * 	@Json		= @Json,
		 * 	@Entidade	= @Entidade,
		 * 	@Mensagem	= @Mensagem,
		 * 	@Acao		= @Acao,
		 * 	@StatusCode	= @Codigo;
		 * END;
		 */

/*************************************************************************************************************************************
Verificando se o dia do check-in é maior que o dia do check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND @DataCheckIn > @DataCheckOut
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'A data de check-out é maior do que a data de check-in.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se, no período selecionado pelo usuário para fazer a reserva, a acomodação está disponível.
*************************************************************************************************************************************/
		IF  @Mensagem IS NULL
			AND
			(
				SELECT		TOP 1 1
				FROM		RESERVA  AS R
				LEFT JOIN	CHECKIN  AS CI ON R.RES_ID_INT		= CI.CHECKIN_RES_ID_INT
				LEFT JOIN	CHECKOUT AS CO ON CI.CHECKIN_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
				WHERE		RES_ACO_ID_INT = @Chale
				AND			RES_DATA_CHECKIN_DATE BETWEEN @DataCheckIn AND @DataCheckOut
				AND			RES_EXCLUIDO_BIT = 0
			)
		IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'Esse chalé está ocupado no período selecionado.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END
		ELSE
			BEGIN
				PRINT 'Nesse período, não há reservas confirmadas.';
			END;

/*************************************************************************************************************************************
Validações da forma de pagamento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM TIPO_PAGAMENTO WHERE TPPGTO_ID_INT = @Pagamento) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET @Mensagem = 'A forma de pagamento selecionada é inválida.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		ELSE
			BEGIN
				IF @Pagamento = 1 OR @Pagamento = 2
					BEGIN
						SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 1);
					END;
				ELSE
					IF @Pagamento = 3 OR @Pagamento = 4 OR @Pagamento = 5 OR @Pagamento = 6
					BEGIN
						SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 4);
					END;

				/**
				 * 2021-11-02: Correções #02 [ATUALIZAÇÃO REMOVIDA]
				 *
				 * IF @Pagamento = 7
				 * BEGIN
				 *	SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 3);
				 * END;
				 */

				PRINT 'Forma de pagamento selecionada: ' + CAST(@Pagamento AS VARCHAR) + ' e o status é: '
				+ CAST(@StatusPagamento AS VARCHAR)
			END;

/*************************************************************************************************************************************
Validação da acomodação e do número de acompanhantes, e, a partir disso, calculo da reserva:
*************************************************************************************************************************************/
		IF	@Mensagem IS NULL 
			AND
			(
				SELECT 1 FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0
			)
			IS NULL
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A acomodação selecionada está inválida.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		ELSE
			BEGIN

				SELECT @Acomodacao = ACO_INFO_ACOMOD_ID_INT FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0

				IF @Acompanhantes > 4
					BEGIN
						SET @Codigo = 422;
						SET @Mensagem = 'O número máximo de acompanhantes permitidos é quatro.';

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;
					END;
				ELSE
					BEGIN

						IF @Acompanhantes > 2 AND @Acomodacao = 2
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Superior e Master comportam, apenas, 3 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						IF @Acompanhantes > 2 AND @Acomodacao = 3
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Superior e Master comportam, apenas, 3 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						ELSE
							IF @Acompanhantes > 3 AND @Acomodacao = 1
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Standard comportam, apenas, 4 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						ELSE
							BEGIN

								IF @Acomodacao = 1
								BEGIN
									SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
									FROM	INFORMACOES_ACOMODACAO
									WHERE	INFO_ACOMOD_ID_INT = @Acomodacao;			
								END;

								ELSE
								
								IF @Acomodacao = 2
									BEGIN
										SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
										FROM	INFORMACOES_ACOMODACAO
										WHERE	INFO_ACOMOD_ID_INT = @Acomodacao
									END;
								
								ELSE

									BEGIN
										SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
										FROM	INFORMACOES_ACOMODACAO
										WHERE	INFO_ACOMOD_ID_INT = @Acomodacao
									END;

								-- 2021-	11-02: Correções #01
								IF @DataCheckIn = @DataCheckOut
									BEGIN

										DECLARE @DataCheckOutValida DATETIME = DATEADD(DAY, 1, CAST(@DataCheckOut AS DATE));

										SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOutValida, @Acompanhantes);

									END;
								ELSE
									BEGIN

										SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOut, @Acompanhantes);

									END;

								PRINT 'Acomodacao selecionada: Chalé ' + CAST(@Chale AS VARCHAR);
								PRINT 'Valor total da reserva: R$ ' + CAST(@ValorTotal AS VARCHAR) + '.';

							END;
					END;
			END;

/*************************************************************************************************************************************
********************************************************** INSERINDO NAS TABELAS *****************************************************
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela RESERVA:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO RESERVA
					VALUES
					(
						GETDATE(),
						@DataCheckIn,
						@DataCheckOut,
						@ValorTotal,
						1,
						@IdHospede,
						@Chale,
						@Acompanhantes,
						0,
						GETDATE()
					);

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdReserva = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
					BEGIN TRY

						INSERT INTO [RECPAPAGAIOS].[dbo].[PAGAMENTO_RESERVA]
						VALUES
						(
							@Pagamento,
							@IdReserva,
							@StatusPagamento,
							0,
							GETDATE()
						);

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();

						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;

						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/
		
/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ACOMODACAO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	[RECPAPAGAIOS].[dbo].[ACOMODACAO]
						SET
								ACO_ST_ACOMOD_INT = 1
						WHERE	ACO_ID_INT = @Chale;

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();

						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;

						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ACOMODACAO.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
********************************************************** INSERINDO NAS TABELAS *****************************************************
*************************************************************************************************************************************/
		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '----------------------------------------------- CADASTRO DE RESERVAS ------------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Reserva cadastrada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
	END
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
7 - PROCEDURE UTILIZADA PARA CADASTRAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
8 - PROCEDURE UTILIZADA PARA FAZER LOGINS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspFazerLogin]
	@NomeUsuario	nvarchar(45),
	@Senha			nvarchar(200),
	@Json			nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para verificar o login nas telas desktop e web.
Data.....: 22/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE	@Codigo					int;
		DECLARE @IdCadastrado			int;
		DECLARE @CpfCadastrado			nchar(11);
		DECLARE @NomeUsuarioCadastrado	nvarchar(45);
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @SenhaCadastrada		nvarchar(200);
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para execução de login.'
		
		SET @Entidade	= 'Login';

		SET @Acao		= 'Logar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Atribuindo valores às variáveis:
*************************************************************************************************************************************/
		SET @Codigo = 0

		SELECT		 @IdCadastrado			= F.FUNC_ID_INT
					,@NomeUsuarioCadastrado = USU_NOME_USUARIO_STR
					,@CpfCadastrado			= F.FUNC_CPF_CHAR
					,@SenhaCadastrada		= CAST(DECRYPTBYPASSPHRASE('key', USU_SENHA_STR) AS NVARCHAR)
		FROM		USUARIO		AS U
		INNER JOIN	FUNCIONARIO AS F ON U.USU_ID_INT = F.FUNC_USU_ID_INT
		WHERE		USU_NOME_USUARIO_STR = @NomeUsuario
		  AND		USU_EXCLUIDO_BIT = 0;

		IF @NomeUsuarioCadastrado IS NULL
		BEGIN
			SELECT		 @IdCadastrado			= F.HSP_ID_INT
						,@NomeUsuarioCadastrado = USU_NOME_USUARIO_STR
						,@CpfCadastrado			= F.HSP_CPF_CHAR
						,@SenhaCadastrada		= CAST(DECRYPTBYPASSPHRASE('key', USU_SENHA_STR) AS NVARCHAR)
			FROM		USUARIO	AS U
			INNER JOIN	HOSPEDE AS F ON U.USU_ID_INT = F.HSP_USU_ID_INT
			WHERE		USU_NOME_USUARIO_STR = @NomeUsuario
			  AND		USU_EXCLUIDO_BIT = 0;
		END;

/*************************************************************************************************************************************
INÍCIO: Validando os dados para liberar acesso:
*************************************************************************************************************************************/
		IF @NomeUsuarioCadastrado IS NULL
			BEGIN
				SET @Mensagem = 'O nome de usuário não existe cadastrado no sistema.';
				SET @Codigo = 422;

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;

		ELSE

			BEGIN

				IF @Senha <> @SenhaCadastrada
				BEGIN
					SET @Mensagem = 'A senha informada está inválida.';
					SET @Codigo = 422;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;
				END;

			END;

		
		IF @Codigo = 0
		BEGIN
			SET @Mensagem = 'Usuário encontrado e validado.';
			SET @Codigo = 200;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		SELECT	@Codigo					AS Codigo,
				@Mensagem				AS Mensagem,
				CASE
					WHEN @IdCadastrado IS NULL THEN 0
					ELSE @IdCadastrado
				END AS Id,
				CASE
					WHEN @NomeUsuarioCadastrado IS NULL THEN 'Não encontrado'
					ELSE @NomeUsuarioCadastrado
				END AS Usuario,
				CASE
					WHEN @CpfCadastrado IS NULL THEN 'Não encontrado'
					ELSE @CpfCadastrado
				END AS Cpf;
/*************************************************************************************************************************************
FIM: Validando os dados para liberar acesso.
*************************************************************************************************************************************/
	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
8 - PROCEDURE UTILIZADA PARA FAZER LOGINS
**************************************************************************************************************************************
*************************************************************************************************************************************/