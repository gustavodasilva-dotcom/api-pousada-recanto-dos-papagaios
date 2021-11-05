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
Descri��o: Procedure utilizada para atualiza��o de acomoda��es (no momento, apenas na API).
Data.....: 27/10/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o das vari�veis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(max) = 'In�cio da an�lise para atualiza��o do Chal� ' + CAST(@IdAcomodacao AS VARCHAR) + '.';
		DECLARE @Entidade	varchar(50)  = 'Acomoda��o';
		DECLARE @Acao		varchar(50)  = 'Atualizar';
		DECLARE @Codigo		int			 = 0;

/*********************************************************************************************************************************
Log de in�cio:
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
Validando se a categoria informada est� registrada no banco de dados:
*********************************************************************************************************************************/
		IF (SELECT 1 FROM INFORMACOES_ACOMODACAO WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'A categoria informada est� inv�lida.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAcomodacao,
			@StatusCode	= @Codigo;
		END;

/*********************************************************************************************************************************
Validando se a capacidade informada est� coerente com o cadastro de capacidade na categoria:
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
				SET @Mensagem = 'O capacidade informada est� divergente do permitido � categoria selecionada.';

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
Validando se o pre�o informado est� coerente com o cadastro de pre�o na categoria:
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
				SET @Mensagem = 'O pre�o informado est� divergente do permitido � categoria selecionada.';

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
Validando se o tamanho informado est� coerente com o cadastro de tamanho na categoria:
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
				SET @Mensagem = 'O tamanho informado est� divergente do permitido � categoria selecionada.';

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
Validando se o tipe de cama informada est� coerente com o cadastro de tipo de cama na categoria:
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
				SET @Mensagem = 'O tipo de cama informado est� divergente do permitido � categoria selecionada.';

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
IN�CIO: Atualizando acomoda��o:
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
FIM: Atualizando acomoda��o.
*********************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN

			SET @Codigo = 200;
			SET @Mensagem = 'Acomoda��o atualizada com sucesso.';

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