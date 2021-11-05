USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspCadastrarFNRH]
	 @IdHospede			int
	,@Profissao			nvarchar(255)
	,@Nacionalidade		nvarchar(255)
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
Descrição: Procedure utilizada para cadastrar novas FNRHs de um hóspede em sistema (até o momento, procedure utilizada na API).
Data.....: 25/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(255);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @IdFNRH		int;
		DECLARE @Codigo		int;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de FNRH.'
		
		SET @Entidade	= 'FNRH';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @FNRHJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o hóspede existe em sistema:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'Não existe, em sistema, hóspede cadastrado para o id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Setando as variáveis como nulas, caso tenham encontrado com os valores vazios ou string.
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
INÍCIO: Inserindo na tabela FNRH.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO FNRH
					VALUES
					(
						@Profissao,
						@Nacionalidade,
						@Sexo,
						@Rg,
						@ProximoDestino,
						@UltimoDestino,
						@MotivoViagem,
						@MeioDeTransporte,
						@PlacaAutomovel,
						@NumAcompanhantes,
						@IdHospede,
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

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @FNRHJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdFNRH = @@IDENTITY;

		END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela FNRH.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'FNRH cadastrada com sucesso. Id: ' + CAST(@IdFNRH AS VARCHAR(8)) + ' referente ao hóspede ' + CAST(@IdHospede AS VARCHAR(8));
			
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