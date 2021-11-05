USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspTrocarAcomodacoesOcupadoParaDisponivel]
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure chamada pelo serviço que verifica quais são as acomodações que estão marcadas como "Ocupadas". Entretanto, as re-
		   servas são reservas que data de check-in vence no dia atual (GETDATE()).
Data.....: 06/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem			nvarchar(255);
		DECLARE @PrimeiroRegistro	int;

/*************************************************************************************************************************************
INÍCIO: Iniciando processo:
*************************************************************************************************************************************/
		IF OBJECT_ID('TEMPDB..#ACOMODACAO_LIVRE') IS NOT NULL DROP TABLE #ACOMODACAO_LIVRE;
		
		SELECT		A.ACO_ID_INT
		INTO		#ACOMODACAO_LIVRE
		FROM		RESERVA		AS R
		INNER JOIN	ACOMODACAO	AS A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
		WHERE		R.RES_DATA_CHECKOUT_DATE < GETDATE()
		  AND		A.ACO_ST_ACOMOD_INT = 1;
		

		IF (SELECT TOP 1 1 FROM #ACOMODACAO_LIVRE) IS NOT NULL
			BEGIN

				BEGIN TRANSACTION;

					BEGIN TRY
						
						UPDATE	ACOMODACAO
						SET
								ACO_ST_ACOMOD_INT = 3
						WHERE	ACO_ID_INT IN
						(
							SELECT ACO_ID_INT FROM #ACOMODACAO_LIVRE
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

				SET @Mensagem = 'Acomodações marcadas como ocupadas trocadas para "Disponíveis".';

			END;

		ELSE

			BEGIN

				SET @Mensagem = 'Não há acomodações com reservas pendentes marcadas como "Ocupadas".';

			END;

		SELECT @Mensagem;
/*************************************************************************************************************************************
FIM: Finalizando processo.
*************************************************************************************************************************************/

	END;
GO
