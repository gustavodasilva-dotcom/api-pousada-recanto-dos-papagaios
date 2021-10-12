USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspPerguntaDeSeguranca]
	 @Cpf		nchar(11)
	,@Reposta	nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, para validar se a resposta inserida pelo usuário, na funcionalidade Esqueci
		   Minha Senha, está em acordo com a cadastrada na base de dados.
Data.....: 23/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @RespostaCadastrada	nvarchar(max);
		DECLARE @Mensagem			nvarchar(255);
		DECLARE @Codigo				int;

/*************************************************************************************************************************************
SELECT principal que atribui valor às variáveis:
*************************************************************************************************************************************/
		SELECT		@RespostaCadastrada = P.PERG_SEG_RESPOSTA_STR
		FROM		FUNCIONARIO			AS F
		INNER JOIN	USUARIO				AS U ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
		INNER JOIN	PERGUNTA_SEGURANCA	AS P ON U.USU_ID_INT		= P.PERG_SEG_USU_ID_INT
		WHERE		F.FUNC_CPF_CHAR = @Cpf;

/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		IF RTRIM(LTRIM(@Reposta)) = @RespostaCadastrada
			BEGIN

				SET @Mensagem = 'A resposta está em acordo com a resposta cadastrada.';

				SET @Codigo = 200;

			END;
			
		ELSE

			BEGIN

				SET @Mensagem = 'A resposta não está de acordo com a resposta cadastrada.';

				SET @Codigo = 404;

			END;
/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/

		SELECT @Mensagem AS Mensagem, @Codigo AS Codigo;

	END;
GO