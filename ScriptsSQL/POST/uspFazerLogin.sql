USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspFazerLogin]
	@NomeUsuario	nvarchar(45),
	@Senha			nvarchar(200),
	@Json			nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para verificar o login nas telas desktop e web.
Data.....: 22/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE	@Codigo					int;
		DECLARE @NomeUsuarioCadastrado	nvarchar(45);
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @SenhaCadastrada		nvarchar(200);
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para execução de login.'
		
		SET @Entidade	= 'Login';

		SET @Acao		= 'Logar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Atribuindo valores às variáveis:
*************************************************************************************************************************************/
		SET @Codigo = 0

		SELECT		 @NomeUsuarioCadastrado = USU_NOME_USUARIO_STR
					,@SenhaCadastrada		= CAST(DECRYPTBYPASSPHRASE('key', USU_SENHA_STR) AS NVARCHAR)
		FROM		USUARIO		AS U
		INNER JOIN	FUNCIONARIO AS F ON U.USU_ID_INT = F.FUNC_USU_ID_INT
		WHERE		USU_NOME_USUARIO_STR = @NomeUsuario
		  AND		USU_EXCLUIDO_BIT = 0;

		IF @NomeUsuarioCadastrado IS NULL
		BEGIN
			SELECT		 @NomeUsuarioCadastrado = USU_NOME_USUARIO_STR
						,@SenhaCadastrada		= CAST(DECRYPTBYPASSPHRASE('key', USU_SENHA_STR) AS NVARCHAR)
			FROM		USUARIO	AS U
			INNER JOIN	HOSPEDE AS F ON U.USU_ID_INT = F.HSP_USU_ID_INT
			WHERE		USU_NOME_USUARIO_STR = @NomeUsuario
			  AND		USU_EXCLUIDO_BIT = 0;
		END;

/*************************************************************************************************************************************
INÍCIO: Validando os dados para liberar acesso:
*************************************************************************************************************************************/
		IF @NomeUsuarioCadastrado IS NULL
			BEGIN
				SET @Mensagem = 'O nome de usuário não existe cadastrado no sistema.';
				SET @Codigo = 422;

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;

		ELSE

			BEGIN

				IF @Senha <> @SenhaCadastrada
				BEGIN
					SET @Mensagem = 'A senha informada está inválida.';
					SET @Codigo = 422;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@StatusCode	= @Codigo;
				END;

			END;

		
		IF @Codigo = 0
		BEGIN
			SET @Mensagem = 'Usuário encontrado e validado.';
			SET @Codigo = 200;

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Validando os dados para liberar acesso.
*************************************************************************************************************************************/
	END;
GO