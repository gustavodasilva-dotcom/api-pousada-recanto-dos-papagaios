USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspObterFuncionarios]
	 @Cpf			nchar(11)	= NULL
	,@IdFuncionario	int			= NULL
	,@Pagina		int			= NULL
	,@Quantidade	int			= NULL
	,@Tipo			int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada obter todos os funcionários (até o momento, procedure utilizada na API).

Sumário..:
- Tipo 1: obtém todos os funcionários, caso as variáveis @Pagina e @Quantidade não forem nulas;
  Tipo 1: obtém um funcionário pelo id, caso as variáveis @Pagina e Quantidade sejam nulas, e @IdFuncionario não seja nulo;
- Tipo 2: obtém um funcionário através do CPF.

Data.....: 29/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
1 - INÍCIO -- Obter todos os funcionários:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

		IF ((@Pagina IS NOT NULL) AND (@Quantidade IS NOT NULL) AND (@IdFuncionario IS NULL))
			BEGIN

				WITH

				[GetTipo1]

				(

					 FUNC_ID_INT
					,FUNC_NOME_STR
					,FUNC_CPF_CHAR
					,FUNC_NACIONALIDADE_STR
					,FUNC_DTNASC_DATE
					,FUNC_SEXO_CHAR
					,FUNC_RG_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_SALARIO_FLOAT
					,USU_NOME_USUARIO_STR
					,CATACESSO_DESCRICAO_STR
					,CONT_EMAIL_STR
					,CONT_CELULAR_CHAR
					,CONT_TELEFONE_CHAR
					,END_CEP_CHAR
					,END_LOGRADOURO_STR
					,END_NUMERO_CHAR
					,END_COMPLEMENTO_STR
					,END_BAIRRO_STR
					,END_CIDADE_STR
					,END_ESTADO_CHAR
					,END_PAIS_STR
					,DADOSBC_BANCO_STR
					,DADOSBC_AGENCIA_STR
					,DADOSBC_NUMERO_CONTA_STR

				)

				AS

				(

					SELECT		 F.FUNC_ID_INT
								,F.FUNC_NOME_STR
								,F.FUNC_CPF_CHAR
								,F.FUNC_NACIONALIDADE_STR
								,F.FUNC_DTNASC_DATE
								,F.FUNC_SEXO_CHAR
								,F.FUNC_RG_CHAR
								,F.FUNC_CARGO_STR
								,F.FUNC_SETOR_STR
								,F.FUNC_SALARIO_FLOAT
								,U.USU_NOME_USUARIO_STR
								,CA.CATACESSO_DESCRICAO_STR
								,C.CONT_EMAIL_STR
					
								,CASE
									WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
										THEN 'Sem celular'
									ELSE TRIM(C.CONT_CELULAR_CHAR)
								 END AS CONT_CELULAR_CHAR
					
								,CASE
									WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
										THEN 'Sem telefone'
									ELSE TRIM(C.CONT_TELEFONE_CHAR)
								 END AS CONT_TELEFONE_CHAR
					
								,E.END_CEP_CHAR
								,E.END_LOGRADOURO_STR
								,E.END_NUMERO_CHAR
					
								,CASE
									WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
										THEN 'Complemento não cadastrado'
									ELSE E.END_COMPLEMENTO_STR
								 END AS END_COMPLEMENTO_STR
					
								,E.END_BAIRRO_STR
								,E.END_CIDADE_STR
								,E.END_ESTADO_CHAR
								,E.END_PAIS_STR

								,CASE
									WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
										THEN 'Banco não informado'
									ELSE DB.DADOSBC_BANCO_STR
								 END AS DADOSBC_BANCO_STR

								,CASE
									WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
										THEN 'Agência não informada'
									ELSE DB.DADOSBC_AGENCIA_STR
								 END AS DADOSBC_AGENCIA_STR

								,CASE
									WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
										THEN 'Número da conta não informado.'
									ELSE DB.DADOSBC_NUMERO_CONTA_STR
								 END AS DADOSBC_NUMERO_CONTA_STR

					FROM		FUNCIONARIO			AS F
					INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
					INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
					INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
					INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
					INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
					WHERE		F.FUNC_EXCLUIDO_BIT = 0
					ORDER BY	F.FUNC_ID_INT OFFSET ((@Pagina - 1) * @Quantidade) ROWS FETCH NEXT @Quantidade ROWS ONLY

				)

				SELECT * FROM GetTipo1;

			END;

		ELSE

			BEGIN

				WITH

				[GetTipo1]

				(

					 FUNC_ID_INT
					,FUNC_NOME_STR
					,FUNC_CPF_CHAR
					,FUNC_NACIONALIDADE_STR
					,FUNC_DTNASC_DATE
					,FUNC_SEXO_CHAR
					,FUNC_RG_CHAR
					,FUNC_CARGO_STR
					,FUNC_SETOR_STR
					,FUNC_SALARIO_FLOAT
					,USU_NOME_USUARIO_STR
					,CATACESSO_DESCRICAO_STR
					,CONT_EMAIL_STR
					,CONT_CELULAR_CHAR
					,CONT_TELEFONE_CHAR
					,END_CEP_CHAR
					,END_LOGRADOURO_STR
					,END_NUMERO_CHAR
					,END_COMPLEMENTO_STR
					,END_BAIRRO_STR
					,END_CIDADE_STR
					,END_ESTADO_CHAR
					,END_PAIS_STR
					,DADOSBC_BANCO_STR
					,DADOSBC_AGENCIA_STR
					,DADOSBC_NUMERO_CONTA_STR

				)

				AS

				(

				SELECT		 F.FUNC_ID_INT
							,F.FUNC_NOME_STR
							,F.FUNC_CPF_CHAR
							,F.FUNC_NACIONALIDADE_STR
							,F.FUNC_DTNASC_DATE
							,F.FUNC_SEXO_CHAR
							,F.FUNC_RG_CHAR
							,F.FUNC_CARGO_STR
							,F.FUNC_SETOR_STR
							,F.FUNC_SALARIO_FLOAT
							,U.USU_NOME_USUARIO_STR
							,CA.CATACESSO_DESCRICAO_STR
							,C.CONT_EMAIL_STR
				
							,CASE
								WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
									THEN 'Sem celular'
								ELSE TRIM(C.CONT_CELULAR_CHAR)
							 END AS CONT_CELULAR_CHAR
					
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								ELSE TRIM(C.CONT_TELEFONE_CHAR)
							 END AS CONT_TELEFONE_CHAR
				
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
				
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
				
							,E.END_BAIRRO_STR
							,E.END_CIDADE_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR

							,CASE
								WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
									THEN 'Banco não informado'
								ELSE DB.DADOSBC_BANCO_STR
							 END AS DADOSBC_BANCO_STR

							,CASE
								WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
									THEN 'Agência não informada'
								ELSE DB.DADOSBC_AGENCIA_STR
							 END AS DADOSBC_AGENCIA_STR

							,CASE
								WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
									THEN 'Número da conta não informado.'
								ELSE DB.DADOSBC_NUMERO_CONTA_STR
							 END AS DADOSBC_NUMERO_CONTA_STR

				FROM		FUNCIONARIO			AS F
				INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
				INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
				INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
				INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
				INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
				WHERE		F.FUNC_EXCLUIDO_BIT = 0
				AND			F.FUNC_ID_INT = @IdFuncionario

				)

				SELECT * FROM GetTipo1;

			END;

		END;
/*************************************************************************************************************************************
1 - FIM -- Obter todos os funcionários.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
2 - INÍCIO -- Obter funcionário por CPF:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN

			WITH

			[GetTipo2]

			(

				 FUNC_ID_INT
				,FUNC_NOME_STR
				,FUNC_CPF_CHAR
				,FUNC_NACIONALIDADE_STR
				,FUNC_DTNASC_DATE
				,FUNC_SEXO_CHAR
				,FUNC_RG_CHAR
				,FUNC_CARGO_STR
				,FUNC_SETOR_STR
				,FUNC_SALARIO_FLOAT
				,USU_NOME_USUARIO_STR
				,CATACESSO_DESCRICAO_STR
				,CONT_EMAIL_STR
				,CONT_CELULAR_CHAR
				,CONT_TELEFONE_CHAR
				,END_CEP_CHAR
				,END_LOGRADOURO_STR
				,END_NUMERO_CHAR
				,END_COMPLEMENTO_STR
				,END_BAIRRO_STR
				,END_CIDADE_STR
				,END_ESTADO_CHAR
				,END_PAIS_STR
				,DADOSBC_BANCO_STR
				,DADOSBC_AGENCIA_STR
				,DADOSBC_NUMERO_CONTA_STR

			)

			AS

			(

				SELECT		 F.FUNC_ID_INT
							,F.FUNC_NOME_STR
							,F.FUNC_CPF_CHAR
							,F.FUNC_NACIONALIDADE_STR
							,F.FUNC_DTNASC_DATE
							,F.FUNC_SEXO_CHAR
							,F.FUNC_RG_CHAR
							,F.FUNC_CARGO_STR
							,F.FUNC_SETOR_STR
							,F.FUNC_SALARIO_FLOAT
							,U.USU_NOME_USUARIO_STR
							,CA.CATACESSO_DESCRICAO_STR
							,C.CONT_EMAIL_STR
				
							,CASE
								WHEN (C.CONT_CELULAR_CHAR IS NULL OR C.CONT_CELULAR_CHAR = '')
									THEN 'Sem celular'
								ELSE TRIM(C.CONT_CELULAR_CHAR)
							 END AS CONT_CELULAR_CHAR
					
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								ELSE TRIM(C.CONT_TELEFONE_CHAR)
							 END AS CONT_TELEFONE_CHAR
				
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
				
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
				
							,E.END_BAIRRO_STR
							,E.END_CIDADE_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR

							,CASE
								WHEN (DB.DADOSBC_BANCO_STR IS NULL OR DB.DADOSBC_BANCO_STR = '')
									THEN 'Banco não informado'
								ELSE DB.DADOSBC_BANCO_STR
							 END AS DADOSBC_BANCO_STR

							,CASE
								WHEN (DB.DADOSBC_AGENCIA_STR IS NULL OR DB.DADOSBC_AGENCIA_STR = '')
									THEN 'Agência não informada'
								ELSE DB.DADOSBC_AGENCIA_STR
							 END AS DADOSBC_AGENCIA_STR

							,CASE
								WHEN (DB.DADOSBC_NUMERO_CONTA_STR IS NULL OR DB.DADOSBC_NUMERO_CONTA_STR = '')
									THEN 'Número da conta não informado.'
								ELSE DB.DADOSBC_NUMERO_CONTA_STR
							 END AS DADOSBC_NUMERO_CONTA_STR

				FROM		FUNCIONARIO			AS F
				INNER JOIN	USUARIO				AS U  ON F.FUNC_USU_ID_INT			= U.USU_ID_INT
				INNER JOIN	CONTATOS			AS C  ON F.FUNC_CONT_ID_INT			= C.CONT_ID_INT
				INNER JOIN	ENDERECO			AS E  ON F.FUNC_END_ID_INT			= E.END_ID_INT
				INNER JOIN	CATEGORIA_ACESSO	AS CA ON F.FUNC_CATACESSO_ID_INT	= CA.CATACESSO_ID_INT
				INNER JOIN	DADOSBANCARIOS		AS DB ON F.FUNC_ID_INT				= DB.DADOSBC_FUNC_ID_INT
				WHERE		F.FUNC_CPF_CHAR = @Cpf

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
2 - FIM -- Obter funcionário por CPF.
*************************************************************************************************************************************/

	END;
GO