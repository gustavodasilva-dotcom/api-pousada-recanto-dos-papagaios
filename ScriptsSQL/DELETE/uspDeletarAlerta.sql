USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspDeletarAlerta]
	 @IdAlerta	int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para excluir alertas.
Data.....: 15/10/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declara��o de vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(200);
		DECLARE @Json		varchar(200);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @Codigo		int;

/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'In�cio da an�lise para dele��o de alertas.';
		
		SET @Json		= 'Solicita��o de dele��o do alerta ' + CAST(@IdAlerta AS VARCHAR) + '.';

		SET @Entidade	= 'Alertas';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdAlerta,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o id corresponde a um alerta na base de dados:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM ALERTAS WHERE ALERTAS_ID_INT = @IdAlerta AND ALERTAS_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'O alerta ' + CAST(@IdAlerta AS VARCHAR) + ' n�o foi encontrado.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAlerta,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
IN�CIO: Atualizando a tabela ALERTAS:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY
				
					UPDATE ALERTAS
					SET
						ALERTAS_EXCLUIDO_BIT = 1
					WHERE ALERTAS_ID_INT = @IdAlerta;

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
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdAlerta,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*************************************************************************************************************************************
FIM: Atualizando a tabela ALERTAS.
*************************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Alerta ' + CAST(@IdAlerta AS VARCHAR) + ' deletado com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAlerta,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO