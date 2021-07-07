----------------------------------------------------------------------------------------------------
------------------------------------- QUERIES PARA PROCEDURES --------------------------------------
----------------------------------------------------------------------------------------------------

USE RECPAPAGAIOS
GO

----------------------------------------------------------------------------------------------------
----------------------------------- PROCEDURES PARA ATUALIZA��O ------------------------------------
----------------------------------------------------------------------------------------------------

--DROP PROCEDURE AtualizarEnderecoFuncionario;
CREATE PROCEDURE AtualizarEnderecoFuncionario
	@Cep nchar(8),				 @Logradouro nvarchar(255),		@Numero nchar(8),
	@Complemento nvarchar(255),  @Bairro nvarchar(255),			@Cidade nvarchar(255),
	@Estado nchar(2),			 @Pais nvarchar(255),			@CpfHospede nchar(11)  
AS  
	UPDATE [RECPAPAGAIOS].[dbo].[ENDERECO_FUNCIONARIO]
	SET  
		END_FUNC_CEP_CHAR = @Cep,  
		END_FUNC_LOGRADOURO_STR = @Logradouro,  
		END_FUNC_NUMERO_CHAR = @Numero,  
		END_FUNC_COMPLEMENTO_STR = @Complemento,  
		END_FUNC_BAIRRO_STR = @Bairro,  
		END_FUNC_CIDADE_STR = @Cidade,  
		END_FUNC_ESTADO_CHAR = @Estado,  
		END_FUNC_PAIS_STR = @Pais  
	WHERE (END_FUNC_CPF_HOSPEDE_STR = @CpfHospede) AND (END_FUNC_EXCLUIDO_BIT = 0)
GO


--DROP PROCEDURE AtualizarEnderecoHospede;
CREATE PROCEDURE AtualizarEnderecoHospede
	@Cep nchar(8),				 @Logradouro nvarchar(255),		@Numero nchar(8),
	@Complemento nvarchar(255),  @Bairro nvarchar(255),			@Cidade nvarchar(255),
	@Estado nchar(2),			 @Pais nvarchar(255),			@CpfHospede nchar(11)  
AS  
	UPDATE [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE]
	SET  
		END_CEP_CHAR = @Cep,  
		END_LOGRADOURO_STR = @Logradouro,  
		END_NUMERO_CHAR = @Numero,  
		END_COMPLEMENTO_STR = @Complemento,  
		END_BAIRRO_STR = @Bairro,  
		END_CIDADE_STR = @Cidade,  
		END_ESTADO_CHAR = @Estado,  
		END_PAIS_STR = @Pais  
	WHERE (END_CPF_HOSPEDE_STR = @CpfHospede) AND (END_EXCLUIDO_BIT = 0)
GO


--DROP PROCEDURE AtualizarHospede;
CREATE PROCEDURE AtualizarHospede
	@NomeCompleto nvarchar(255),	@Cpf nvarchar(11),	 @DataDeNascimento Date,
	@Email nvarchar(50),			@Login nvarchar(11), @Senha nvarchar(50),
	@Celular nvarchar(15)  
AS  
 UPDATE [RECPAPAGAIOS].[dbo].[HOSPEDE]  
	SET  
		HSP_NOME_STR = @NomeCompleto,  
		HSP_CPF_CHAR = @Cpf,  
		HSP_DTNASC_DATE = @DataDeNascimento,  
		HSP_EMAIL_STR = @Email,  
		HSP_LOGIN_CPF_CHAR = @Login,  
		HSP_LOGIN_SENHA_STR = @Senha,  
		HSP_CELULAR_STR = @Celular  
	WHERE HSP_CPF_CHAR = @Cpf AND HSP_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE AtualizarFNRH;
CREATE PROCEDURE AtualizarFNRH
	@IdFNRH int,				   @Profissao nvarchar(255),		@Nacionalidade nvarchar(255),
	@Sexo nchar(1),				   @Rg nchar(9),					@ProximoDestino nvarchar(255),
	@UltimoDestino nvarchar(255),  @MotivoViagem nvarchar(255),		@MeioDeTransporte nvarchar(255),
	@PlacaAutomovel nvarchar(255), @NumAcompanhantes int,			@CpfHospede nchar(11)
AS
	UPDATE [RECPAPAGAIOS].[dbo].[FNRH]
	SET
		FNRH_PROFISSAO_STR = @Profissao,
		FNRH_NACIONALIDADE_STR = @Nacionalidade,
		FNRH_SEXO_CHAR = @Sexo,
		FNRH_RG_CHAR = @Rg,
		FNRH_PROXIMO_DESTINO_STR = @ProximoDestino,
		FNRH_ULTIMO_DESTINO_STR = @UltimoDestino,
		FNRH_MOTIVO_VIAGEM_STR = @MotivoViagem,
		FNRH_MEIO_DE_TRANSPORTE_STR = @MeioDeTransporte,
		FNRH_PLACA_AUTOMOVEL_STR = @PlacaAutomovel,
		FNRH_NUM_ACOMPANHANTES_INT = @NumAcompanhantes,
		FNRH_CPF_HOSPEDE_STR = @CpfHospede
	WHERE FNRH_ID_INT = @IdFNRH AND FNRH_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE AtualizarDadosBancarios;
CREATE PROCEDURE AtualizarDadosBancarios
	@Banco nvarchar(50),	@Agencia nvarchar(50),		@NumeroDaConta nvarchar(50),
	@CpfFuncionario nchar(11)
AS
	UPDATE [RECPAPAGAIOS].[dbo].[DADOSBANCARIOS]
	SET
		DADOSBC_BANCO_STR = @Banco,
		DADOSBC_AGENCIA_STR = @Agencia,
		DADOSBC_NUMERO_CONTA_STR = @NumeroDaConta,
		DADOSBC_FUNCIONARIO_CPF_CHAR = @CpfFuncionario
	WHERE DADOSBC_FUNCIONARIO_CPF_CHAR = @CpfFuncionario AND DADOSBC_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE AtualizarFuncionario;
CREATE PROCEDURE AtualizarFuncionario
	@NomeCompleto nvarchar(255),	@Cpf nchar(11),		 @DataDeNascimento date,		@Email nvarchar(50),
	@Login nvarchar(45),			@Senha nvarchar(45), @Celular nchar(15),			@Nacionalidade nvarchar(50),
	@Sexo nchar(1),					@Rg nchar(9),		 @Cargo nvarchar(50),			@Setor nvarchar(50),
	@Salario float(2),				@Catacesso int
AS
	UPDATE [RECPAPAGAIOS].[dbo].[FUNCIONARIO]
	SET
		FUNC_NOME_STR = @NomeCompleto,
		FUNC_CPF_CHAR = @Cpf,
		FUNC_DTNASC_DATE = @DataDeNascimento,
		FUNC_EMAIL_STR = @Email,
		FUNC_NOME_USUARIO_STR = @Login,
		FUNC_SENHA_USUARIO_STR = @Senha,
		FUNC_CELULAR_CHAR = @Celular,
		FUNC_NACIONALIDADE_STR = @Nacionalidade,
		FUNC_SEXO_CHAR = @Sexo,
		FUNC_RG_CHAR = @Rg,
		FUNC_CARGO_STR = @Cargo,
		FUNC_SETOR_STR = @Setor,
		FUNC_SALARIO_FLOAT = @Salario,
		FUNC_CATACESSO_ID_INT = @Catacesso
	WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE IF EXITS AtualizarReserva;
CREATE PROCEDURE AtualizarReserva
	@IdReserva int,			@DataCheckIn date,		@DataCheckOut date,
	@CpfHospede nchar(11),	@AcomodacaoId int,		@PagamentoId int,
	@Acompanhantes int
