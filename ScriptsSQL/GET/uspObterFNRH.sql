USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspObterFNRH]
	 @Id		int
	,@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para obter FNRHs (no momento, apenas na API).
Data.....: 26/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE	@IdHospede	int;
		DECLARE	@IdFNRH		int;

/*************************************************************************************************************************************
INÍCIO: Obter todas as FNRHs de um hóspede:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			SET @IdHospede = @Id;

			WITH

			[GetTipo1]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		 F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_ID_INT = @IdHospede

			)

			SELECT * FROM GetTipo1;

		END;
/*************************************************************************************************************************************
FIM: Obter todas as FNRHs de um hóspede.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
INÍCIO: Obter última FNRH por hóspede:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN

			SET @IdHospede = @Id;

			WITH

			[GetTipo2]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		TOP 1
				
							F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_ID_INT = @IdHospede
				ORDER BY	F.FNRH_ID_INT DESC

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
FIM: Obter última FNRH por hóspede.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Obter FNRH por id:
*************************************************************************************************************************************/
		IF @Tipo = 3
		BEGIN
			
			SET @IdFNRH = @Id;

			WITH

			[GetTipo3]

			(

				 FNRH_ID_INT
				,FNRH_PROFISSAO_STR
				,FNRH_NACIONALIDADE_STR
				,FNRH_SEXO_CHAR
				,FNRH_RG_CHAR
				,FNRH_PROXIMO_DESTINO_STR
				,FNRH_ULTIMO_DESTINO_STR
				,FNRH_MOTIVO_VIAGEM_STR
				,FNRH_MEIO_DE_TRANSPORTE_STR
				,FNRH_PLACA_AUTOMOVEL_STR
				,FNRH_NUM_ACOMPANHANTES_INT
				,FNRH_DATA_CADASTRO_DATETIME

			)

			AS

			(

				SELECT		F.FNRH_ID_INT
						
							,CASE
								WHEN (F.FNRH_PROFISSAO_STR IS NULL) OR (F.FNRH_PROFISSAO_STR = '')						THEN 'Não informado'
								ELSE F.FNRH_PROFISSAO_STR
							 END																						AS FNRH_PROFISSAO_STR

							,CASE
								WHEN (F.FNRH_NACIONALIDADE_STR IS NULL) OR (F.FNRH_NACIONALIDADE_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_NACIONALIDADE_STR
							 END																						AS FNRH_NACIONALIDADE_STR

							,CASE
								WHEN (F.FNRH_SEXO_CHAR IS NULL) OR (F.FNRH_SEXO_CHAR = '')								THEN 'Não informado'
								ELSE F.FNRH_SEXO_CHAR
							 END																						AS FNRH_SEXO_CHAR
							
							,CASE
								WHEN (F.FNRH_RG_CHAR IS NULL) OR (F.FNRH_RG_CHAR = '')									THEN 'Não informado'
								ELSE F.FNRH_RG_CHAR
							 END																						AS FNRH_RG_CHAR

							,CASE
								WHEN (F.FNRH_PROXIMO_DESTINO_STR IS NULL) OR (F.FNRH_PROXIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PROXIMO_DESTINO_STR
							 END																						AS FNRH_PROXIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_ULTIMO_DESTINO_STR IS NULL) OR (F.FNRH_ULTIMO_DESTINO_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_ULTIMO_DESTINO_STR
							 END																						AS FNRH_ULTIMO_DESTINO_STR

							,CASE
								WHEN (F.FNRH_MOTIVO_VIAGEM_STR IS NULL) OR (F.FNRH_MOTIVO_VIAGEM_STR = '')				THEN 'Não informado'
								ELSE F.FNRH_MOTIVO_VIAGEM_STR
							 END																						AS FNRH_MOTIVO_VIAGEM_STR

							,CASE
								WHEN (F.FNRH_MEIO_DE_TRANSPORTE_STR IS NULL) OR (F.FNRH_MEIO_DE_TRANSPORTE_STR = '')	THEN 'Não informado'
								ELSE F.FNRH_MEIO_DE_TRANSPORTE_STR
							 END																						AS FNRH_MEIO_DE_TRANSPORTE_STR

							,CASE
								WHEN (F.FNRH_PLACA_AUTOMOVEL_STR IS NULL) OR (F.FNRH_PLACA_AUTOMOVEL_STR = '')			THEN 'Não informado'
								ELSE F.FNRH_PLACA_AUTOMOVEL_STR
							 END																						AS FNRH_PLACA_AUTOMOVEL_STR

							,CASE
								WHEN (F.FNRH_NUM_ACOMPANHANTES_INT IS NULL) OR (F.FNRH_NUM_ACOMPANHANTES_INT = '')		THEN 'Não informado'
								ELSE F.FNRH_NUM_ACOMPANHANTES_INT
							 END																						AS FNRH_NUM_ACOMPANHANTES_INT
							
							,CAST(F.FNRH_DATA_CADASTRO_DATETIME AS DATE)												AS FNRH_DATA_CADASTRO_DATETIME
								

				FROM		FNRH	AS F
				INNER JOIN	HOSPEDE AS H ON F.FNRH_HSP_ID_INT = H.HSP_ID_INT
				WHERE		F.FNRH_EXCLUIDO_BIT = 0
				AND			H.HSP_EXCLUIDO_BIT	= 0
				AND			F.FNRH_ID_INT = @IdFNRH

			)

			SELECT * FROM GetTipo3;

		END;
/*************************************************************************************************************************************
FIM: Obter FNRH por id.
*************************************************************************************************************************************/

	END
GO