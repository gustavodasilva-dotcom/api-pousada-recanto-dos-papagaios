USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspAtualizarFNRH]
	 @IdFNRH			int
	,@Profissao			nvarchar(255)
	,@Nacionalidade		nvarchar(50)
	,@Sexo				nchar(1)
	,@Rg				nchar(9)
	,@ProximoDestino	nvarchar(255)
	,@UltimoDestino		nvarchar(255)
	,@MotivoViagem		nvarchar(255)
	,@MeioDeTransporte	nvarchar(255)
	,@PlacaAutomovel	nvarchar(255)
	,@NumAcompanhantes	int
	,@FNRHJson			nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada para atualiza��o de FNRHs (no momento, apenas na API).
Data.....: 26/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declara��o das vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @IdHospede	INT;
		DECLARE @Codigo		INT;

/*************************************************************************************************************************************
IN�CIO: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'In�cio da an�lise para atualiza��o de FNRH.';
		
		SET	@Entidade	= 'FNRH';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @FNRHJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdFNRH,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de in�cio de an�lise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se j� existe uma FNRH cadastrada com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FNRH WHERE FNRH_ID_INT = @IdFNRH AND FNRH_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'N�o existe nenhuma FNRH cadastrada no sistema com o id ' + CAST(@IdFNRH AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFNRH,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Setando as vari�veis como nulas, caso tenham encontrado com os valores vazios ou string:
*************************************************************************************************************************************/
		IF (@Profissao  = '' OR @Profissao = 'string')
		BEGIN
			SET @Profissao = NULL;
		END;

		IF (@Nacionalidade  = '' OR @Nacionalidade = 'string')
		BEGIN
			SET @Nacionalidade = NULL;
		END;

		IF (@Sexo  = '' OR @Sexo = 'string')
		BEGIN
			SET @Sexo = NULL;
		END;

		IF (@Rg  = '' OR @Rg = 'string')
		BEGIN
			SET @Rg = NULL;
		END;

		IF (@ProximoDestino  = '' OR @ProximoDestino = 'string')
		BEGIN
			SET @ProximoDestino = NULL;
		END;

		IF (@UltimoDestino  = '' OR @UltimoDestino = 'string')
		BEGIN
			SET @UltimoDestino = NULL;
		END;

		IF (@MotivoViagem  = '' OR @MotivoViagem = 'string')
		BEGIN
			SET @MotivoViagem = NULL;
		END;

		IF (@MeioDeTransporte  = '' OR @MeioDeTransporte = 'string')
		BEGIN
			SET @MeioDeTransporte = NULL;
		END;

		IF (@PlacaAutomovel  = '' OR @PlacaAutomovel = 'string')
		BEGIN
			SET @PlacaAutomovel = NULL;
		END;


/*************************************************************************************************************************************
IN�CIO: Atualizando na tabela FNRH:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	FNRH
					SET
							 FNRH_PROFISSAO_STR				= @Profissao
							,FNRH_NACIONALIDADE_STR			= @Nacionalidade
							,FNRH_SEXO_CHAR					= @Sexo
							,FNRH_RG_CHAR					= @Rg
							,FNRH_PROXIMO_DESTINO_STR		= @ProximoDestino
							,FNRH_ULTIMO_DESTINO_STR		= @UltimoDestino
							,FNRH_MOTIVO_VIAGEM_STR			= @MotivoViagem
							,FNRH_MEIO_DE_TRANSPORTE_STR	= @MeioDeTransporte
							,FNRH_PLACA_AUTOMOVEL_STR		= @PlacaAutomovel
							,FNRH_NUM_ACOMPANHANTES_INT		= @NumAcompanhantes
					WHERE	FNRH_ID_INT = @IdFNRH;

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
					@Json		= @FNRHJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdFNRH,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela FNRH.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
IN�CIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'FNRH ' + CAST(@IdFNRH AS VARCHAR(8)) + ' atualizada com sucesso!'; 
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFNRH,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO