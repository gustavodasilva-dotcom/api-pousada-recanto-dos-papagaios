USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspCadastrarAlerta]
	 @Titulo		varchar(50)
	,@Mensagem		varchar(200)
	,@IdFuncionario	int
	,@Json			varchar(500)
AS
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para cadastrar novos alertas.
Data.....: 13/10/2021
*************************************************************************************************************************************/
	BEGIN
		
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declara��o de vari�veis:
*************************************************************************************************************************************/
		DECLARE @Retorno	varchar(200);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @Codigo		int;
		DECLARE @IdAlerta	int;

/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'In�cio da an�lise para cadastro de alertas.'
		
		SET @Entidade	= 'Alertas';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Retorno,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Retorno = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o id do funcion�rio corresponde a um funcion�rio na base de dados:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Retorno = 'N�o foi encontrado funcion�rio para o id ' + CAST(@IdFuncionario AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Retorno,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela ALERTAS.
*************************************************************************************************************************************/
		IF @Retorno IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY
				
					INSERT INTO ALERTAS
					VALUES
					(
						 @Titulo
						,@Mensagem
						,@IdFuncionario
						,GETDATE()
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

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Retorno,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdAlerta = @@IDENTITY;

		END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela ALERTAS.
*************************************************************************************************************************************/

		IF @Retorno IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Retorno = 'Alerta cadastrado com sucesso no id ' + CAST(@IdAlerta AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Retorno,
			@Acao		= @Acao,
			@IdCadastro	= @IdAlerta,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Retorno AS Mensagem;

	END;
GO