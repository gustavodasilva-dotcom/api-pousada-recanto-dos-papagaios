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
Descri��o: Procedure utilizada para executar o check-out sobre reservas (no momento, apenas na API).
Data.....: 05/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o de vari�veis:
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
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo = 0;
		
		SET @Mensagem	= 'In�cio da an�lise para cadastro do check-out referente � reserva ' + CAST(@IdReserva AS VARCHAR) + '.';
		
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
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
Validando caso os par�metros @TipoPagamento ou @ValorAdicional estejam nulos:
*************************************************************************************************************************************/
		IF @PagamentoAdicional = 1 AND @TipoPagamento IS NULL
		BEGIN
			SET @Codigo = 422
			SET @Mensagem = 'O tipo de pagamento n�o pode estar nulo quando houver pagamento adicional.';

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
				SET @Mensagem = 'Os valores adicionais n�o podem estar nulos quando houver pagamento adicional.';
				
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
				SET @Mensagem = 'O id ' + CAST(@IdReserva AS VARCHAR) + ' n�o corresponde a uma reserva.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;
		

/*************************************************************************************************************************************
Validando se o funcion�rio existe no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET @Mensagem = 'O id ' + CAST(@IdFuncionario AS VARCHAR) + ' n�o corresponde a um funcion�rio.';

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
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' n�o possui check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se, no check-in, pagamentos adicionais ser�o feitos:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @IdCheckOut = CHECKOUT_ID_INT FROM CHECKOUT WHERE CHECKOUT_CHECKIN_ID_INT = @IdCheckIn AND CHECKOUT_EXCLUIDO_BIT = 0;

			IF @IdCheckOut IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' j� possui check-out: ' + CAST(@IdCheckOut AS VARCHAR) + '.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Validando se a reserva est� com algum pagamento pendente:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @StatusPagamento = PGTO_RES_ST_PGTO_ID_INT FROM PAGAMENTO_RESERVA WHERE PGTO_RES_RES_ID_INT = @IdReserva;

			SELECT @DescricaoPagamento = ST_PGTO_DESCRICAO_STR FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = @StatusPagamento;

			IF @StatusPagamento <> 1
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' est� com o status ' + @DescricaoPagamento + '.'
							  + ' Portanto, n�o � poss�vel prosseguir com o check-out.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @CheckOutJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Atribuindo valor � vari�vel @ValorTotal:
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
IN�CIO: Inserindo na tabela de CHECKOUT:
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
IN�CIO: Inserindo na tabela de PAGAMENTO_CHECK_OUT:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @PagamentoAdicional = 1
				BEGIN
					
					-- COM PAGAMENTOS ADICIONAIS:
					
					/*********************************************************************************************************************
					* Validando caso os par�metros @TipoPagamento ou @ValorAdicional estejam nulos: **************************************
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
IN�CIO: Atualizando na tabela de RESERVA:
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
Por �ltimo, executar procedure que validar� e colocar� como "Dispon�vel" as acomoda��es n�o possu�rem check-in dos pr�ximos tr�s dias:
*************************************************************************************************************************************/
		EXEC [uspMarcarAcomodacaoComoDisponivel];


/*************************************************************************************************************************************
IN�CIO: Gravando log de sucesso.
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