-----------------------------------
----- QUERIES PARA PROCEDURES -----
-----------------------------------

USE RECPAPAGAIOS
GO

-----------------------------------
--- PROCEDURES PARA ATUALIZAÇÃO ---
-----------------------------------

CREATE PROCEDURE AtualizarEndereco @Cep nchar(8), @Logradouro nvarchar(255), @Numero nchar(8), @Complemento nvarchar(255),  
@Bairro nvarchar(255), @Cidade nvarchar(255), @Estado nchar(2), @Pais nvarchar(255), @CpfHospede nchar(11)  
AS  
 UPDATE dbo.ENDERECO  
 SET  
  END_CEP_CHAR = @Cep,  
  END_LOGRADOURO_STR = @Logradouro,  
  END_NUMERO_CHAR = @Numero,  
  END_COMPLEMENTO_STR = @Complemento,  
  END_BAIRRO_STR = @Bairro,  
  END_CIDADE_STR = @Cidade,  
  END_ESTADO_CHAR = @Estado,  
  END_PAIS_STR = @Pais  
 WHERE (dbo.ENDERECO.END_CPF_HOSPEDE_STR = @CpfHospede) AND (dbo.ENDERECO.END_EXCLUIDO_BIT = 0)
GO

CREATE PROCEDURE AtualizarHospede @NomeCompleto nvarchar(255), @Cpf nvarchar(11), @DataDeNascimento Date, @Email nvarchar(50),  
@Login nvarchar(11), @Senha nvarchar(50), @Celular nvarchar(15)  
AS  
 UPDATE dbo.HOSPEDE  
 SET  
  HSP_NOME_STR = @NomeCompleto,  
  HSP_CPF_CHAR = @Cpf,  
  HSP_DTNASC_DATE = @DataDeNascimento,  
  HSP_EMAIL_STR = @Email,  
  HSP_LOGIN_CPF_CHAR = @Login,  
  HSP_LOGIN_SENHA_STR = @Senha,  
  HSP_CELULAR_STR = @Celular  
 WHERE (dbo.HOSPEDE.HSP_CPF_CHAR = @Cpf) AND (dbo.HOSPEDE.HSP_EXCLUIDO_BIT = 0)
GO

CREATE PROCEDURE AtualizarFNRH @IdFNRH int, @Profissao nvarchar(255), @Nacionalidade nvarchar(255), @Sexo nchar(1),
@Rg nchar(9), @ProximoDestino nvarchar(255), @UltimoDestino nvarchar(255), @MotivoViagem nvarchar(255),
@MeioDeTransporte nvarchar(255), @PlacaAutomovel nvarchar(255), @NumAcompanhantes int, @CpfHospede nchar(11)
AS
 UPDATE dbo.FNRH
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
 WHERE FNRH_ID_INT = @IdFNRH
GO


-----------------------------------
---- PROCEDURES PARA INSERÇÃO -----
-----------------------------------

CREATE PROCEDURE InserirEnderecos @Cep nchar(8), @Logradouro nvarchar(255), @Numero nchar(8), @Complemento nvarchar(255),  
@Bairro nvarchar(255), @Cidade nvarchar(255), @Estado nchar(2), @Pais nvarchar(255), @IdHospede int, @CpfHospede nchar(11),  
@Excluido bit  
AS  
 INSERT INTO dbo.ENDERECO  
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
  @CpfHospede,  
  @Excluido  
 )
GO

CREATE PROCEDURE InserirEndereco @Cep nchar(8), @Logradouro nvarchar(255), @Numero nchar(8), @Complemento nvarchar(255),  
@Bairro nvarchar(255), @Cidade nvarchar(255), @Estado nchar(2), @Pais nvarchar(255), @CpfHospede nchar(11),  
@Excluido bit  
AS  
 INSERT INTO dbo.ENDERECO  
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
  null,
  @CpfHospede,  
  @Excluido  
 )
GO

CREATE PROCEDURE InserirFNRH @Profissao nvarchar(255), @Nacionalidade nvarchar(50), @Sexo nchar(1),  
@Rg nchar(9), @ProximoDestino nvarchar(255), @UltimoDestino nvarchar(255), @MotivoViagem nvarchar(255),  
@MeioDeTransporte nvarchar(255), @PlacaAutomovel nvarchar(255), @NumAcompanhantes int, @HospedeId int,  
@CpfHospede nvarchar(11), @Excluido bit  
AS  
 INSERT INTO dbo.FNRH  
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
  @Excluido  
 )
GO

CREATE PROCEDURE InserirHospede @NomeCompleto nvarchar(255), @Cpf nvarchar(11), @DataDeNascimento Date, @Email nvarchar(50),  
@Login nvarchar(11), @Senha nvarchar(50), @Celular nvarchar(15), @Excluido bit  
AS  
 INSERT INTO dbo.HOSPEDE  
 VALUES  
 (  
  @NomeCompleto,  
  @Cpf,  
  @DataDeNascimento,  
  @Email,  
  @Login,  
  @Senha,  
  @Celular,  
  @Excluido  
 )  
GO

CREATE PROCEDURE InserirDadosBancarios
@Banco nvarchar(50),		@Agencia nvarchar(50), @NumeroDaConta nvarchar(50),
@CpfFuncionario nchar(11),	@Excluido bit
AS
 INSERT INTO dbo.DADOSBANCARIOS
 VALUES
 (
	@Banco,
	@Agencia,
	@NumeroDaConta,
	NULL,
	@CpfFuncionario,
	@Excluido
 )
GO

CREATE PROCEDURE InserirFuncionario
@NomeCompleto nvarchar(255),	@Cpf nchar(11),			@Nacionalidade nvarchar(50),	@DataDeNascimento date, 
@Sexo nchar(1),					@Rg nchar(9),			@Celular nchar(15),				@Cargo nvarchar(50),
@Setor nvarchar(50),			@Salario float(2),		@Email nvarchar(50),			@Login nvarchar(45),
@Senha nvarchar(45),			@IdCategoriaAcesso int,	@Excluido bit
AS
 INSERT INTO dbo.FUNCIONARIO
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
	@Excluido
 )
GO


-----------------------------------
---- PROCEDURES PARA OBTENÇÃO -----
-----------------------------------

CREATE PROCEDURE ObterEnderecos  
AS  
 SELECT * FROM ENDERECO  
 WHERE ENDERECO.END_EXCLUIDO_BIT = 0
GO

CREATE PROCEDURE ObterFNRHsPorHospede @cpfHospede nvarchar(11)    
AS      
 SELECT
  F.FNRH_ID_INT,    
  F.FNRH_PROFISSAO_STR,      
  F.FNRH_NACIONALIDADE_STR,      
  F.FNRH_SEXO_CHAR,      
  F.FNRH_RG_CHAR,      
  F.FNRH_PROXIMO_DESTINO_STR,      
  F.FNRH_ULTIMO_DESTINO_STR,      
  F.FNRH_MOTIVO_VIAGEM_STR,      
  F.FNRH_MEIO_DE_TRANSPORTE_STR,      
  F.FNRH_PLACA_AUTOMOVEL_STR,      
  F.FNRH_NUM_ACOMPANHANTES_INT,      
  F.FNRH_HSP_ID_INT,      
  F.FNRH_CPF_HOSPEDE_STR      
 FROM dbo.FNRH AS F
 INNER JOIN dbo.HOSPEDE AS H
 ON (H.HSP_CPF_CHAR = @cpfHospede) AND (F.FNRH_CPF_HOSPEDE_STR = @cpfHospede) AND (H.HSP_EXCLUIDO_BIT = 0)
 WHERE F.END_EXCLUIDO_BIT = 0
GO

CREATE PROCEDURE ObterHospede @cpfHospede nvarchar(11)  
AS  
 SELECT  
  -- Certos atributos da tabela de hóspede  
  H.HSP_ID_INT,  
  H.HSP_NOME_STR,  
  H.HSP_CPF_CHAR,  
  H.HSP_DTNASC_DATE,  
  H.HSP_EMAIL_STR,  
  H.HSP_LOGIN_CPF_CHAR,  
  H.HSP_LOGIN_SENHA_STR,  
  HSP_CELULAR_STR,  
   
  -- Certos atributos da tabela de endereço  
  E.END_CEP_CHAR,  
  E.END_LOGRADOURO_STR,  
  E.END_NUMERO_CHAR,  
  E.END_COMPLEMENTO_STR,  
  E.END_BAIRRO_STR,  
  E.END_CIDADE_STR,  
  E.END_ESTADO_CHAR,  
  E.END_PAIS_STR  
 FROM dbo.HOSPEDE AS H  
 INNER JOIN dbo.ENDERECO AS E  
 ON (H.HSP_CPF_CHAR = @cpfHospede) AND (E.END_CPF_HOSPEDE_STR = @cpfHospede) AND (H.HSP_EXCLUIDO_BIT = 0)
GO

CREATE PROCEDURE ObterHospedes  
AS  
 SELECT *
 FROM dbo.HOSPEDE AS H
 INNER JOIN dbo.ENDERECO AS E
 ON H.HSP_CPF_CHAR = E.END_CPF_HOSPEDE_STR
 WHERE H.HSP_EXCLUIDO_BIT = 0 AND E.END_EXCLUIDO_BIT = 0
GO