AS
	DECLARE
		@InfoAcomodacao int, @PrecoAcomodacao float(2),
		@IdHospede		int

	SELECT @InfoAcomodacao = ACO_INFO_ACOMOD_ID_INT
	FROM   [RECPAPAGAIOS].[dbo].[ACOMODACAO]
	WHERE  ACO_ID_INT = @AcomodacaoId;

	SELECT @PrecoAcomodacao = INFO_ACOMOD_PRECO_FLOAT
	FROM   [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO]
	WHERE  INFO_ACOMOD_ID_INT = @InfoAcomodacao;

	SELECT @IdHospede = HSP_ID_INT
	FROM   [RECPAPAGAIOS].[dbo].[HOSPEDE]
	WHERE  HSP_CPF_CHAR = @CpfHospede;

	UPDATE [RECPAPAGAIOS].[dbo].[RESERVA]
	SET
		RES_DATA_CHECKIN_DATE = @DataCheckIn,
		RES_DATA_CHECKOUT_DATE = @DataCheckOut,
		RES_VALOR_RESERVA_FLOAT = (@PrecoAcomodacao * DATEDIFF(DAY, @DataCheckIn, @DataCheckOut)) * (@Acompanhantes + (10/100)),
		RES_HSP_ID_INT = @IdHospede,
		RES_ACO_ID_INT = @AcomodacaoId,
		RES_PGTO_ID_INT = @PagamentoId,
		RES_ACOMPANHANTES_ID_INT = @Acompanhantes
	WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0 AND RES_STATUS_RESERVA_INT = 1 -- Reserva pode ser atualiza APENAS quando "Iniciada".
GO


---------------------------------------------------------------------------------------------------------
--------------------------------------- PROCEDURES PARA INSER��O ----------------------------------------
---------------------------------------------------------------------------------------------------------

--DROP PROCEDURE InserirEnderecoHospede;
CREATE PROCEDURE InserirEnderecoHospede
	@Cep nchar(8),					@Logradouro nvarchar(255),		@Numero nvarchar(8),
	@Complemento nvarchar(255),		@Bairro nvarchar(255),			@Cidade nvarchar(255),
	@Estado nchar(2),				@Pais nvarchar(255),			@CpfFuncionario nchar(11)
AS
	DECLARE
		@IdHospede INT

	SELECT TOP 1 @IdHospede = HSP_ID_INT FROM dbo.[HOSPEDE] ORDER BY HSP_ID_INT DESC;

	INSERT INTO [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE]
	VALUES  
	(  
		@Cep,  
		@Logradouro,
		@Numero,  
		@Complemento,  
		@Bairro,  
		@Cidade,  
		@Estado,  
		@Pais,  
		@IdHospede,  
		@CpfFuncionario,  
		0 -- Configurando exclu�do como 0 (falso)
	)
GO


--DROP PROCEDURE InserirEnderecoFuncionario;
CREATE PROCEDURE InserirEnderecoFuncionario
	@Cep nchar(8),					@Logradouro nvarchar(255),		@Numero nvarchar(8),
	@Complemento nvarchar(255),		@Bairro nvarchar(255),			@Cidade nvarchar(255),
	@Estado nchar(2),				@Pais nvarchar(255),			@CpfFuncionario nchar(11)
AS
	DECLARE
		@IdFuncionario INT

	SELECT TOP 1 @IdFuncionario = FUNC_ID_INT FROM dbo.[FUNCIONARIO] ORDER BY FUNC_ID_INT DESC;

	INSERT INTO [RECPAPAGAIOS].[dbo].[ENDERECO_FUNCIONARIO]
	VALUES  
	(
		@Cep,  
		@Logradouro,
		@Numero,  
		@Complemento,  
		@Bairro,  
		@Cidade,  
		@Estado,  
		@Pais,  
		@IdFuncionario,  
		@CpfFuncionario,  
		0 -- Configurando exclu�do como 0 (falso)
	)
GO


