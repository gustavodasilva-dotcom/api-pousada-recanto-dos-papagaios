USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspObterAcomodacoes]
	 @Tipo	int
	,@Id	int	= NULL
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter Acomodações (no momento, apenas na API).
Data.....: 30/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Codigo		INT;

/*************************************************************************************************************************************
INÍCIO: TIPO 1 - Selecionar todas as acomodações:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			IF @Id IS NULL
			BEGIN

				WITH
				STATUSDETODASASACOMODACOES
				(
					 Codigo
					,ACO_ID_INT
					,ACO_NOME_STR
					,ST_ACOMOD_ID_INT
					,ST_ACOMOD_DESCRICAO_STR
					,INFO_ACOMOD_ID_INT
					,INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					,INFO_ACOMOD_CAPACIDADE_INT
					,INFO_ACOMOD_TIPO_DE_CAMA_STR
					,INFO_ACOMOD_PRECO_FLOAT
					,CAT_ACOMOD_ID_INT
					,CAT_ACOMOD_DESCRICAO_STR

				)

				AS

				(

					SELECT		 200
								,A.ACO_ID_INT
								,A.ACO_NOME_STR
								,SA.ST_ACOMOD_ID_INT
								,SA.ST_ACOMOD_DESCRICAO_STR
								,IA.INFO_ACOMOD_ID_INT
								,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
								,IA.INFO_ACOMOD_CAPACIDADE_INT
								,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
								,IA.INFO_ACOMOD_PRECO_FLOAT
								,CA.CAT_ACOMOD_ID_INT
								,CA.CAT_ACOMOD_DESCRICAO_STR
					FROM		ACOMODACAO				AS A
					INNER JOIN	STATUS_ACOMODACAO		AS SA ON A.ACO_ST_ACOMOD_INT		= SA.ST_ACOMOD_ID_INT
					INNER JOIN	INFORMACOES_ACOMODACAO	AS IA ON A.ACO_INFO_ACOMOD_ID_INT	= IA.INFO_ACOMOD_ID_INT
					INNER JOIN	CATEGORIA_ACOMODACAO	AS CA ON CA.CAT_ACOMOD_ID_INT		= IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT
					WHERE		A.ACO_EXCLUIDO_BIT = 0

				)

				SELECT * FROM STATUSDETODASASACOMODACOES

			END;

		END;
/*************************************************************************************************************************************
FIM: TIPO 1 - Selecionar todas as acomodações.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
INÍCIO: TIPO 2 - Selecionar uma única acomodações:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN
				
			IF @Id IS NOT NULL
			BEGIN

				WITH
				STATUSDEUMAUNICAACOMODACAO
				(
					
					 Codigo
					,ACO_ID_INT
					,ACO_NOME_STR
					,ST_ACOMOD_ID_INT
					,ST_ACOMOD_DESCRICAO_STR
					,INFO_ACOMOD_ID_INT
					,INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					,INFO_ACOMOD_CAPACIDADE_INT
					,INFO_ACOMOD_TIPO_DE_CAMA_STR
					,INFO_ACOMOD_PRECO_FLOAT
					,CAT_ACOMOD_ID_INT
					,CAT_ACOMOD_DESCRICAO_STR
				)

				AS

				(

					SELECT		 200
								,A.ACO_ID_INT
								,A.ACO_NOME_STR
								,SA.ST_ACOMOD_ID_INT
								,SA.ST_ACOMOD_DESCRICAO_STR
								,IA.INFO_ACOMOD_ID_INT
								,IA.INFO_ACOMOD_METROS_QUADRADOS_FLOAT
								,IA.INFO_ACOMOD_CAPACIDADE_INT
								,IA.INFO_ACOMOD_TIPO_DE_CAMA_STR
								,IA.INFO_ACOMOD_PRECO_FLOAT
								,CA.CAT_ACOMOD_ID_INT
								,CA.CAT_ACOMOD_DESCRICAO_STR								
					FROM		ACOMODACAO				AS A
					INNER JOIN	STATUS_ACOMODACAO		AS SA ON A.ACO_ST_ACOMOD_INT		= SA.ST_ACOMOD_ID_INT
					INNER JOIN	INFORMACOES_ACOMODACAO	AS IA ON A.ACO_INFO_ACOMOD_ID_INT	= IA.INFO_ACOMOD_ID_INT
					INNER JOIN	CATEGORIA_ACOMODACAO	AS CA ON CA.CAT_ACOMOD_ID_INT		= IA.INFO_ACOMOD_CAT_ACOMOD_ID_INT
					WHERE		A.ACO_EXCLUIDO_BIT = 0

				)

				SELECT * FROM STATUSDEUMAUNICAACOMODACAO WHERE ACO_ID_INT = @Id;

			END;

		END;
/*************************************************************************************************************************************
FIM: TIPO 2 - Selecionar uma única acomodações.
*************************************************************************************************************************************/

	END;
GO