CREATE PROCEDURE ObterPorCpf @cpfHospede nvarchar(11)
AS
 SELECT
  H.HSP_ID_INT,
  H.HSP_NOME_STR,
  H.HSP_CPF_CHAR,
  H.HSP_DTNASC_DATE,
  H.HSP_EMAIL_STR,
  H.HSP_LOGIN_CPF_CHAR,
  H.HSP_LOGIN_SENHA_STR,
  H.HSP_CELULAR_STR,
  
  E.END_CEP_CHAR,
  E.END_LOGRADOURO_STR,
  E.END_NUMERO_CHAR,
  E.END_COMPLEMENTO_STR,
  E.END_BAIRRO_STR,
  E.END_CIDADE_STR,
  E.END_ESTADO_CHAR,
  E.END_PAIS_STR
 FROM dbo.HOSPEDE AS H, dbo.ENDERECO AS E
 WHERE (H.HSP_CPF_CHAR = @cpfHospede) AND (E.END_CPF_HOSPEDE_STR = @cpfHospede) AND (H.HSP_EXCLUIDO_BIT = 0)
GO

CREATE PROCEDURE ObterUltimaFNRHRegistroPorHospede @cpfHospede nvarchar(11)    
AS      
 SELECT      
  F.FNRH_ID_INT,    
  F.FNRH_PROFISSAO_STR,      
  F.FNRH_NACIONALIDADE_STR,      
  F.FNRH_SEXO_CHAR,      
  F.FNRH_RG_CHAR,      
  F.FNRH_PROXIMO_DESTINO_STR,      
  F.FNRH_ULTIMO_DESTINO_STR,      
  F.FNRH_MOTIVO_VIAGEM_STR,      
  F.FNRH_MEIO_DE_TRANSPORTE_STR,      
  F.FNRH_PLACA_AUTOMOVEL_STR,      
  F.FNRH_NUM_ACOMPANHANTES_INT,      
  F.FNRH_HSP_ID_INT,      
  F.FNRH_CPF_HOSPEDE_STR      
 FROM dbo.HOSPEDE AS H, dbo.FNRH AS F      
 WHERE (H.HSP_CPF_CHAR = @cpfHospede) AND (F.FNRH_CPF_HOSPEDE_STR = @cpfHospede) AND (H.HSP_EXCLUIDO_BIT = 0)  
 ORDER BY F.FNRH_ID_INT ASC
GO

CREATE PROCEDURE ObterUltimoHospede  
AS  
 SELECT TOP 1 * FROM dbo.HOSPEDE ORDER BY HSP_ID_INT DESC
GO

CREATE PROCEDURE ObterFNRHPorId @IdHospede int
AS
 SELECT * FROM dbo.FNRH
 WHERE FNRH_ID_INT = @IdHospede
 AND END_EXCLUIDO_BIT = 0
GO

CREATE PROCEDURE ObterFuncionarios
AS
 SELECT *
 FROM ENDERECO AS E, FUNCIONARIO AS F
 INNER JOIN DADOSBANCARIOS AS DB
 ON F.FUNC_CPF_CHAR = DB.DADOSBC_FUNCIONARIO_CPF_CHAR
 WHERE F.FUNC_CPF_CHAR = E.END_CPF_HOSPEDE_STR
	   AND F.FUNC_EXCLUIDO_BIT = 0 AND E.END_EXCLUIDO_BIT = 0
	   AND DB.DADOSBC_EXCLUIDO_BIT = 0
GO

CREATE PROCEDURE ObterFuncionario @CpfFuncionario nchar(11)
AS
 SELECT *
 FROM ENDERECO AS E, FUNCIONARIO AS F
 INNER JOIN DADOSBANCARIOS AS DB 
 ON DB.DADOSBC_FUNCIONARIO_CPF_CHAR = @CpfFuncionario AND F.FUNC_CPF_CHAR = @CpfFuncionario
 WHERE F.FUNC_CPF_CHAR = @CpfFuncionario AND E.END_CPF_HOSPEDE_STR = @CpfFuncionario
 	   AND F.FUNC_EXCLUIDO_BIT = 0 AND E.END_EXCLUIDO_BIT = 0 AND DB.DADOSBC_EXCLUIDO_BIT = 0
GO


-----------------------------------
----- PROCEDURES PARA REMOÇÃO -----
-----------------------------------

CREATE PROCEDURE RemoverEndereco @CpfHospede nchar(11)  
AS  
 UPDATE dbo.ENDERECO  
 SET dbo.ENDERECO.END_EXCLUIDO_BIT = 1  
 WHERE dbo.ENDERECO.END_CPF_HOSPEDE_STR = @CpfHospede
GO

CREATE PROCEDURE RemoverHospede @cpfHospede nvarchar(11)
AS  
 UPDATE dbo.HOSPEDE  
 SET dbo.HOSPEDE.HSP_EXCLUIDO_BIT = 1  
 WHERE dbo.HOSPEDE.HSP_CPF_CHAR = @cpfHospede
GO

CREATE PROCEDURE RemoverFNRH @IdFNRH int
AS
 UPDATE dbo.FNRH
 SET dbo.FNRH.END_EXCLUIDO_BIT = 1
 WHERE dbo.FNRH.FNRH_ID_INT = @IdFNRH AND
	   dbo.FNRH.END_EXCLUIDO_BIT = 0
GO