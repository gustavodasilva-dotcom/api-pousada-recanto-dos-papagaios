USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspEsqueciMinhaSenha_EncontrarConta]
	@Cpf	nchar(11)

	--[uspEsqueciMinhaSenha_EncontrarConta] 29512324628
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
		DECLARE @Codigo		int;
		DECLARE @Mensagem	nvarchar(255);

/*************************************************************************************************************************************
IN�CIO: Valida��o dos dados de entrada:
*************************************************************************************************************************************/
		IF  (
				SELECT		1
				FROM		USUARIO		AS U
				INNER JOIN	FUNCIONARIO AS F ON F.FUNC_USU_ID_INT = U.USU_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf
			)
		IS NULL
			BEGIN

				SET @Mensagem = 'Usu�rio n�o encontrado com o CPF ' + @Cpf;

				SET @Codigo = 404;

			END;

		ELSE

			BEGIN

				SET @Mensagem = 'Usu�rio encontrado.'

				SET @Codigo = 200;

			END;
/*************************************************************************************************************************************
FIM: Valida��o dos dados de entrada.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO