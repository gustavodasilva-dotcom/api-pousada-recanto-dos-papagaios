USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspEsqueciMinhaSenha_EncontrarConta]
	@Cpf	nchar(11)
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada, na aplica��o desktop, na primeira valida��o do processo de "Esqueci Minha Senha", onde ser� validado
		   se o CPF do usu�rio est� cadastrado no sistema.
Data.....: 22/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o de vari�veis:
*************************************************************************************************************************************/
		DECLARE @IdUsuario	int;
		DECLARE @Codigo		int;
		DECLARE @Mensagem	nvarchar(255);

/*************************************************************************************************************************************
IN�CIO: Valida��o dos dados de entrada:
*************************************************************************************************************************************/
		SELECT		@IdUsuario = U.USU_ID_INT
		FROM		HOSPEDE	AS H
		INNER JOIN	USUARIO AS U ON H.HSP_USU_ID_INT = U.USU_ID_INT
		WHERE		H.HSP_CPF_CHAR = @Cpf;

		IF @IdUsuario IS NOT NULL
			BEGIN
				SELECT	@Cpf AS CPF
						,PERG_SEG_PERGUNTA_STR
						,PERG_SEG_RESPOSTA_STR
				FROM	PERGUNTA_SEGURANCA
				WHERE	PERG_SEG_USU_ID_INT = @IdUsuario;
			END;
		ELSE
			BEGIN
				SELECT		@IdUsuario = U.USU_ID_INT
				FROM		FUNCIONARIO	AS F
				INNER JOIN	USUARIO		AS U ON F.FUNC_USU_ID_INT = U.USU_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf;

				IF @IdUsuario IS NOT NULL
				BEGIN
					SELECT	 @Cpf AS CPF
							,PERG_SEG_PERGUNTA_STR
							,PERG_SEG_RESPOSTA_STR
					FROM	PERGUNTA_SEGURANCA
					WHERE	PERG_SEG_USU_ID_INT = @IdUsuario;
				END;
			END;

/*************************************************************************************************************************************
FIM: Valida��o dos dados de entrada.
*************************************************************************************************************************************/

	END;
GO