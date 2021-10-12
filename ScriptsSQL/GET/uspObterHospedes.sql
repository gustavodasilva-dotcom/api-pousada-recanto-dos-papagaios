USE RECPAPAGAIOS
GO

ALTER PROCEDURE [dbo].[uspObterHospedes]
	@Pagina		int			= NULL,
	@Quantidade int			= NULL,
	@IdHospede	int			= NULL,
	@Cpf		char(11)	= NULL,
	@Tipo		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada obter todos os hóspedes.
Data.....: 21/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
INÍCIO: Obter lista de hóspedes, com base na quantidade e páginas providas pela query:
*************************************************************************************************************************************/
		IF @Tipo = 1
		BEGIN

			IF ((@Pagina IS NOT NULL) AND (@Quantidade IS NOT NULL) AND (@IdHospede IS NULL))
				BEGIN

					WITH

					[GetTipo1]

					(

						 HSP_ID_INT
						,HSP_NOME_STR
						,HSP_CPF_CHAR
						,HSP_DTNASC_DATE
						,USU_NOME_USUARIO_STR
						,CONT_EMAIL_STR
						,CONT_CELULAR_CHAR
						,CONT_TELEFONE_CHAR
						,END_CEP_CHAR
						,END_LOGRADOURO_STR
						,END_NUMERO_CHAR
						,END_COMPLEMENTO_STR	
						,END_CIDADE_STR
						,END_BAIRRO_STR
						,END_ESTADO_CHAR
						,END_PAIS_STR

					)

					AS

					(

						SELECT		 H.HSP_ID_INT
									,H.HSP_NOME_STR
									,H.HSP_CPF_CHAR
									,H.HSP_DTNASC_DATE

									,CASE
										WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
											THEN 'Sem nome de usuário'
										ELSE U.USU_NOME_USUARIO_STR
									 END AS USU_NOME_USUARIO_STR
									
									
									,C.CONT_EMAIL_STR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem celular'
										WHEN LEN(C.CONT_CELULAR_CHAR) = 13
											THEN '+'									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
									 END AS CONT_CELULAR_CHAR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
											THEN '+'									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
									 END AS CONT_TELEFONE_CHAR
							
									,E.END_CEP_CHAR
									,E.END_LOGRADOURO_STR
									,E.END_NUMERO_CHAR
							
									,CASE
										WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
											THEN 'Complemento não cadastrado'
										ELSE E.END_COMPLEMENTO_STR
									 END AS END_COMPLEMENTO_STR
							
									,E.END_CIDADE_STR
									,E.END_BAIRRO_STR
									,E.END_ESTADO_CHAR
									,E.END_PAIS_STR
						FROM		HOSPEDE		AS H
						LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
						INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
						INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
						WHERE		H.HSP_EXCLUIDO_BIT = 0
						ORDER BY	H.HSP_ID_INT OFFSET ((@Pagina - 1) * @Quantidade) ROWS FETCH NEXT @Quantidade ROWS ONLY

					)

					SELECT * FROM GetTipo1;

				END
			ELSE
				BEGIN
					
					WITH

					[GetTipo1]

					(

						 HSP_ID_INT
						,HSP_NOME_STR
						,HSP_CPF_CHAR
						,HSP_DTNASC_DATE
						,USU_NOME_USUARIO_STR
						,CONT_EMAIL_STR
						,CONT_CELULAR_CHAR
						,CONT_TELEFONE_CHAR
						,END_CEP_CHAR
						,END_LOGRADOURO_STR
						,END_NUMERO_CHAR
						,END_COMPLEMENTO_STR	
						,END_CIDADE_STR
						,END_BAIRRO_STR
						,END_ESTADO_CHAR
						,END_PAIS_STR

					)

					AS

					(

						SELECT		 H.HSP_ID_INT
									,H.HSP_NOME_STR
									,H.HSP_CPF_CHAR
									,H.HSP_DTNASC_DATE

									,CASE
										WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
											THEN 'Sem nome de usuário'
										ELSE U.USU_NOME_USUARIO_STR
									 END AS USU_NOME_USUARIO_STR
									
									,C.CONT_EMAIL_STR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_CELULAR_CHAR) = 13
											THEN '+'									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
									 END AS CONT_CELULAR_CHAR
							
									,CASE
										WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
											THEN 'Sem telefone'
										WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
											THEN '+'									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ' ('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
										ELSE	 '('									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
												 ') '									+
												 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
									 END AS CONT_TELEFONE_CHAR
							
									,E.END_CEP_CHAR
									,E.END_LOGRADOURO_STR
									,E.END_NUMERO_CHAR
							
									,CASE
										WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
											THEN 'Complemento não cadastrado'
										ELSE E.END_COMPLEMENTO_STR
									 END AS END_COMPLEMENTO_STR
							
									,E.END_CIDADE_STR
									,E.END_BAIRRO_STR
									,E.END_ESTADO_CHAR
									,E.END_PAIS_STR
						FROM		HOSPEDE		AS H
						LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
						INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
						INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
						WHERE		H.HSP_EXCLUIDO_BIT = 0
						AND			H.HSP_ID_INT = @IdHospede

					)

					SELECT * FROM GetTipo1;

				END;

		END;
