USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspPerguntaDeSeguranca]
	 @Cpf		nchar(11)
	,@Reposta	nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure utilizada, na aplica��o desktop, para validar se a resposta inserida pelo usu�rio, na funcionalidade Esqueci
		   Minha Senha, est� em acordo com a cadastrada na base de dados.
Data.....: 23/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declara��o de vari�veis:
*************************************************************************************************************************************/
		DECLARE @RespostaCadastrada	nvarchar(max);
		DECLARE @Mensagem			nvarchar(255);
		DECLARE @Codigo				int;

/*************************************************************************************************************************************
SELECT principal que atribui valor �s vari�veis:
*************************************************************************************************************************************/
		SELECT		@RespostaCadastrada = P.PERG_SEG_RESPOSTA_STR
		FROM		FUNCIONARIO			AS F
		INNER JOIN	USUARIO				AS U ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
		INNER JOIN	PERGUNTA_SEGURANCA	AS P ON U.USU_ID_INT		= P.PERG_SEG_USU_ID_INT
		WHERE		F.FUNC_CPF_CHAR = @Cpf;

/*************************************************************************************************************************************
IN�CIO: Valida��o dos dados de entrada:
*************************************************************************************************************************************/
		IF RTRIM(LTRIM(@Reposta)) = @RespostaCadastrada
			BEGIN

				SET @Mensagem = 'A resposta est� em acordo com a resposta cadastrada.';

				SET @Codigo = 200;

			END;
			
		ELSE

			BEGIN

				SET @Mensagem = 'A resposta n�o est� de acordo com a resposta cadastrada.';

				SET @Codigo = 404;

			END;
/*************************************************************************************************************************************
FIM: Valida��o dos dados de entrada.
*************************************************************************************************************************************/

		SELECT @Mensagem AS Mensagem, @Codigo AS Codigo;

	END;
GO