USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspAtualizarAcomodacao]
	 @IdAcomodacao	int
	,@Nome			varchar(100)
	,@Categoria		int
	,@Capacidade	int
	,@Tamanho		float(2)
	,@TipoDeCama	varchar(200)
	,@Preco			float(2)
	,@Json			varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de acomodações (no momento, apenas na API).
Data.....: 27/10/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(max) = 'Início da análise para atualização do Chalé ' + CAST(@IdAcomodacao AS VARCHAR) + '.';
		DECLARE @Entidade	varchar(50)  = 'Acomodação';
		DECLARE @Acao		varchar(50)  = 'Atualizar';
		DECLARE @Codigo		int			 = 0;

/*********************************************************************************************************************************
Log de início:
*********************************************************************************************************************************/		
		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdAcomodacao,
		@StatusCode	= @Codigo;

		SET @Codigo   = NULL;
		SET @Mensagem = NULL;

/*********************************************************************************************************************************
Validando se a categoria informada está registrada no banco de dados:
*********************************************************************************************************************************/
		IF (SELECT 1 FROM INFORMACOES_ACOMODACAO WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'A categoria informada está inválida.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAcomodacao,
			@StatusCode	= @Codigo;
		END;

/*********************************************************************************************************************************
Validando se a capacidade informada está coerente com o cadastro de capacidade na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Capacidade <>
			   (
					SELECT INFO_ACOMOD_CAPACIDADE_INT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O capacidade informada está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o preço informado está coerente com o cadastro de preço na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Preco <>
			   (
					SELECT INFO_ACOMOD_PRECO_FLOAT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O preço informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o tamanho informado está coerente com o cadastro de tamanho na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Tamanho <>
			   (
					SELECT INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O tamanho informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o tipe de cama informada está coerente com o cadastro de tipo de cama na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @TipoDeCama <>
			   (
					SELECT INFO_ACOMOD_TIPO_DE_CAMA_STR
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O tipo de cama informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
INÍCIO: Atualizando acomodação:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	ACOMODACAO
					SET
							 ACO_NOME_STR			= @Nome
							,ACO_INFO_ACOMOD_ID_INT = @Categoria
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

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdAcomodacao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*********************************************************************************************************************************
FIM: Atualizando acomodação.
*********************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN

			SET @Codigo = 200;
			SET @Mensagem = 'Acomodação atualizada com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAcomodacao,
			@StatusCode	= @Codigo;

		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO