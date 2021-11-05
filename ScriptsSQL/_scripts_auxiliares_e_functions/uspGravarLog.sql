USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspGravarLog]
	 @Json			nvarchar(600) = NULL
	,@Entidade		nvarchar(50)
	,@Mensagem		nvarchar(255)
	,@Acao			nvarchar(50)
	,@IdCadastro	int = NULL
	,@StatusCode	int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para gravar os logs das chamadas à API.
Data.....: 23/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

		BEGIN TRANSACTION;

			BEGIN TRY

				INSERT INTO LOGSINTEGRACOES
				VALUES
				(
					@Entidade,
					@Json,
					@Mensagem,
					@Acao,
					@StatusCode,
					@IdCadastro,
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
					
			END CATCH;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

	END
GO