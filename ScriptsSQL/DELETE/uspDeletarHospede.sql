USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspDeletarHospede]
	@IdHospede	int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para dele��o de h�spedes.
Data.....: 22/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o das vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @IdEndereco INT;
		DECLARE @IdContatos INT;
		DECLARE @IdUsuarios	INT;
		DECLARE @Codigo		INT;
		DECLARE @Json		VARCHAR(255);

/*************************************************************************************************************************************
Como n�o h� JSON para dele��o, adiciona-se uma mensagem padr�o, no lugar do JSON, para todas as intera��es:
*************************************************************************************************************************************/
		SET @Json		= 'Solicita��o de dele��o do h�spede no id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

		SET @Entidade	= 'H�spede';

		SET @Acao		= 'Deletar';
/*************************************************************************************************************************************
Como n�o h� JSON para dele��o, adiciona-se uma mensagem padr�o, no lugar do JSON, para todas as intera��es:
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo = 0;
		
		SET @Mensagem = 'In�cio da an�lise para dele��o de h�spede.'
		
		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdHospede,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se existe um h�spede cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'N�o existe nenhum h�spede cadastrado no sistema com o id ' + CAST(@IdHospede AS VARCHAR(8));

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospede,
			@StatusCode	= 404;
		END
/*************************************************************************************************************************************
Setando as vari�veis @IdHospede, @IdEndereco com o id do h�spede baseado no @IdUsuario.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = HSP_END_ID_INT,
					@IdUsuarios = HSP_USU_ID_INT,
					@IdContatos = HSP_CONT_ID_INT
			FROM	HOSPEDE
			WHERE	HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0;
		END;

/*************************************************************************************************************************************
IN�CIO: Deletando na tabela ENDERECO.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NOT NULL
				BEGIN
				
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_EXCLUIDO_BIT = 1
							WHERE	END_ID_INT = @IdEndereco;

							PRINT 'Endere�o deletado com sucesso!';

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
							@IdCadastro	= @IdHospede,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END
			ELSE
				BEGIN

					SET @Codigo = 404;
					SET @Mensagem = 'N�o h� endere�o para o id do h�spede ' + CAST(@IdHospede AS VARCHAR(8));;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdHospede,
					@StatusCode	= @Codigo;

				END;
/*************************************************************************************************************************************
FIM: Deletando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Deletando na tabela USUARIO.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM USUARIO WHERE USU_ID_INT = @IdUsuarios AND USU_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	USUARIO
								SET
										USU_EXCLUIDO_BIT = 1
								WHERE	USU_ID_INT = @IdUsuarios;

								PRINT 'Usu�rio deletado com sucesso!';

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
								
								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						SET @Codigo = 404;
						SET @Mensagem = 'N�o h� usu�rio para o id do h�spede ' + CAST(@IdHospede AS VARCHAR(8));

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdHospede,
						@StatusCode	= @Codigo;
					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Deletando na tabela CONTATOS.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	CONTATOS
								SET
										CONT_EXCLUIDO_BIT = 1
								WHERE	CONT_ID_INT = @IdContatos;

								PRINT 'Contato deletado com sucesso!';

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

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						SET @Codigo = 404;
						SET @Mensagem = 'N�o h� contatos para o id do h�spede ' + CAST(@IdHospede AS VARCHAR(8));

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdHospede,
						@StatusCode	= @Codigo;
					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Deletando na tabela HOSPEDE.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	HOSPEDE
								SET
										HSP_EXCLUIDO_BIT = 1
								WHERE	HSP_ID_INT = @IdHospede;

								PRINT 'H�spede deletado com sucesso!';

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

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						PRINT 'N�o h� h�spede para o id do h�spede ' + CAST(@IdHospede AS VARCHAR(8));

					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela HOSPEDE.
*************************************************************************************************************************************/
		END;

/*************************************************************************************************************************************
IN�CIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'H�spede ' + CAST(@IdHospede AS VARCHAR(8)) + ' deletado com sucesso.';
		
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospede,
			@StatusCode	= @Codigo;
		END;
		
		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

	END
GO