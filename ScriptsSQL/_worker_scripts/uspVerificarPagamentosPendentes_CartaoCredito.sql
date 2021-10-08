USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspVerificarPagamentosPendentes_CartaoCredito]
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure chamada pelo serviço que verifica quais são as reservas que possuem, como forma de pagamento, a modalidade cartão
		   de crédito, mas que, entretanto, ainda não foram processadas como "Aprovado" em um período de três dias (GETDATE() e 
		   GETDATE() - 3).
Data.....: 05/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem			nvarchar(255);
		DECLARE @IdPagamentoReserva	int;
		DECLARE @Contador			int;
		DECLARE @Tamanho			int;

/*************************************************************************************************************************************
INÍCIO: Iniciando processo:
*************************************************************************************************************************************/
		IF OBJECT_ID('TEMPDB..#CARTAOCREDITO_PENDENTES') IS NOT NULL DROP TABLE #CARTAOCREDITO_PENDENTES;

		SELECT      RES_ID_INT
		INTO		#CARTAOCREDITO_PENDENTES
        FROM		RESERVA R
        INNER JOIN	PAGAMENTO_RESERVA PR ON PR.PGTO_RES_RES_ID_INT = R.RES_ID_INT
        WHERE RES_DATA_CADASTRO_DATETIME > GETDATE() - 3
          AND RES_DATA_CADASTRO_DATETIME < GETDATE()
          AND PGTO_RES_TPPGTO_ID_INT = 3
          AND PGTO_RES_ST_PGTO_ID_INT = 4;

		IF (SELECT TOP 1 1 FROM #CARTAOCREDITO_PENDENTES) IS NULL
			BEGIN
				
				SET @Mensagem = 'Não há pagamentos de cartão de crédito pendentes.';

				SELECT @Mensagem AS Resultado;

			END;

		ELSE

			BEGIN

				SET @Contador = 0;

				SELECT @Tamanho = COUNT(1) FROM #CARTAOCREDITO_PENDENTES

				WHILE @Contador < @Tamanho
				BEGIN

					SELECT		@IdPagamentoReserva = PGTO_RES_ID_INT
					FROM		PAGAMENTO_RESERVA	AS PR
					INNER JOIN	RESERVA				AS R ON PR.PGTO_RES_RES_ID_INT = R.RES_ID_INT
					WHERE		PR.PGTO_RES_ST_PGTO_ID_INT = 4 AND R.RES_ID_INT IN
					(
						SELECT RES_ID_INT FROM #CARTAOCREDITO_PENDENTES
					);

					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	PAGAMENTO_RESERVA
							SET
									PGTO_RES_ST_PGTO_ID_INT = 1
							WHERE	PGTO_RES_ID_INT = @IdPagamentoReserva;

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

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

					SET @IdPagamentoReserva = NULL;

					SET @Contador = @Contador + 1;

				END;
				
				SET @Mensagem = 'Verificação de pagamentos pendentes de cartão de crédito realizada com sucesso.';

				SELECT @Mensagem AS Resultado;

			END;
/*************************************************************************************************************************************
FIM: Finalizando processo.
*************************************************************************************************************************************/

	END;
GO