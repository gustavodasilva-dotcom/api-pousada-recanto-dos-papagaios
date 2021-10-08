USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspMarcarAcomodacaoComoDisponivel]
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Esta procedure é executada ao final de todo check-in realizado. A função dela é verificar reservas que estejam concluídas e
		   com chalés marcados como "Ocupado". Caso não haja reservas nos próximos três dias para um chalé, ele será marcado como dis-
		   ponível.
Data.....: 07/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Excluindo as tabelas temporárias:
*************************************************************************************************************************************/
		IF OBJECT_ID('TEMPDB..#DATAS_DE_CHECKOUT')				IS NOT NULL DROP TABLE #DATAS_DE_CHECKOUT;
		IF OBJECT_ID('TEMPDB..#RESERVAS_PROXIMOS_TRES_DIAS')	IS NOT NULL DROP TABLE #RESERVAS_PROXIMOS_TRES_DIAS;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @IdAcomodacao	int;
		DECLARE @Mensagem		nvarchar(255);


/*************************************************************************************************************************************
Selecionando todas as reservas que possuam uma data de check-out maior do que hoje (GETDATE()) e adicionando em uma tabela temporária
chamada #DATAS_DE_CHECKOUT. Atibruíndo à variável @IdAcomodacao o id do primeiro chalé encontrado na tabela temporária.
*************************************************************************************************************************************/
		SELECT		 RES_ID_INT
					,RES_DATA_CHECKOUT_DATE
					,RES_ACO_ID_INT
		INTO		#DATAS_DE_CHECKOUT
		FROM		RESERVA		R
		INNER JOIN	ACOMODACAO	A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
		WHERE		RES_ST_RES_INT		= 3	-- (Reservas concluídas.)
		  AND		A.ACO_ST_ACOMOD_INT = 1	-- (Chalé como "Ocupado".)
		  AND		RES_DATA_CHECKOUT_DATE > GETDATE();
		
		--SELECT RES_DATA_CHECKOUT_DATE FROM #DATAS_DE_CHECKOUT;
		
		SELECT TOP 1 @IdAcomodacao = RES_ACO_ID_INT FROM #DATAS_DE_CHECKOUT

/*************************************************************************************************************************************
Verificando se existe, nos próximos três dias, reservas para o chalé em @IdAcomodacao:
*************************************************************************************************************************************/	
		SELECT	 RES_ID_INT
				,RES_DATA_CHECKIN_DATE
				,RES_DATA_CHECKOUT_DATE
		INTO	#RESERVAS_PROXIMOS_TRES_DIAS
		FROM	RESERVA
		WHERE	RES_DATA_CHECKIN_DATE BETWEEN GETDATE() + 3 AND
		(
			SELECT TOP 1 RES_DATA_CHECKOUT_DATE FROM #DATAS_DE_CHECKOUT
		)
		AND		RES_ACO_ID_INT = @IdAcomodacao;

/*************************************************************************************************************************************
Caso seja nulo, colocar a acomodação (chalé) para "Disponível":
*************************************************************************************************************************************/
		IF (SELECT TOP 1 1 FROM #RESERVAS_PROXIMOS_TRES_DIAS) IS NULL
			BEGIN

				SET @Mensagem = 'Não há reservas nos próximos três dias para o Chalé ' + CAST(@IdAcomodacao AS VARCHAR);

				PRINT @Mensagem;


				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	ACOMODACAO
						SET
								ACO_ST_ACOMOD_INT = 3
						WHERE	ACO_ID_INT = @IdAcomodacao;

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

				SET @Mensagem = 'Chalé ' + CAST(@IdAcomodacao AS VARCHAR) + ' atualizado com sucesso.';

				PRINT @Mensagem;

			END;

		ELSE

			BEGIN

				SET @Mensagem = 'Há reservas nos próximos três dias para chalés ' + CAST(@IdAcomodacao AS VARCHAR);

				PRINT @Mensagem;

			END;

	END;
GO