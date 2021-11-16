USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspCadastrarHospede]
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
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_CPF_CHAR = @Cpf) IS NOT NULL
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

					SET @IdEndereco = @@IDENTITY;
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

					SET @IdEndereco = @@IDENTITY;
				END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/
			IF @NomeUsuario <> '' AND @Senha <> ''
			BEGIN
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
			END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela CONTATOS.
*************************************************************************************************************************************/
			IF  (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
				OR
				(@Celular IS NULL) OR (@Celular = '') OR (@Celular = 'string')
				BEGIN
					BEGIN TRANSACTION

						BEGIN TRY
						
							INSERT INTO CONTATOS
							(
								CONT_EMAIL_STR,
								CONT_EXCLUIDO_BIT,
								CONT_DATA_CADASTRO_DATETIME
							)
							VALUES
							(
								@Email,
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

					SET @IdContatos = @@IDENTITY;
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

					SET @IdContatos = @@IDENTITY;
				END;
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
						@IdContatos,
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