/*************************************************************************************************************************************
FIM: Obter lista de hóspedes, com base na quantidade e páginas providas pela query.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Obter um hóspedes através do CPF:
*************************************************************************************************************************************/
		IF @Tipo = 2
		BEGIN
			
			WITH
			
			[GetTipo2]

			(

				 HSP_ID_INT
				,HSP_NOME_STR
				,HSP_CPF_CHAR
				,HSP_DTNASC_DATE
				,USU_NOME_USUARIO_STR
				,CONT_EMAIL_STR
				,CONT_CELULAR_CHAR
				,CONT_TELEFONE_CHAR
				,END_CEP_CHAR
				,END_LOGRADOURO_STR
				,END_NUMERO_CHAR
				,END_COMPLEMENTO_STR	
				,END_CIDADE_STR
				,END_BAIRRO_STR
				,END_ESTADO_CHAR
				,END_PAIS_STR

			)

			AS

			(

				SELECT		 H.HSP_ID_INT
							,H.HSP_NOME_STR
							,H.HSP_CPF_CHAR
							,H.HSP_DTNASC_DATE

							,CASE
								WHEN U.USU_NOME_USUARIO_STR IS NULL OR U.USU_NOME_USUARIO_STR = ''
									THEN 'Sem nome de usuário'
								ELSE U.USU_NOME_USUARIO_STR
							 END AS USU_NOME_USUARIO_STR
							
							,C.CONT_EMAIL_STR
							
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								WHEN LEN(C.CONT_CELULAR_CHAR) = 13
									THEN '+'									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
										 ' ('									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 5, 13)
								ELSE	 '('									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 1, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_CELULAR_CHAR, 3, 11)
							 END AS CONT_CELULAR_CHAR
							
							,CASE
								WHEN (C.CONT_TELEFONE_CHAR IS NULL OR C.CONT_TELEFONE_CHAR = '')
									THEN 'Sem telefone'
								WHEN LEN(C.CONT_TELEFONE_CHAR) > 10
									THEN '+'									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
										 ' ('									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 2)  +
										 ') '									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 5, 11)
								ELSE	 '('									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 1, 2)	+
										 ') '									+
										 SUBSTRING(C.CONT_TELEFONE_CHAR, 3, 11)
							 END AS CONT_TELEFONE_CHAR
							
							,E.END_CEP_CHAR
							,E.END_LOGRADOURO_STR
							,E.END_NUMERO_CHAR
							
							,CASE
								WHEN (E.END_COMPLEMENTO_STR IS NULL OR E.END_COMPLEMENTO_STR = '')
									THEN 'Complemento não cadastrado'
								ELSE E.END_COMPLEMENTO_STR
							 END AS END_COMPLEMENTO_STR
							
							,E.END_CIDADE_STR
							,E.END_BAIRRO_STR
							,E.END_ESTADO_CHAR
							,E.END_PAIS_STR
				FROM		HOSPEDE		AS H
				LEFT JOIN	USUARIO		AS U ON H.HSP_USU_ID_INT	= U.USU_ID_INT
				INNER JOIN	CONTATOS	AS C ON H.HSP_CONT_ID_INT	= C.CONT_ID_INT
				INNER JOIN	ENDERECO	AS E ON H.HSP_END_ID_INT	= E.END_ID_INT
				WHERE		H.HSP_EXCLUIDO_BIT = 0
				AND			H.HSP_CPF_CHAR = @Cpf

			)

			SELECT * FROM GetTipo2;

		END;
/*************************************************************************************************************************************
FIM: Obter um hóspedes através do CPF.
*************************************************************************************************************************************/

	END
GO