USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspAtualizarReserva]
	 @IdReserva		int
	,@Chale			int
	,@Pagamento		int
	,@DataCheckIn	date
	,@DataCheckOut	date
	,@Acompanhantes	int
	,@ReservaJson	nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para atualiza��o de reservas (no momento, apenas na API).
Data.....: 20/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o das vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);
		DECLARE @DescricaoPagamento		nvarchar(50);
		DECLARE @IdReservaCadastrada	int;
		DECLARE @IdReservaCheckIn		int;
		DECLARE @IdStatusPagamento		int;
		DECLARE @IdAcomodacao			int;
		DECLARE @TipoPagamento			int;
		DECLARE @Acomodacao				int;
		DECLARE @StatusPagamento		int;
		DECLARE @Codigo					int;
		DECLARE @ValorAcomodacao		float(2);
		DECLARE @ValorTotal				float(2);
		DECLARE @DataCheckInReserva		date;
		DECLARE @DataCheckOutReserva	date;


/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'In�cio da an�lise para atualiza��o de reserva.';
		
		SET @Entidade = 'Reserva';

		SET @Acao	  = 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @ReservaJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdReserva,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
SELECT principal que busca as informa��es que ser�o, futuramente, validadas:
*************************************************************************************************************************************/
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@IdReservaCheckIn		= CI.CHECKIN_RES_ID_INT
					,@IdAcomodacao			= R.RES_ACO_ID_INT
					,@TipoPagamento			= PR.PGTO_RES_TPPGTO_ID_INT
					,@IdStatusPagamento		= PGTO_RES_ST_PGTO_ID_INT
					,@IdAcomodacao			= R.RES_ACO_ID_INT
					,@DataCheckInReserva	= R.RES_DATA_CHECKIN_DATE
					,@DataCheckOutReserva	= R.RES_DATA_CHECKOUT_DATE
		FROM		RESERVA					AS R
		LEFT JOIN	PAGAMENTO_RESERVA		AS PR ON R.RES_ID_INT = PR.PGTO_RES_RES_ID_INT
		LEFT JOIN	CHECKIN					AS CI ON R.RES_ID_INT = CI.CHECKIN_RES_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;