--DROP PROCEDURE InserirFNRH;
CREATE PROCEDURE InserirFNRH
	@Profissao nvarchar(255),		@Nacionalidade nvarchar(50),		@Sexo nchar(1),  
	@Rg nchar(9),					@ProximoDestino nvarchar(255),		@UltimoDestino nvarchar(255),
	@MotivoViagem nvarchar(255),	@MeioDeTransporte nvarchar(255),	@PlacaAutomovel nvarchar(255),
	@NumAcompanhantes int,			@CpfHospede nvarchar(11)
AS  
	DECLARE
		@HospedeId INT

		SELECT @HospedeId = HSP_ID_INT FROM [HOSPEDE] WHERE HSP_CPF_CHAR = @CpfHospede;

	INSERT INTO [RECPAPAGAIOS].[dbo].[FNRH]
	VALUES  
	(  
		@Profissao,  
		@Nacionalidade,  
		@Sexo,  
		@Rg,  
		@ProximoDestino,  
		@UltimoDestino,  
		@MotivoViagem,  
		@MeioDeTransporte,  
		@PlacaAutomovel,  
		@NumAcompanhantes,  
		@HospedeId,  
		@CpfHospede,  
		0 -- Configurando exclu�do como 0 (falso)
	)
GO


--DROP PROCEDURE InserirHospede;
CREATE PROCEDURE InserirHospede
	@NomeCompleto nvarchar(255),		@Cpf nvarchar(11),		@DataDeNascimento Date,
	@Email nvarchar(50),				@Login nvarchar(11),	@Senha nvarchar(50),
	@Celular nvarchar(13)
AS  
	INSERT INTO [RECPAPAGAIOS].[dbo].[HOSPEDE]  
	VALUES  
	(  
		@NomeCompleto,  
		@Cpf,  
		@DataDeNascimento,  
		@Email,  
		@Login,  
		@Senha,  
		@Celular,  
		0 -- Configurando exclu�do como 0 (falso)
	)  
GO


--DROP PROCEDURE InserirDadosBancarios;
CREATE PROCEDURE InserirDadosBancarios
	@Banco nvarchar(50),		@Agencia nvarchar(50), @NumeroDaConta nvarchar(50),
	@CpfFuncionario nchar(11)
AS
	DECLARE
		@IdFuncionario INT

	SELECT TOP 1 @IdFuncionario = FUNC_ID_INT FROM dbo.[FUNCIONARIO] ORDER BY FUNC_ID_INT DESC;
	
	INSERT INTO [RECPAPAGAIOS].[dbo].[DADOSBANCARIOS]
	VALUES
	(
		@Banco,
		@Agencia,
		@NumeroDaConta,
		@IdFuncionario,
		@CpfFuncionario,
		0 -- Configurando exclu�do como 0 (falso)
	)
GO


--DROP PROCEDURE InserirFuncionario;
CREATE PROCEDURE InserirFuncionario
	@NomeCompleto nvarchar(255),	@Cpf nchar(11),			@Nacionalidade nvarchar(50),	@DataDeNascimento date, 
	@Sexo nchar(1),					@Rg nchar(9),			@Celular nchar(13),				@Cargo nvarchar(50),
	@Setor nvarchar(50),			@Salario float(2),		@Email nvarchar(50),			@Login nvarchar(45),
	@Senha nvarchar(45),			@IdCategoriaAcesso int
AS
	INSERT INTO [RECPAPAGAIOS].[dbo].[FUNCIONARIO]
	VALUES
	(
		@NomeCompleto,
		@Cpf,
		@Nacionalidade,
		@DataDeNascimento,
		@Sexo,
		@Rg,
		@Celular,
		@Cargo,
		@Setor,
		@Salario,
		@Email,
		@Login,
		@Senha,
		@IdCategoriaAcesso,
		0 -- Configurando exclu�do como 0 (falso)
	)
GO


--DROP PROCEDURE InserirAcomodacao;
CREATE PROCEDURE InserirAcomodacao
	@NomeAcomodacao nvarchar(255),		@StatusAcomodacao int,		@InformacoesAcomodacao int
