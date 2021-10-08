USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspCriarAcomodacao]
	@NomeAcomodacao nvarchar(50),
	@InfoAcomodacao int
AS
	BEGIN
/*************************************************************************************************************************************
Descri��o: Procedure interna para cria��o de acomoda��es no banco de dados.
Data.....: 04/07/2021

Modifica��es:

Data.....: Ajustando procedure para que, ao criar uma acomoda��o, registre o dia da cria��o.
Descri��o: 19/08/2021
*************************************************************************************************************************************/
--***********************************************************************************************
--Declara��o de vari�veis.
--***********************************************************************************************
		DECLARE
			@ValidacaoNome	varchar(50),
			@Msg			varchar(255),
			@MsgResul		varchar(255)


--***********************************************************************************************
--Valida��o dos dados de entrada.
--***********************************************************************************************
		SELECT @ValidacaoNome = ACO_NOME_STR FROM RECPAPAGAIOS.dbo.[ACOMODACAO] WHERE ACO_NOME_STR = @NomeAcomodacao;

		IF @ValidacaoNome IS NOT NULL
			BEGIN
				SET @MsgResul = 'J� existe uma acomoda��o cadastrada com o nome ' + @ValidacaoNome;

				RAISERROR(@MsgResul, 20, -1) WITH LOG;
			END
		
		IF @InfoAcomodacao > 3
		BEGIN
			SET @Msg = 'O id das informa��es da acomoda��o deve ser igual ou menor a 3. *'
				+ 'O id do chal� deve ser correspondente aos seguintes: *'
				+ '1 - Chal� Standard *'
				+ '2 - Chal� Superior *'
				+ '3 - Chal� Master *';
			SET @MsgResul = REPLACE(@Msg, '*', CHAR(10));

			RAISERROR(@MsgResul, 20, -1) WITH LOG;
		END


--***********************************************************************************************
--Valida��o dos dados de entrada.
--***********************************************************************************************
		BEGIN TRANSACTION

			INSERT INTO RECPAPAGAIOS.dbo.[ACOMODACAO]
			VALUES
			(
				@NomeAcomodacao,
				3,
				@InfoAcomodacao,
				0,
				GETDATE()
			);
		
		COMMIT TRANSACTION


--***********************************************************************************************
--Apresentando os dados de cria��o da acomoda��o.
--***********************************************************************************************
		
		SELECT		TOP 1
					A.ACO_ID_INT,
					A.ACO_NOME_STR,
					C.CAT_ACOMOD_DESCRICAO_STR,
					S.ST_ACOMOD_DESCRICAO_STR,
					I.INFO_ACOMOD_METROS_QUADRADOS_FLOAT,
					I.INFO_ACOMOD_CAPACIDADE_INT,
					I.INFO_ACOMOD_TIPO_DE_CAMA_STR,
					I.INFO_ACOMOD_PRECO_FLOAT
		FROM		[ACOMODACAO]				AS A
		INNER JOIN  [STATUS_ACOMODACAO]			AS S ON A.ACO_ST_ACOMOD_INT			= S.ST_ACOMOD_ID_INT
		INNER JOIN  [INFORMACOES_ACOMODACAO]	AS I ON A.ACO_INFO_ACOMOD_ID_INT	= I.INFO_ACOMOD_ID_INT
		INNER JOIN  [CATEGORIA_ACOMODACAO]		AS C ON C.CAT_ACOMOD_ID_INT			= I.INFO_ACOMOD_CAT_ACOMOD_ID_INT
		ORDER BY	A.ACO_ID_INT DESC;

	END
GO