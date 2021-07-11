/*************************************************************************************************************************************
--Antes de rodar a procedure, caso não exista, criar a tabela temporária a seguir:

		--CREATE TABLE #RESULTADO
		--(
		--	ID_CHALE INT NOT NULL,
		--	NOME_CHALE VARCHAR(50) NOT NULL,
		--	DESCRICAO_CHALE VARCHAR(50) NOT NULL,
		--	STATUS_CHALE VARCHAR(50) NOT NULL,
		--	METROS_QUADRADOS_CHALE FLOAT(2) NOT NULL,
		--	CAPACIDADE_CALE INT NOT NULL,
		--	TIPO_CAMA_CHALE VARCHAR(50) NOT NULL,
		--	PRECO_DIARIA_CHALE FLOAT(2) NOT NULL
		--);

*************************************************************************************************************************************/


USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[SP_CriarAcomodacao]
	@NomeAcomodacao nvarchar(50),	@InfoAcomodacao int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure interna para criação de acomodações no banco de dados.
Data.....: 04/07/2021
*************************************************************************************************************************************/
--***********************************************************************************************
--Declaração de variáveis.
--***********************************************************************************************
		DECLARE
			@ValidacaoNome nvarchar(50),
			@Msg nvarchar(255),
			@MsgResul nvarchar(255)


--***********************************************************************************************
--Validação dos dados de entrada.
--***********************************************************************************************
		SELECT @ValidacaoNome = ACO_NOME_STR FROM RECPAPAGAIOS.dbo.[ACOMODACAO] WHERE ACO_NOME_STR = @NomeAcomodacao;

		IF @ValidacaoNome IS NOT NULL
			BEGIN
				SET @MsgResul = 'Já existe uma acomodação cadastrada com o nome ' + @ValidacaoNome;
			END
		ELSE IF @InfoAcomodacao > 3
			BEGIN
				SET @Msg = 'O id das informações da acomodação deve ser igual ou menor a 3. *'
					+ 'O id do chalé deve ser correspondente aos seguintes: *'
					+ '1 - Chalé Standard *'
					+ '2 - Chalé Superior *'
					+ '3 - Chalé Master *';
				SET @MsgResul = REPLACE(@Msg, '*', CHAR(10));
			END
		
		PRINT @MsgResul;


--***********************************************************************************************
--Validação dos dados de entrada.
--***********************************************************************************************
		BEGIN TRANSACTION
			INSERT INTO RECPAPAGAIOS.dbo.[ACOMODACAO]
			VALUES
			(
				@NomeAcomodacao,
				3, -- O status da acomodação, ao ser criada, será, sempre, 3, ou seja, disponível.
				@InfoAcomodacao,
				0 -- Toda acomodação, ao ser criada, terá, sempre, o excluído igual 0, ou seja, falso.
			);
		COMMIT TRANSACTION


--***********************************************************************************************
--Apresentando os dados de criação da acomodação.
--***********************************************************************************************
		IF OBJECT_ID('TEMPDB..#RESULTADO') IS NOT NULL TRUNCATE TABLE #RESULTADO;

		SELECT TOP 1 A.ACO_ID_INT, A.ACO_NOME_STR,			C.CAT_ACOMOD_DESCRICAO_STR,		S.ST_ACOMOD_DESCRICAO_STR,
					 I.INFO_ACOMOD_METROS_QUADRADOS_FLOAT,  I.INFO_ACOMOD_CAPACIDADE_INT,
					 I.INFO_ACOMOD_TIPO_DE_CAMA_STR,		I.INFO_ACOMOD_PRECO_FLOAT
		INTO		 #RESULTADO
		FROM		 [ACOMODACAO] AS A
		INNER JOIN   [STATUS_ACOMODACAO] AS S ON A.ACO_ST_ACOMOD_INT = S.ST_ACOMOD_ID_INT
		INNER JOIN   [INFORMACOES_ACOMODACAO] AS I ON A.ACO_INFO_ACOMOD_ID_INT = I.INFO_ACOMOD_ID_INT
		INNER JOIN   [CATEGORIA_ACOMODACAO] AS C ON C.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT
		ORDER BY A.ACO_ID_INT DESC;

		SELECT * FROM #RESULTADO;
	END
GO