AS
	INSERT INTO [RECPAPAGAIOS].[dbo].[ACOMODACAO]
	VALUES
	(
		@NomeAcomodacao,
		@StatusAcomodacao,
		@InformacoesAcomodacao,
		0
	)
GO


--DROP PROCEDURE IF EXISTS InserirReserva;
CREATE PROCEDURE InserirReserva
	@DataCheckIn date,		@DataCheckOut date,		@CpfHospede nchar(11),
	@Acomodacao int,		@Pagamento int,			@Acompanhantes int
AS
	BEGIN
		DECLARE
		@InfoAcomodacao int,
		@PrecoAcomodacao float(2),
		@IdHospede int

		-- Selecionando o ID -- a chave estrangeira -- que liga uma acomoda��o �s suas informa��es.
		SELECT @InfoAcomodacao = ACO_INFO_ACOMOD_ID_INT FROM ACOMODACAO WHERE ACO_ID_INT = @Acomodacao;

		-- Selecionando o pre�o da acomoda��o escolhida na tabela de INFORMACOES_ACOMODACAO, baseado no ID coletado anteriormente.
		SELECT @PrecoAcomodacao = INFO_ACOMOD_PRECO_FLOAT FROM INFORMACOES_ACOMODACAO WHERE INFO_ACOMOD_ID_INT = @InfoAcomodacao;

		-- Selecionando o h�spede (titular) da reserva na tabela de HOSPEDE.
		SELECT @IdHospede = HSP_ID_INT FROM HOSPEDE WHERE HSP_CPF_CHAR = @CpfHospede;

		INSERT INTO [RECPAPAGAIOS].[dbo].[RESERVA]
		VALUES
		(
			GETDATE(), -- RES_DATA_RESERVA_DATE
			@DataCheckIn, -- RES_DATA_CHECKIN_DATE
			@DataCheckOut, -- RES_DATA_CHECKOUT_DATE
			(@PrecoAcomodacao * DATEDIFF(DAY, @DataCheckIn, @DataCheckOut)) * (@Acompanhantes + (10/100)), -- Calculando a quantidade de dias.
			1, -- RES_STATUS_RESERVA_INT
			@IdHospede, -- RES_HSP_ID_INT
			@Acomodacao, -- RES_ACO_ID_INT
			@Pagamento, -- RES_PGTO_ID_INT
			@Acompanhantes, -- RES_ACOMPANHANTES_ID_INT
			0 -- RES_EXCLUIDO_BIT
		);
	END
GO


---------------------------------------------------------------------------------------------------------
--------------------------------------- PROCEDURES PARA OBTEN��O ----------------------------------------
---------------------------------------------------------------------------------------------------------

--DROP PROCEDURE ObterEnderecos;
CREATE PROCEDURE ObterEnderecos  
AS  
	SELECT * FROM [RECPAPAGAIOS].[dbo].[ENDERECO]  
	WHERE ENDERECO.END_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterFNRHsPorHospede;
CREATE PROCEDURE ObterFNRHsPorHospede
	@cpfHospede nvarchar(11)    
