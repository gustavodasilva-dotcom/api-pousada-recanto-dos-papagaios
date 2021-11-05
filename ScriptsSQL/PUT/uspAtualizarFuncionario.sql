USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspAtualizarFuncionario]
	 @IdFuncionarioRota	int
	,@Nome				nvarchar(255)
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
Descrição: Procedure utilizada para atualização de funcionários (no momento, apenas na API).
Data.....: 29/08/2021
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

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para atualização de funcionário.';
		
		SET	@Entidade	= 'Funcionário';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdFuncionarioRota,
		@StatusCode	= 0;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionarioRota AND FUNC_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não existe nenhum funcionário cadastrado no sistema com o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFuncionarioRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o nome de usuário da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO		U
					INNER JOIN	FUNCIONARIO F ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR				= @NomeUsuario
					AND			F.FUNC_USU_ID_INT					= @IdFuncionarioRota
				)
			IS NOT NULL
			BEGIN
				PRINT 'Encontrado o login ' + @NomeUsuario + ' para o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			END;
			
			
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO		U
					INNER JOIN	FUNCIONARIO F ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR				=  @NomeUsuario
					AND			F.FUNC_ID_INT						<> @IdFuncionarioRota
				)
			IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um usuário cadastrado com o nome de usuário ' + @NomeUsuario + '.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o CPF da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT FUNC_CPF_CHAR FROM FUNCIONARIO WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_USU_ID_INT = @IdFuncionarioRota) IS NOT NULL
			BEGIN
				PRINT 'Encontrado o CPF ' + @CPF + ' para o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			END;
			
			
			IF (SELECT FUNC_CPF_CHAR FROM FUNCIONARIO WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_ID_INT <> @IdFuncionarioRota) IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um funcionário cadastrado com o CPF ' + @Cpf + '.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Setando as variáveis @IdUsuarios, @IdEndereco e @IdContatos com o id do hóspede baseado no @IdFuncionarioRota:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = FUNC_END_ID_INT,
					@IdUsuarios = FUNC_USU_ID_INT,
					@IdContatos = FUNC_CONT_ID_INT
			FROM	FUNCIONARIO
			WHERE	FUNC_ID_INT = @IdFuncionarioRota AND FUNC_EXCLUIDO_BIT = 0;
		END;
/*************************************************************************************************************************************
Verificando se é possível encontrar registros com as chaves-estrangeiras obtidas de FUNCIONARIO:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de endereço cadastrado para o funcionário informado.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM USUARIO WHERE USU_ID_INT = @IdUsuarios AND USU_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de dados de usuário cadastrados para o funcionário informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de contatos cadastrado para o funcionário informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;


		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ENDERECO:
*************************************************************************************************************************************/
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

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
							@StatusCode	= @Codigo;

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
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela DADOSBANCARIOS:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
					BEGIN TRY

						UPDATE	DADOSBANCARIOS
						SET
								 DADOSBC_BANCO_STR			= @Banco
								,DADOSBC_AGENCIA_STR		= @Agencia
								,DADOSBC_NUMERO_CONTA_STR	= @NumeroConta
						WHERE	DADOSBC_FUNC_ID_INT			= @IdFuncionarioRota;

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
						@IdCadastro	= @IdFuncionarioRota,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela DADOSBANCARIOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela USUARIO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
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
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
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

						BEGIN TRANSACTION;

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
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdFuncionarioRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					
					END;

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
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdFuncionarioRota,
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
INÍCIO: Atualizando na tabela FUNCIONARIO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN

				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	FUNCIONARIO
						SET
								 FUNC_NOME_STR			= @Nome
								,FUNC_CPF_CHAR			= @Cpf
								,FUNC_NACIONALIDADE_STR	= @Nacionalidade
								,FUNC_DTNASC_DATE		= @DataDeNascimento
								,FUNC_SEXO_CHAR			= @Sexo
								,FUNC_RG_CHAR			= @Rg
								,FUNC_CARGO_STR			= @Cargo
								,FUNC_SETOR_STR			= @Setor
								,FUNC_SALARIO_FLOAT		= @Salario
								,FUNC_CATACESSO_ID_INT	= @CategoriaAcesso
						WHERE	FUNC_ID_INT = @IdFuncionarioRota;

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
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdFuncionarioRota,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela FUNCIONARIO.
*************************************************************************************************************************************/
		END;


/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Funcionário com id ' + CAST(@IdFuncionarioRota AS VARCHAR(8)) + ' atualizado com sucesso.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFuncionarioRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;

GO