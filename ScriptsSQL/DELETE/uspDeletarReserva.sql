USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspDeletarReserva]
	 @IdReserva		int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para dele��o de reservas (no momento, apenas na API).
Data.....: 21/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o das vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @IdReservaCadastrada	int;
		DECLARE @StatusPagamento		int;
		DECLARE @Chale					int;
		DECLARE @Codigo					int;
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);

/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'In�cio da an�lise para dele��o de reserva.';
		
		SET @Entidade = 'Reserva';

		SET @Acao	  = 'Deletar';

		EXEC [dbo].[uspGravarLog]
		@Json		= NULL,
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
SELECT principal que atribui valor �s vari�veis que, posteriormente, ser�o validadas:
*************************************************************************************************************************************/
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@StatusPagamento		= PR.PGTO_RES_ST_PGTO_ID_INT
					,@Chale					= R.RES_ACO_ID_INT
		FROM		RESERVA				AS R
		INNER JOIN	PAGAMENTO_RESERVA	AS PR ON PR.PGTO_RES_ID_INT		= R.RES_ID_INT
		LEFT JOIN	CHECKIN				AS CI ON R.RES_ID_INT			= CI.CHECKIN_RES_ID_INT
		LEFT JOIN	CHECKOUT			AS CO ON CI.CHECKIN_RES_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;

/*************************************************************************************************************************************
Validando se a reserva informada existe no sistema:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' n�o existe em sistema.';

			EXEC [dbo].[uspGravarLog]
			@Json		= NULL,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Se o pagamento estiver "Em processamento", n�o ser� poss�vel excluir a reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @StatusPagamento = 4
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'N�o � poss�vel excluir uma reserva que possua um pagamento com status de "Em Processamento".';

				EXEC [dbo].[uspGravarLog]
				@Json		= NULL,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;


		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
IN�CIO: Atualizando tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							RES_EXCLUIDO_BIT = 1
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
					@Json		= NULL,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

/*************************************************************************************************************************************
FIM: Atualizando tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Atualizando tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	PAGAMENTO_RESERVA
						SET
								PGTO_RES_EXCLUIDO_BIT = 1
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
						@Json		= NULL,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro = @IdReserva,
						@StatusCode	= @Codigo;
					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Atualizando tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Atualizando tabela ACOMODACAO, caso n�o haja, nos pr�ximos tr�s dias, reservas:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF  (
						SELECT	TOP 1 1
						FROM	RESERVA
						WHERE	RES_ACO_ID_INT = @Chale
						  AND	RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						  AND	RES_ID_INT <> @IdReserva
					)
				IS NULL
				BEGIN

					BEGIN TRANSACTION;

						BEGIN TRY
						
							UPDATE	ACOMODACAO
							SET
									ACO_ST_ACOMOD_INT = 3
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
							@Json		= NULL,
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
FIM: Atualizando tabela ACOMODACAO, caso n�o haja, nos pr�ximos tr�s dias, reservas.
*************************************************************************************************************************************/
		END;


/*************************************************************************************************************************************
IN�CIO: Gravando log de sucesso:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Reserva deletada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= NULL,
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