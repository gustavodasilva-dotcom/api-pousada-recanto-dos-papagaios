USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspVerificarReservasSemCheckIn]
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure chamada pelo serviço que verifica quais são as reservas que passaram do dia atual (GETDATE()) e não foram confir-
		   madas, ou seja, não passaram pelo processo de check-in.
Data.....: 04/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem nvarchar(255);

/*************************************************************************************************************************************
INÍCIO: Iniciando processo:
*************************************************************************************************************************************/
		IF OBJECT_ID('TEMPDB..#RESERVAS_CHECKIN_VENCIDO') IS NOT NULL DROP TABLE #RESERVAS_CHECKIN_VENCIDO;

		SELECT	RES_ID_INT
		INTO	#RESERVAS_CHECKIN_VENCIDO
		FROM	RESERVA
		WHERE	RES_DATA_CHECKIN_DATE < CONVERT(date, GETDATE(), 121)
		  AND	RES_ST_RES_INT = 1;

		BEGIN TRANSACTION
		
			BEGIN TRY

				UPDATE	RESERVA
				SET
						RES_ST_RES_INT = 4
				WHERE	RES_ID_INT IN
				(
					SELECT RES_ID_INT FROM #RESERVAS_CHECKIN_VENCIDO
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

				SELECT @Mensagem = ERROR_MESSAGE();

				RAISERROR(@Mensagem, 20, -1) WITH LOG;

			END CATCH;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Finalizando processo.
*************************************************************************************************************************************/

	END;
GO