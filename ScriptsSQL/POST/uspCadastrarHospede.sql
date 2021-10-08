USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspCadastrarHospede]
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
Descri��o: Procedure utilizada para cadastro de h�spedes.
Data.....: 26/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o das vari�veis:
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
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'In�cio da an�lise para cadastro de h�spede.';
		
		SET @Entidade	= 'H�spede';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/


		PRINT '------------------------------------------------ CADASTRO DE H�SPEDES -----------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
Verificando se j� existe um h�spede cadastrado com o CPF da entrada:
*************************************************************************************************************************************/
/*************************************************************************************************************************************
IN�CIO: Valida��es do CPF:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_CPF_CHAR = @Cpf AND HSP_EXCLUIDO_BIT = 0) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'J� existe um h�spede cadastrado no sistema com o CPF ' + @Cpf + '.';

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
				SET @Mensagem = 'O CPF n�o pode estar vazio.';
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
				PRINT 'O CPF est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es do CPF.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es do nome de usu�rio:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM USUARIO WHERE USU_NOME_USUARIO_STR = @NomeUsuario) IS NOT NULL
		BEGIN
			SET	@Codigo = 409;
			SET	@Mensagem = 'J� existe um usu�rio cadastrado com o nome de usu�rio ' + @NomeUsuario + '.';

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
				SET @Mensagem = 'O nome de usu�rio n�o pode estar vazio.';

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
				PRINT 'O nome de usu�rio est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es do nome de usu�rio.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es da data de nascimento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataDeNascimento IS NULL OR @DataDeNascimento = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A data de nascimento n�o pode estar vazia.';
			END;

			IF @DataDeNascimento >= DATEADD(YEAR, -18, GETDATE())
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'N�o � permitido cadastro de h�spedes menores de idade.';
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
				PRINT 'A data de nascimento est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es da data de nascimento.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es do CEP:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Cep IS NULL OR @Cep = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O CEP n�o pode estar vazio.';
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
				PRINT 'O CEP est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es do CEP.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es do telefone:
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
						SET @Mensagem = 'O tamanho do n�mero de telefone deve ser entre 10 e 12 caracteres.';
					END;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;
				END;
			ELSE
				BEGIN
					PRINT 'Funcion�rio optou por n�o cadastrar um n�mero de telefone fixo.';
				END;
		END;

		IF @Mensagem IS NULL
			BEGIN
				PRINT 'O telefone est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es do telefone.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es do celular:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Celular IS NULL OR @Celular = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O n�mero de celular n�o pode estar vazio.';
			END;

			IF LEN(@Celular) < 11 OR LEN(@Celular) > 13
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O celular deve conter um tamanho entre 11 e 13 d�gitos.';
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
				PRINT 'O celular est� v�lido.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es do celular.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��es dos dados restantes (se est�o nulos e etc):
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @NomeCompleto IS NULL OR @NomeCompleto = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O nome do h�spede n�o pode estar vazio.';
			END;

			IF @Logradouro IS NULL OR @Logradouro = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O logradouro n�o pode estar vazio.';
			END;

			IF @Numero IS NULL OR @Numero = '' OR ISNUMERIC(@Numero) = 0
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'Verificar o n�mero do endere�o, pois est� inv�lido.';
			END;

			IF @Bairro IS NULL OR @Bairro = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O bairro n�o pode estar vazio.';
			END;

			IF @Cidade IS NULL OR @Cidade = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O cidade n�o pode estar vazio.';
			END;

			IF @Estado IS NULL OR @Estado = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O estado n�o pode estar vazio.';
			END;

			IF LEN(@Estado) > 2
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O estado deve conter, apenas, 2 caracteres.';
			END;

			IF @Pais IS NULL OR @Pais = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O pa�s n�o pode estar vazio.';
			END;

			IF @Senha IS NULL OR @Senha = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A senha n�o pode estar vazia.';
			END;

			IF @Email IS NULL OR @Email = ''
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O e-mail n�o pode estar vazio.';
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
				PRINT 'Os dados restantes est�o v�lidos.';
			END;
		ELSE 
			BEGIN
				PRINT @Mensagem;
			END;
/*************************************************************************************************************************************
FIM: Valida��es dos dados restantes (se est�o nulos e etc).
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��o dos caracteres de senha:
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
					SET @Mensagem = 'A senha deve conter, no m�nimo, um caracter mai�sculo, um minusculo e um n�mero.';

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;
				END;
			ELSE
				BEGIN
					PRINT 'A senha est� v�lida, dentro dos padr�es estabelecidos pela Pousada.';
				END;
		END;
/*************************************************************************************************************************************
FIM: Valida��o dos caracteres de senha.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Valida��o dos caracteres de e-mail:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT EMAIL FROM #VALIDA_SENHA_E_EMAIL WHERE EMAIL LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%') IS NULL
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'O email deve estar no seguinte formato: email@email.com.';

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;
				END;
			ELSE
				BEGIN
					PRINT 'O e-mail est� v�lido.';
				END;
		END;
/*************************************************************************************************************************************
FIM: Valida��o dos caracteres de e-mail.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
******************************************************** INSER��O NAS TABELAS *******************************************************
*************************************************************************************************************************************/
/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela ENDERECO.
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

				END;

			SET @IdEndereco = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela USUARIO.
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
/*************************************************************************************************************************************
FIM: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela CONTATOS.
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
				END

			SET @IdContatos = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela HOSPEDE.
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
						@IdEndereco,
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
******************************************************** INSER��O NAS TABELAS *******************************************************
*************************************************************************************************************************************/

		PRINT '------------------------------------------------ CADASTRO DE H�SPEDES -----------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'H�spede cadastrado com sucesso. Id: ' + CAST(@IdHospede AS VARCHAR) + '.';

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