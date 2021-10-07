USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspRelatorioPerformanceFuncionarios]
	
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure que gera uma relatório de perfomance dos funcionários, pegando a quantidade total de check-ins e check-outs rea-
		   lizados por cada funcionário.
Data.....: 26/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

		WITH

		[TotalCheckIns]

		(

			 IdFuncionario
			,NomeFuncionario
			,TotalCheckIns

		)

		AS

		(

			SELECT		 FUNC_ID_INT
						,FUNC_NOME_STR
						,COUNT(CHECKIN_FUNC_ID_INT) AS 'Total de check-ins'
			FROM		CHECKIN		AS C
			INNER JOIN	FUNCIONARIO AS F ON C.CHECKIN_FUNC_ID_INT = F.FUNC_ID_INT
			GROUP BY	CHECKIN_FUNC_ID_INT, FUNC_ID_INT, FUNC_NOME_STR
		
		),

		[TotalCheckOuts]

		(

			 IdFuncionario
			,NomeFuncionario
			,TotalCheckOuts

		)

		AS

		(

			SELECT		 FUNC_ID_INT
						,FUNC_NOME_STR
						,COUNT(CHECKOUT_FUNC_ID_INT) AS 'Total de check-outs'
			FROM		CHECKOUT	AS C
			INNER JOIN	FUNCIONARIO AS F ON C.CHECKOUT_FUNC_ID_INT = F.FUNC_ID_INT
			GROUP BY	CHECKOUT_FUNC_ID_INT, FUNC_ID_INT, FUNC_NOME_STR

		),

		[DadosFuncionario]

		(
		
			 IdFuncionario
			,Cpf
			,Cargo
			,Setor
			,Excluido

		)

		AS

		(

			SELECT	 FUNC_ID_INT
					,FUNC_CPF_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_EXCLUIDO_BIT
			FROM	FUNCIONARIO

		)

		SELECT		 TCO.IdFuncionario		AS 'Funcionário Id'
					,TCO.NomeFuncionario	AS 'Nome do funcionário'
					,DF.Cpf					AS 'CPF do funcionário'
					,DF.Setor				AS 'Setor'
					,DF.Cargo				AS 'Cargo'
					,CASE
						WHEN DF.Excluido = 0 THEN 'Não'
						ELSE 'Sim'
					 END					AS 'Funcionário está excluído'
					,TCI.TotalCheckIns		AS 'Total de check-ins'
					,TCO.TotalCheckOuts		AS 'Total de check-outs'
		FROM		TotalCheckIns		AS TCI
		INNER JOIN	TotalCheckOuts		AS TCO	ON TCI.IdFuncionario = TCO.IdFuncionario
		INNER JOIN	DadosFuncionario	AS DF	ON TCI.IdFuncionario = DF.IdFuncionario;

	END;
GO
