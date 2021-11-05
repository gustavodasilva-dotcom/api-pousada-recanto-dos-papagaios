USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspAtualizarHospede]
	 @IdHospedeRota		char(11)
	,@NomeCompleto		nvarchar(255)
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
	,@HospedeJson		nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de hóspedes (no momento, apenas na API).
Data.....: 22/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @Codigo		INT;
		DECLARE @IdEndereco INT;
		DECLARE @IdContatos INT;
		DECLARE @IdUsuarios	INT;
		DECLARE @NomeUsu	VARCHAR(80);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;

		SET @Mensagem	= 'Início da análise para atualização de hóspede.';
		
		SET	@Entidade	= 'Hóspede';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @HospedeJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdHospedeRota,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se já existe um hóspede cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospedeRota AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'Não existe nenhum hóspede cadastrado no sistema com o id ' + @IdHospedeRota;
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @HospedeJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospedeRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
Verificando se já existe um hóspede cadastrado com o nome de usuário da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO	U
					INNER JOIN	HOSPEDE H ON H.HSP_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR			= @NomeUsuario
					AND			H.HSP_USU_ID_INT				= @IdHospedeRota
				)
			IS NOT NULL
			BEGIN
				
				PRINT 'Encontrado o login ' + @NomeUsuario + ' para o id ' + @IdHospedeRota;

			END;
			
			
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO	U
					INNER JOIN	HOSPEDE H ON H.HSP_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR			=  @NomeUsuario
					AND			H.HSP_ID_INT					<> @IdHospedeRota
				)
			IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um hóspede cadastrado com o nome de usuário ' + @NomeUsuario + '.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Setando as variáveis @IdHospede, @IdEndereco com o id do hóspede baseado no @IdHospedeRota.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = HSP_END_ID_INT,
					@IdUsuarios = HSP_USU_ID_INT,
					@IdContatos = HSP_CONT_ID_INT
			FROM	HOSPEDE
			WHERE	HSP_ID_INT = @IdHospedeRota AND HSP_EXCLUIDO_BIT = 0;
		END;
/*************************************************************************************************************************************
Verificando se é possível encontrar registros com as chaves-estrangeiras obtidas de HOSPEDE.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de endereço cadastrado para o hóspede informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de contatos cadastrado para o hóspede informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN -- ATUALIZANDO TABELAS

			IF (@Complemento IS NULL) OR (@Complemento = '') OR (@Complemento = 'string')
				BEGIN
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = NULL,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

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
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= 500;

							RAISERROR(@Mensagem, 20, -1) WITH LOG;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
			ELSE
				BEGIN;
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = @Complemento,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

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
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela USUARIO.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL AND @IdUsuarios IS NOT NULL
			BEGIN

				IF LEN(@NomeUsuario) > 0 AND LEN(@Senha) > 0
				BEGIN

					BEGIN TRANSACTION;
		
						BEGIN TRY

							UPDATE	USUARIO
							SET
									USU_LOGIN_CPF_CHAR	 = @Cpf,
									USU_NOME_USUARIO_STR = @NomeUsuario,
									USU_SENHA_STR		 = ENCRYPTBYPASSPHRASE('key', @Senha)
							WHERE	USU_ID_INT = @IdUsuarios;

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
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;
					
				END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN

				IF (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
					BEGIN


						BEGIN TRANSACTION

							BEGIN TRY
								
								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= NULL
								WHERE	CONT_ID_INT = @IdContatos;

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
								@Json		= @HospedeJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospedeRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					END
				ELSE
					BEGIN
						BEGIN TRANSACTION;
							
							BEGIN TRY

								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= @Telefone
								WHERE	CONT_ID_INT = @IdContatos;

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
								@Json		= @HospedeJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospedeRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela HOSPEDE.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
				BEGIN TRY
					
					UPDATE	HOSPEDE
					SET
							HSP_NOME_STR	= @NomeCompleto,
							HSP_CPF_CHAR	= @Cpf,
							HSP_DTNASC_DATE	= @DataDeNascimento
					WHERE	HSP_ID_INT = @IdHospedeRota;

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
					@Json		= @HospedeJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdHospedeRota,
					@StatusCode	= @Codigo;

				END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;

		END; -- ATUALIZANDO TABELAS
/*************************************************************************************************************************************
FIM: Atualizando na tabela HOSPEDE.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Hóspede com id ' + CAST(@IdHospedeRota AS VARCHAR(8)) + ' atualizado com sucesso.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @HospedeJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospedeRota,
			@StatusCode	= @Codigo;
		END
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END
GO