/*************************************************************************************************************************************
Verificando se a reserva existe na base de dados:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'N�o h� reserva com o id ' + CAST(@IdReserva AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @ReservaJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Validando se a atualiza��o est� sendo realizada antes da data de check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF CAST(GETDATE() AS date) > @DataCheckInReserva
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'N�o � poss�vel atualizar uma reserva que j� passou da data de check-in.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a reserva possui check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdReservaCheckIn IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' possui check-in.' +
								' N�o � poss�vel alterar reservas com check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando qual a forma de pagamento da reserva -- caso seja igual a dinheiro (1) ou d�bido (2), n�o ser� poss�vel alterar a reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @DescricaoPagamento = TPPGTO_TIPO_PAGAMENTO_STR FROM TIPO_PAGAMENTO WHERE TPPGTO_ID_INT = @TipoPagamento;

			IF @TipoPagamento = 1 OR @TipoPagamento = 2
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'O tipo de pagamento � igual a dinheiro e cart�o de d�bito. ' +
								'Portanto, n�o � poss�vel alterar as informa��es dessa reserva.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Caso o pagamento seja diferente de dinheiro (1) e d�bito (2), ser� validado o status do pagamento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdStatusPagamento = 1 OR @IdStatusPagamento = 4
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'O pagamento da reserva est� aprovado ou em processamento. Portanto, n�o � poss�vel atualizar a reserva.'

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a acomoda��o escolhida est� dispon�vel do per�odo informado, caso a acomoda��o seja diferente da acomoda��o j� regis-
trada na reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdAcomodacao <> @Chale
			BEGIN

				IF  (
						SELECT		TOP 1 1
						FROM		RESERVA	 R
						LEFT JOIN	CHECKIN  CI ON R.RES_ID_INT			= CI.CHECKIN_RES_ID_INT
						LEFT JOIN	CHECKOUT CO ON CI.CHECKIN_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
						WHERE		RES_ACO_ID_INT = @Chale
						AND			RES_DATA_CHECKIN_DATE BETWEEN @DataCheckIn AND @DataCheckOut
						AND			RES_EXCLUIDO_BIT = 0
					)
				IS NOT NULL
				BEGIN
					SET @Codigo = 409;
					SET @Mensagem = 'A acomoda��o selecionada est� indispon�vel no per�odo selecionado.';

					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a data de check-in est� sendo escolhida para mais de tr�s dias:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataCheckIn <> @DataCheckInReserva
			BEGIN

				IF @DataCheckIn > DATEADD(DAY, 3, GETDATE())
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A data de check-in selecionada est� a mais do que 3 dias de hoje. ' +
									'Em casos assim, deve-se contatar a Pousada para realizar a reserva.'

					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a data de check-in � menor que a data de check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataCheckIn <> @DataCheckInReserva
			BEGIN
				
				IF @DataCheckIn > @DataCheckOutReserva
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A data de check-in n�o pode ser maior que a data de check-out primeiramente cadastrada.'
					
					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;

				IF @DataCheckOut <> @DataCheckOutReserva
				BEGIN

					IF @DataCheckIn > @DataCheckOut
					BEGIN
						SET @Codigo = 422;
						SET @Mensagem = 'A data de check-in n�o pode ser maior que a data de check-out.';

						EXEC [dbo].[uspGravarLog]
						@Json		= @ReservaJson,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro = @IdReserva,
						@StatusCode	= @Codigo;
					END;
				END;
			END;
		END;
		
/*************************************************************************************************************************************
Validando a quantidade de acompanhantes:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Acompanhantes > 3
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O n�mero de acompanhantes n�o pode ser maior do que 3.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;
		
/*************************************************************************************************************************************
Atualizando o pre�o da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @Acomodacao = ACO_INFO_ACOMOD_ID_INT FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0;
			
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

			SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOut, @Acompanhantes);
		END;

/*************************************************************************************************************************************
Atualizando o pre�o da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Pagamento = 1 OR @Pagamento = 2
				BEGIN

					SET @StatusPagamento = 1;

				END;

			ELSE
				
				BEGIN

					SET @StatusPagamento = 4;

				END;
		END;


/*************************************************************************************************************************************
******************************************************** ATUALIZANDO TABELAS *********************************************************
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
IN�CIO: Atualizando na tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							 RES_DATA_CHECKIN_DATE		= @DataCheckIn
							,RES_DATA_CHECKOUT_DATE		= @DataCheckOut
							,RES_VALOR_RESERVA_FLOAT	= @ValorTotal
							,RES_ACO_ID_INT				= @Chale
							,RES_ACOMPANHANTES_ID_INT	= @Acompanhantes
					WHERE	RES_ID_INT = @IdReserva;

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
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Atualizando na tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Atualizando na tabela ACOMODACAO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @Chale <> @IdAcomodacao
				BEGIN

					/************************************************************************************************************************
					* Atualizando a acomoda��o anterior como dispon�vel:
					************************************************************************************************************************/
					IF	(
							SELECT		TOP 1 1
							FROM		RESERVA AS R
							INNER JOIN	ACOMODACAO AS A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
							WHERE A.ACO_ID_INT = @IdAcomodacao
							  AND R.RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						)
					IS NULL
					BEGIN

						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	ACOMODACAO
								SET
										ACO_ST_ACOMOD_INT	= 3
								WHERE	ACO_ID_INT			= @IdAcomodacao;

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
								@Json		= @ReservaJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro = @IdReserva,
								@StatusCode	= @Codigo;
							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END;


					/************************************************************************************************************************
					* Atualizando a acomoda��o atual como ocupada:
					************************************************************************************************************************/
					IF	(
							SELECT		TOP 1 1
							FROM		RESERVA AS R
							INNER JOIN	ACOMODACAO AS A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
							WHERE A.ACO_ID_INT = @Chale
							  AND R.RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						)
					IS NULL
					BEGIN

						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	ACOMODACAO
								SET
										ACO_ST_ACOMOD_INT	= 1
								WHERE	ACO_ID_INT			= @Chale;

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
								@Json		= @ReservaJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro = @IdReserva,
								@StatusCode	= @Codigo;
							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END;
				END;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ACOMODACAO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Atualizando na tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @Pagamento <> @TipoPagamento
				BEGIN

					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	PAGAMENTO_RESERVA
							SET
									 PGTO_RES_TPPGTO_ID_INT		= @Pagamento
									,PGTO_RES_ST_PGTO_ID_INT	= @StatusPagamento
							WHERE	PGTO_RES_RES_ID_INT			= @IdReserva;

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
							@Json		= @ReservaJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro = @IdReserva,
							@StatusCode	= @Codigo;
						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
******************************************************** ATUALIZANDO TABELAS *********************************************************
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Gravando log de sucesso:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Reserva atualizada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @ReservaJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdReserva,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

	END;
GO