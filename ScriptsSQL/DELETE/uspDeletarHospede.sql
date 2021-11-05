USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspDeletarHospede]
	@IdHospede	int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para deleção de hóspedes.
Data.....: 22/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
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
Como não há JSON para deleção, adiciona-se uma mensagem padrão, no lugar do JSON, para todas as interações:
*************************************************************************************************************************************/
		SET @Json		= 'Solicitação de deleção do hóspede no id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

		SET @Entidade	= 'Hóspede';

		SET @Acao		= 'Deletar';
/*************************************************************************************************************************************
Como não há JSON para deleção, adiciona-se uma mensagem padrão, no lugar do JSON, para todas as interações:
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo = 0;
		
		SET @Mensagem = 'Início da análise para deleção de hóspede.'
		
		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdHospede,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se existe um hóspede cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não existe nenhum hóspede cadastrado no sistema com o id ' + CAST(@IdHospede AS VARCHAR(8));

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospede,
			@StatusCode	= 404;
		END
/*************************************************************************************************************************************
Setando as variáveis @IdHospede, @IdEndereco com o id do hóspede baseado no @IdUsuario.
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
INÍCIO: Deletando na tabela ENDERECO.
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

							PRINT 'Endereço deletado com sucesso!';

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
					SET @Mensagem = 'Não há endereço para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));;

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
INÍCIO: Deletando na tabela USUARIO.
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

								PRINT 'Usuário deletado com sucesso!';

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
						SET @Mensagem = 'Não há usuário para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

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
INÍCIO: Deletando na tabela CONTATOS.
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
						SET @Mensagem = 'Não há contatos para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

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
INÍCIO: Deletando na tabela HOSPEDE.
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

								PRINT 'Hóspede deletado com sucesso!';

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

						PRINT 'Não há hóspede para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela HOSPEDE.
*************************************************************************************************************************************/
		END;

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Hóspede ' + CAST(@IdHospede AS VARCHAR(8)) + ' deletado com sucesso.';
		
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