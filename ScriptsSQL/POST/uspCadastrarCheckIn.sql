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