AS      
	SELECT *
	FROM  [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H, [RECPAPAGAIOS].[dbo].[FNRH] AS F
	WHERE (H.HSP_CPF_CHAR = @cpfHospede)
	  AND (F.FNRH_CPF_HOSPEDE_STR = @cpfHospede) AND (F.FNRH_EXCLUIDO_BIT = 0) AND (H.HSP_EXCLUIDO_BIT = 0)
GO


--DROP PROCEDURE ObterHospede;
CREATE PROCEDURE ObterHospede
	@cpfHospede nvarchar(11)  
AS  
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H WITH (NOLOCK)
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS E ON H.HSP_ID_INT = E.END_ID_HOSPEDE_INT
	WHERE H.HSP_CPF_CHAR = @cpfHospede AND E.END_CPF_HOSPEDE_STR = @cpfHospede
	  AND H.HSP_EXCLUIDO_BIT = 0 AND E.END_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterHospedes;
CREATE PROCEDURE ObterHospedes  
AS  
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H WITH (NOLOCK)
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS E ON H.HSP_ID_INT = E.END_ID_HOSPEDE_INT
	WHERE H.HSP_EXCLUIDO_BIT = 0 AND E.END_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterPorCpf;
CREATE PROCEDURE ObterPorCpf
	@cpfHospede nvarchar(11)
AS
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H, [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS E
	WHERE (H.HSP_CPF_CHAR = @cpfHospede) AND (E.END_CPF_HOSPEDE_STR = @cpfHospede)
	  AND (H.HSP_EXCLUIDO_BIT = 0) AND (E.END_EXCLUIDO_BIT = 0)
GO


--DROP PROCEDURE ObterUltimaFNRHRegistroPorHospede;
CREATE PROCEDURE ObterUltimaFNRHRegistroPorHospede
	@cpfHospede nvarchar(11)    
AS      
	SELECT *    
	FROM [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H, [RECPAPAGAIOS].[dbo].[FNRH] AS F      
	WHERE (H.HSP_CPF_CHAR = @cpfHospede) AND (F.FNRH_CPF_HOSPEDE_STR = @cpfHospede)
	  AND (H.HSP_EXCLUIDO_BIT = 0) AND (F.FNRH_EXCLUIDO_BIT = 0)
	ORDER BY F.FNRH_ID_INT ASC
GO


--DROP PROCEDURE ObterUltimoHospede;
CREATE PROCEDURE ObterUltimoHospede  
AS  
	SELECT TOP 1 * FROM [RECPAPAGAIOS].[dbo].[HOSPEDE]
	ORDER BY HSP_ID_INT DESC
GO


--DROP PROCEDURE ObterFNRHPorId;
CREATE PROCEDURE ObterFNRHPorId
	@IdFNRH int
AS
	SELECT * FROM [RECPAPAGAIOS].[dbo].[FNRH]
	WHERE FNRH_ID_INT = @IdFNRH AND FNRH_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterFuncionarios;
CREATE PROCEDURE ObterFuncionarios
AS
	SELECT *
	FROM FUNCIONARIO AS F
	INNER JOIN ENDERECO_FUNCIONARIO AS EF ON F.FUNC_ID_INT = EF.END_FUNC_ID_FUNCIONARIO_INT
	INNER JOIN DADOSBANCARIOS AS DB ON F.FUNC_ID_INT = DB.DADOSBC_FUNCIONARIO_ID_INT
	WHERE F.FUNC_EXCLUIDO_BIT = 0
	  AND EF.END_FUNC_EXCLUIDO_BIT = 0
	  AND DB.DADOSBC_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterFuncionario;
CREATE PROCEDURE ObterFuncionario
	@CpfFuncionario nchar(11)
AS
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[FUNCIONARIO] AS F
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_FUNCIONARIO] AS EF ON F.FUNC_ID_INT = EF.END_FUNC_ID_FUNCIONARIO_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[DADOSBANCARIOS] AS DB ON F.FUNC_ID_INT = DB.DADOSBC_FUNCIONARIO_ID_INT
	WHERE F.FUNC_CPF_CHAR = @CpfFuncionario
	  AND EF.END_FUNC_CPF_HOSPEDE_STR = @CpfFuncionario
	  AND DB.DADOSBC_FUNCIONARIO_CPF_CHAR = @CpfFuncionario
	  AND F.FUNC_EXCLUIDO_BIT = 0
	  AND EF.END_FUNC_EXCLUIDO_BIT = 0
	  AND DB.DADOSBC_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterAcomodacoes;
CREATE PROCEDURE ObterAcomodacoes
AS
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS S ON A.ACO_ST_ACOMOD_INT = S.ST_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON A.ACO_INFO_ACOMOD_ID_INT = I.INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS C ON C.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT
	WHERE A.ACO_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterAcomodacao
CREATE PROCEDURE ObterAcomodacao
	@idAcomodacao int
AS
	SELECT *
	FROM [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS S ON A.ACO_ST_ACOMOD_INT = S.ST_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON A.ACO_INFO_ACOMOD_ID_INT = I.INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS C ON C.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT
	WHERE A.ACO_ID_INT = @idAcomodacao AND A.ACO_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE ObterUltimaAcomodacao
CREATE PROCEDURE ObterUltimaAcomodacao
AS
	SELECT TOP 1 *
	FROM [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS S ON A.ACO_ST_ACOMOD_INT = S.ST_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON A.ACO_INFO_ACOMOD_ID_INT = I.INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS C ON C.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT
	WHERE A.ACO_EXCLUIDO_BIT = 0
	ORDER BY A.ACO_ID_INT DESC
GO


--DROP PROCEDURE IF EXISTIS ObterReservas
CREATE PROCEDURE ObterReservas
	@Pagina int,	@Quantidade int
AS
	SELECT *
	-- Todas as informa��es da reserva
	FROM [RECPAPAGAIOS].[dbo].[RESERVA] AS R
	INNER JOIN [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A ON A.ACO_ID_INT = R.RES_ACO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON I.INFO_ACOMOD_ID_INT = A.ACO_INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[PAGAMENTO] AS P ON P.PGTO_ID_INT = R.RES_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[TIPO_PAGAMENTO] AS TP ON TP.TPPGTO_ID_INT = P.PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_PAGAMENTO] AS SP ON SP.ST_PGTO_ID_INT = P.PGTO_ST_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_RESERVA] AS SR ON SR.ST_RES_ID_INT = R.RES_STATUS_RESERVA_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS SA ON SA.ST_ACOMOD_ID_INT = A.ACO_ST_ACOMOD_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS CA ON CA.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT

	-- Obtendo informa��es do h�spede
	INNER JOIN [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H ON H.HSP_ID_INT = R.RES_HSP_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS EH ON EH.END_ID_HOSPEDE_INT = H.HSP_ID_INT
	WHERE RES_EXCLUIDO_BIT = 0
	ORDER BY R.RES_ID_INT OFFSET ((@Pagina - 1) * @Quantidade) ROWS FETCH NEXT @Quantidade ROWS ONLY
GO


--DROP PROCEDURE IF EXISTS ObterReserva;
CREATE PROCEDURE ObterReserva
	@IdReserva int
AS
	SELECT *
	-- Todas as informa��es da reserva
	FROM [RECPAPAGAIOS].[dbo].[RESERVA] AS R
	INNER JOIN [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A ON A.ACO_ID_INT = R.RES_ACO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON I.INFO_ACOMOD_ID_INT = A.ACO_INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[PAGAMENTO] AS P ON P.PGTO_ID_INT = R.RES_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[TIPO_PAGAMENTO] AS TP ON TP.TPPGTO_ID_INT = P.PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_PAGAMENTO] AS SP ON SP.ST_PGTO_ID_INT = P.PGTO_ST_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_RESERVA] AS SR ON SR.ST_RES_ID_INT = R.RES_STATUS_RESERVA_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS SA ON SA.ST_ACOMOD_ID_INT = A.ACO_ST_ACOMOD_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS CA ON CA.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT

	-- Obtendo informa��es do h�spede
	INNER JOIN [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H ON H.HSP_ID_INT = R.RES_HSP_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS EH ON EH.END_ID_HOSPEDE_INT = H.HSP_ID_INT
	WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE IF EXISTS ObterUltimaReserva
CREATE PROCEDURE ObterUltimaReserva
AS
	SELECT TOP 1 *
	-- Todas as informa��es da reserva
	FROM [RECPAPAGAIOS].[dbo].[RESERVA] AS R
	INNER JOIN [RECPAPAGAIOS].[dbo].[ACOMODACAO] AS A ON A.ACO_ID_INT = R.RES_ACO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[INFORMACOES_ACOMODACAO] AS I ON I.INFO_ACOMOD_ID_INT = A.ACO_INFO_ACOMOD_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[PAGAMENTO] AS P ON P.PGTO_ID_INT = R.RES_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[TIPO_PAGAMENTO] AS TP ON TP.TPPGTO_ID_INT = P.PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_PAGAMENTO] AS SP ON SP.ST_PGTO_ID_INT = P.PGTO_ST_PGTO_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_RESERVA] AS SR ON SR.ST_RES_ID_INT = R.RES_STATUS_RESERVA_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[STATUS_ACOMODACAO] AS SA ON SA.ST_ACOMOD_ID_INT = A.ACO_ST_ACOMOD_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[CATEGORIA_ACOMODACAO] AS CA ON CA.CAT_ACOMOD_ID_INT = I.INFO_ACOMOD_CAT_ACOMOD_ID_INT

	-- Obtendo informa��es do h�spede
	INNER JOIN [RECPAPAGAIOS].[dbo].[HOSPEDE] AS H ON H.HSP_ID_INT = R.RES_HSP_ID_INT
	INNER JOIN [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE] AS EH ON EH.END_ID_HOSPEDE_INT = H.HSP_ID_INT
	WHERE RES_EXCLUIDO_BIT = 0
	ORDER BY R.RES_ACO_ID_INT DESC
GO


---------------------------------------------------------------------------------------------------------
---------------------------------------- PROCEDURES PARA REMO��O ----------------------------------------
---------------------------------------------------------------------------------------------------------

--DROP PROCEDURE RemoverEnderecoHospede;
CREATE PROCEDURE RemoverEnderecoHospede
	@CpfHospede nchar(11)  
AS  
	UPDATE [RECPAPAGAIOS].[dbo].[ENDERECO_HOSPEDE]
	SET
		dbo.ENDERECO_HOSPEDE.END_EXCLUIDO_BIT = 1  
	WHERE dbo.ENDERECO_HOSPEDE.END_CPF_HOSPEDE_STR = @CpfHospede
GO


--DROP PROCEDURE RemoverEnderecoFuncionario;
CREATE PROCEDURE RemoverEnderecoFuncionario
	@CpfHospede nchar(11)  
AS  
	UPDATE [RECPAPAGAIOS].[dbo].[ENDERECO_FUNCIONARIO]
	SET
		dbo.ENDERECO_FUNCIONARIO.END_FUNC_EXCLUIDO_BIT = 1  
	WHERE dbo.ENDERECO_FUNCIONARIO.END_FUNC_CPF_HOSPEDE_STR = @CpfHospede
GO


--DROP PROCEDURE RemoverHospede;
CREATE PROCEDURE RemoverHospede
	@cpfHospede nvarchar(11)
AS  
	UPDATE [RECPAPAGAIOS].[dbo].[HOSPEDE]  
	SET
		dbo.HOSPEDE.HSP_EXCLUIDO_BIT = 1  
	WHERE dbo.HOSPEDE.HSP_CPF_CHAR = @cpfHospede
GO


--DROP PROCEDURE RemoverFNRH;
CREATE PROCEDURE RemoverFNRH
	@IdFNRH int
AS
	UPDATE [RECPAPAGAIOS].[dbo].[FNRH]
	SET
		FNRH_EXCLUIDO_BIT = 1
	WHERE FNRH_ID_INT = @IdFNRH AND FNRH_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE RemoverAcomodacao;
CREATE PROCEDURE RemoverAcomodacao
	@idAcomodacao int
AS
	UPDATE [RECPAPAGAIOS].[dbo].[ACOMODACAO]
	SET
		ACO_EXCLUIDO_BIT = 1
	WHERE ACO_ID_INT = @idAcomodacao AND ACO_EXCLUIDO_BIT = 0
GO


--DROP PROCEDURE IF EXISTS RemoverReserva;
CREATE PROCEDURE RemoverReserva
	@IdReserva int
AS
	UPDATE [RECPAPAGAIOS].[dbo].[RESERVA]
	SET
		RES_EXCLUIDO_BIT = 1
	WHERE RES_ID_INT = @IdReserva AND RES_EXCLUIDO_BIT = 0
GO