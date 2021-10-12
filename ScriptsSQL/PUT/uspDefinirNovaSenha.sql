USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspDefinirNovaSenha]
	 @Cpf				nchar(11)
	,@NovaSenha			nvarchar(200)
	,@RepeticaoSenha	nvarchar(200)
	,@Json				nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, para atualizar a senha do usuário, no processo de "Esqueci Minha Senha".
Data.....: 23/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	nvarchar(max);
		DECLARE @Entidade	nvarchar(50);
		DECLARE @Acao		nvarchar(50);
		DECLARE @Codigo		int;
		DECLARE @IdUsuario	int;


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'Início da análise para atualização de senha.';
		
		SET @Entidade = 'Usuário';

		SET @Acao	  = 'Atualizar';

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
SELECT principal que atribui valor às variáveis:
*************************************************************************************************************************************/
		SELECT		@IdUsuario = USU_ID_INT
		FROM		FUNCIONARIO AS F
		INNER JOIN	USUARIO		AS U ON F.FUNC_USU_ID_INT = U.USU_ID_INT
		WHERE		F.FUNC_CPF_CHAR			= @Cpf
		  AND		U.USU_LOGIN_CPF_CHAR	= @Cpf;
		
/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		IF @IdUsuario IS NOT NULL
			BEGIN

				IF @NovaSenha = @RepeticaoSenha
					BEGIN

					/*****************************************************************************************************************
					* INÍCIO: Atualizando tabela de USUARIO:
					*****************************************************************************************************************/
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE USUARIO
								SET
										USU_SENHA_STR = ENCRYPTBYPASSPHRASE('key', @NovaSenha)
								WHERE	USU_ID_INT = @IdUsuario;

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

								SELECT @Codigo = ERROR_NUMBER(), @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

						SET @Mensagem = 'Senha atualizada com sucesso.';
						SET @Codigo = 200;

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END;
					/*****************************************************************************************************************
					* FIM: Atualizando tabela de USUARIO.
					*****************************************************************************************************************/

				ELSE

					BEGIN

						SET @Mensagem = 'As senhas informadas não correspondem.';
						SET @Codigo = 422;

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END;

			END;

		ELSE
			
			BEGIN

				SET @Mensagem = 'Usuário não encontrado no sistema. Por favor, contatar o Suporte.'
				SET @Codigo = 404;

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;

			END;
/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/
		
		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO