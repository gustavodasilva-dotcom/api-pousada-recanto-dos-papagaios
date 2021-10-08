USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspEsqueciMinhaSenha_EncontrarConta]
	@Cpf	nchar(11)

	--[uspEsqueciMinhaSenha_EncontrarConta] 29512324628
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, na primeira validação do processo de "Esqueci Minha Senha", onde será validado
		   se o CPF do usuário está cadastrado no sistema.
Data.....: 22/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Codigo		int;
		DECLARE @Mensagem	nvarchar(255);

/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		IF  (
				SELECT		1
				FROM		USUARIO		AS U
				INNER JOIN	FUNCIONARIO AS F ON F.FUNC_USU_ID_INT = U.USU_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf
			)
		IS NULL
			BEGIN

				SET @Mensagem = 'Usuário não encontrado com o CPF ' + @Cpf;

				SET @Codigo = 404;

			END;

		ELSE

			BEGIN

				SET @Mensagem = 'Usuário encontrado.'

				SET @Codigo = 200;

			END;
/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO