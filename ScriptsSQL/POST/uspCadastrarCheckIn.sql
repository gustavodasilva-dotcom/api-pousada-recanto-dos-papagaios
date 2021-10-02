USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspCadastrarCheckIn]
	 @IdReserva		int
	,@IdFuncionario	int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para executar o check-in sobre reservas (no momento, apenas na aplica��o desktop).
Data.....: 27/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o de vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @DescricaoPagamento		nvarchar(255);
		DECLARE @StatusPagamento		nvarchar(255);
		DECLARE @StatusReserva			nvarchar(255);
		DECLARE @DataCheckIn			date;
		DECLARE @Codigo					int;
		DECLARE @IdStatusPagamento		int;
		DECLARE @IdStatusReserva		int;
		DECLARE @IdReservaCadastrada	int;
		DECLARE @IdCheckIn				int;
		DECLARE @IdCheckOut				int;
		DECLARE @IdPagamento			int;


/*************************************************************************************************************************************
SELECT prinicpal que atribui valor �s vari�veis:
*************************************************************************************************************************************/
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@IdCheckIn				= CI.CHECKIN_ID_INT
					,@IdCheckOut			= CO.CHECKOUT_ID_INT
					,@IdPagamento			= PR.PGTO_RES_ID_INT
					,@DataCheckIn			= R.RES_DATA_CHECKIN_DATE
					,@DescricaoPagamento	= TP.TPPGTO_TIPO_PAGAMENTO_STR
					,@IdStatusPagamento		= PR.PGTO_RES_ST_PGTO_ID_INT
					,@StatusPagamento		= ST.ST_PGTO_DESCRICAO_STR
					,@IdStatusReserva		= R.RES_ST_RES_INT
					,@StatusReserva			= SR.ST_RES_DESCRICAO_STR
		FROM		RESERVA				AS R
		INNER JOIN	PAGAMENTO_RESERVA	AS PR ON R.RES_ID_INT				= PR.PGTO_RES_RES_ID_INT
		INNER JOIN	STATUS_PAGAMENTO	AS ST ON PR.PGTO_RES_ST_PGTO_ID_INT	= ST.ST_PGTO_ID_INT
		INNER JOIN	STATUS_RESERVA		AS SR ON R.RES_ST_RES_INT			= SR.ST_RES_ID_INT
		INNER JOIN	TIPO_PAGAMENTO		AS TP ON PR.PGTO_RES_TPPGTO_ID_INT	= TP.TPPGTO_ID_INT
		LEFT JOIN	CHECKIN				AS CI ON R.RES_ID_INT				= CI.CHECKIN_RES_ID_INT
		LEFT JOIN	CHECKOUT			AS CO ON CI.CHECKIN_ID_INT			= CO.CHECKOUT_CHECKIN_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;


		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '-------------------------------------- PROCEDIMENTO DE EXECU��O DE CHECK-IN -----------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
Imprimindo o valor das vari�veis para valida��o interna:
*************************************************************************************************************************************/
		PRINT 'Id da reserva: ' + CAST(@IdReservaCadastrada AS VARCHAR);
		PRINT 'Data de check-in: ' + CAST(@DataCheckIn AS VARCHAR);
		PRINT 'Data de check-out: ' + CASE WHEN @IdCheckOut IS NULL THEN 'N�o h� check-out.' ELSE 'CAST(@IdCheckOut AS VARCHAR)' END;
		PRINT 'Id do pagamento: ' + CAST(@IdPagamento AS VARCHAR);
		PRINT 'Descri��o do pagamento: ' + @DescricaoPagamento;
		PRINT 'Status do pagamento: ' + @DescricaoPagamento;
		PRINT 'Status da reserva: ' + @StatusReserva;

/*************************************************************************************************************************************
Validando se a reserva existe no sistema:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'N�o existe, no sistema, reserva com o id ' + CAST(@IdReserva AS VARCHAR) + '.';
		END;

/*************************************************************************************************************************************
Validando se a reserva est� cancelada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdStatusReserva <> 1
			BEGIN
				SET @Codigo = 409;	
				SET @Mensagem = 'A reserva est� ' + @StatusReserva + '. Sendo assim, n�o � poss�vel executar o check-in.';
			END;
		END;

/*************************************************************************************************************************************
Verificando se a reserva j� possui check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdCheckIn IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' j� possui check-in.';
			END;
		END;
		
/*************************************************************************************************************************************
Verificando se a reserva j� possui check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdCheckOut IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' j� possui check-out.';
			END;
		END;
		
/*************************************************************************************************************************************
Verificando se a data de check-in da reserva � igual a data do dia (GETDATE()):
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @DataCheckIn < CONVERT(date, GETDATE(), 121)
			BEGIN
				SET @Codigo = 422;
				SET	@Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' passou da data de check-in.';
			END;

		END;

/*************************************************************************************************************************************
Verificando os dados de pagamento da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			IF @IdStatusPagamento <> 1
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A forma de pagamento selecionada para essa reserva foi ' + @DescricaoPagamento + ' e, no momento,' +
								' encontra-se ' + @StatusPagamento + '.';
			END;

		END;

/*************************************************************************************************************************************
Verificando se o funcion�rio informado existe no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionario AND FUNC_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'O id ' + CAST(@IdFuncionario AS VARCHAR) + ' n�o corresponde a um funcion�rio.';
			END;
		END;
		

/*************************************************************************************************************************************
********************************************* INSERINDO E ATUALIZANDO AS DEVIDAS TABELAS: ********************************************
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
IN�CIO: Inserindo na tabela CHECKIN:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO CHECKIN
					VALUES
					(
						 @IdReserva
						,@IdFuncionario
						,0
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

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Inserindo na tabela CHECKIN.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
IN�CIO: Atualizando na tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							RES_ST_RES_INT	= 2
					WHERE	RES_ID_INT		= @IdReserva;

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

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SELECT @IdCheckIn = CHECKIN_ID_INT FROM CHECKIN WHERE CHECKIN_RES_ID_INT = @IdReserva
/*************************************************************************************************************************************
FIM: Atualizando na tabela RESERVA.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
********************************************* INSERINDO E ATUALIZANDO AS DEVIDAS TABELAS. ********************************************
*************************************************************************************************************************************/
		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '-------------------------------------- PROCEDIMENTO DE EXECU��O DE CHECK-IN -----------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';


		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Check-in da reserva ' + CAST(@IdReserva AS VARCHAR) + ' realizado com sucesso.';
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO