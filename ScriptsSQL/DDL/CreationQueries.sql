-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- CRIAÇÃO DO BANCO DE DADOS ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

DROP DATABASE IF EXISTS RECPAPAGAIOS
CREATE DATABASE RECPAPAGAIOS;
GO

-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- CRIAÇÃO DAS TABELAS ------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

USE RECPAPAGAIOS;
GO



/****************************************************************************************************************************************
Tabela que armazena as informações de endereço dos hóspedes e dos funcionários.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ENDERECO;
CREATE TABLE ENDERECO
(
	END_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	END_CEP_CHAR				CHAR(8),
	END_LOGRADOURO_STR			VARCHAR(255),
	END_NUMERO_CHAR				VARCHAR(8),
	END_COMPLEMENTO_STR			VARCHAR(255),
	END_CIDADE_STR				VARCHAR(255),
	END_BAIRRO_STR				VARCHAR(255),
	END_ESTADO_CHAR				CHAR(2),
	END_PAIS_STR				VARCHAR(255),
	END_EXCLUIDO_BIT			BIT				NOT NULL,
	END_DATA_CADASTRO_DATETIME 	DATETIME		NOT NULL

	-- PRIMARY KEY
	CONSTRAINT PK_END_ID_ENDERECO_INT PRIMARY KEY(END_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de acesso dos funcionários da pousada ao sistema.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CATEGORIA_ACESSO;
CREATE TABLE CATEGORIA_ACESSO
(
	CATACESSO_ID_INT					INT			NOT NULL IDENTITY(1, 1),
	CATACESSO_DESCRICAO_STR				VARCHAR(50) NOT NULL CHECK
	(
		CATACESSO_DESCRICAO_STR IN
		(
			'Recepcao',			-- 1
			'Administrativo'	-- 2
		)
	),
	CATACESSO_EXCLUIDO_BIT				BIT			NOT NULL,
	CATACESSO_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	-- PK
	CONSTRAINT PK_CATACESSO_ID_INT PRIMARY KEY(CATACESSO_ID_INT)
);

INSERT INTO CATEGORIA_ACESSO VALUES ('Recepcao'			, 0, GETDATE()); -- 1
INSERT INTO CATEGORIA_ACESSO VALUES ('Administrativo'	, 0, GETDATE()); -- 2



/****************************************************************************************************************************************
Tabela que armazena as informações dos usuário.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS USUARIO
CREATE TABLE USUARIO
(
	USU_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	USU_LOGIN_CPF_CHAR			CHAR(11)		NOT NULL,
	USU_NOME_USUARIO_STR		VARCHAR(45)		NOT NULL,
	USU_SENHA_STR				VARBINARY(200)	NOT NULL,
	USU_EXCLUIDO_BIT			BIT				NOT NULL,
	USU_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL

	--PK
	CONSTRAINT PK_USU_ID_INT PRIMARY KEY (USU_ID_INT)
)


/****************************************************************************************************************************************
Tabela que armazena a pergunta de segurança do usuário.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PERGUNTA_SEGURANCA
CREATE TABLE PERGUNTA_SEGURANCA
(
	PERG_SEG_ID_INT				INT				NOT NULL IDENTITY(10000001, 1),
	PERG_SEG_PERGUNTA_STR		VARCHAR(MAX)	NOT NULL,
	PERG_SEG_RESPOSTA_STR		VARCHAR(MAX)	NOT NULL,
	PERG_SEG_USU_ID_INT			INT				NOT NULL,
	PERG_SEG_EXCLUIDO_BIT		BIT				NOT NULL,
	PERG_SEG_CADASTRO_DATETIME	DATETIME		NOT NULL

	--PK
	CONSTRAINT PK_PERG_SEG_ID_INT PRIMARY KEY (PERG_SEG_ID_INT)

	--FK
	CONSTRAINT FK_PERG_SEG_USU_ID_INT FOREIGN KEY (PERG_SEG_USU_ID_INT)
	REFERENCES USUARIO (USU_ID_INT)
)


/****************************************************************************************************************************************
Tabela que armazena as informações de contato dos hóspedes e funcionários.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CONTATOS
CREATE TABLE CONTATOS
(
	CONT_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	CONT_EMAIL_STR				VARCHAR(50)		NOT NULL,
	CONT_CELULAR_CHAR			CHAR(13),
	CONT_TELEFONE_CHAR			CHAR(12),
	CONT_EXCLUIDO_BIT			BIT				NOT NULL,
	CONT_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL

	--PK
	CONSTRAINT PK_CONT_ID_INT PRIMARY KEY (CONT_ID_INT)
)


/****************************************************************************************************************************************
Tabela que armazena as informações dos hóspedes.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS HOSPEDE;
CREATE TABLE HOSPEDE
(
	HSP_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	HSP_NOME_STR				VARCHAR(255),
	HSP_CPF_CHAR				CHAR(11),
	HSP_DTNASC_DATE				DATE,
	HSP_END_ID_INT				INT,
	HSP_USU_ID_INT				INT,
	HSP_CONT_ID_INT				INT,
	HSP_EXCLUIDO_BIT			BIT				NOT NULL,
	HSP_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL

	-- PRIMARY KEY
	CONSTRAINT PK_HSP_ID_INT PRIMARY KEY(HSP_ID_INT),

	-- FOREIGN KEY
	CONSTRAINT FK_HSP_END_ID_INT FOREIGN KEY(HSP_END_ID_INT)
	REFERENCES ENDERECO(END_ID_INT),

	CONSTRAINT FK_HSP_USU_ID_INT FOREIGN KEY(HSP_USU_ID_INT)
	REFERENCES USUARIO(USU_ID_INT),

	CONSTRAINT FK_HSP_CONT_ID_INT FOREIGN KEY(HSP_CONT_ID_INT)
	REFERENCES CONTATOS(CONT_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações dos funcionários da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS FUNCIONARIO;
CREATE TABLE FUNCIONARIO
(
	FUNC_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	FUNC_NOME_STR				VARCHAR(255)	NOT NULL,
	FUNC_CPF_CHAR				CHAR(11)		NOT NULL,
	FUNC_NACIONALIDADE_STR		VARCHAR(50)		NOT NULL,
	FUNC_DTNASC_DATE			DATE			NOT NULL,
	FUNC_SEXO_CHAR				CHAR(1)			NOT NULL,
	FUNC_RG_CHAR				CHAR(9)			NOT NULL,
	FUNC_CARGO_STR				VARCHAR(50)		NOT NULL,
	FUNC_SETOR_STR				VARCHAR(50)		NOT NULL,
	FUNC_SALARIO_FLOAT			FLOAT(2)		NOT NULL,
	FUNC_END_ID_INT				INT,
	FUNC_USU_ID_INT				INT,
	FUNC_CATACESSO_ID_INT		INT,
	FUNC_CONT_ID_INT			INT,
	FUNC_EXCLUIDO_BIT			BIT				NOT NULL,
	FUNC_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL
	
	-- PK
	CONSTRAINT PK_FUNC_ID_INT PRIMARY KEY(FUNC_ID_INT),

	-- FK
	CONSTRAINT FK_FUNC_END_ID_INT FOREIGN KEY(FUNC_END_ID_INT)
	REFERENCES ENDERECO(END_ID_INT),

	CONSTRAINT FK_FUNC_CATACESSO_ID_INT FOREIGN KEY(FUNC_CATACESSO_ID_INT)
	REFERENCES CATEGORIA_ACESSO(CATACESSO_ID_INT),

	CONSTRAINT FK_FUNC_USU_ID_INT FOREIGN KEY(FUNC_USU_ID_INT)
	REFERENCES USUARIO(USU_ID_INT),

	CONSTRAINT FK_FUNC_CONT_ID_INT FOREIGN KEY(FUNC_CONT_ID_INT)
	REFERENCES CONTATOS(CONT_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações da FNRH dos hóspedes.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS FNRH;
CREATE TABLE FNRH
(
	FNRH_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	FNRH_PROFISSAO_STR			VARCHAR(255),
	FNRH_NACIONALIDADE_STR		VARCHAR(50),
	FNRH_SEXO_CHAR				CHAR(1),
	FNRH_RG_CHAR				CHAR(9),
	FNRH_PROXIMO_DESTINO_STR	VARCHAR(255),
	FNRH_ULTIMO_DESTINO_STR		VARCHAR(255),
	FNRH_MOTIVO_VIAGEM_STR		VARCHAR(255),
	FNRH_MEIO_DE_TRANSPORTE_STR VARCHAR(255),
	FNRH_PLACA_AUTOMOVEL_STR	VARCHAR(255),
	FNRH_NUM_ACOMPANHANTES_INT	INT,
	FNRH_HSP_ID_INT				INT,
	FNRH_EXCLUIDO_BIT			BIT				NOT NULL,
	FNRH_DATA_CADASTRO_DATETIME DATETIME		NOT NULL
	
	-- PRIMARY KEY
	CONSTRAINT PK_FNRH_ID_INT PRIMARY KEY(FNRH_ID_INT),

	-- FOREIGN KEY
	CONSTRAINT FK_HSP_ID_HOSPEDE_INT FOREIGN KEY(FNRH_HSP_ID_INT)
	REFERENCES HOSPEDE(HSP_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de dados bancários dos funcionários da pousada. Essa tabela possui a chave estrangeira de FUNCIONARIO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS DADOSBANCARIOS;
CREATE TABLE DADOSBANCARIOS
(
	DADOSBC_ID_INT					INT				NOT NULL IDENTITY(10000001, 1),
	DADOSBC_BANCO_STR				VARCHAR(50),
	DADOSBC_AGENCIA_STR				VARCHAR(50),
	DADOSBC_NUMERO_CONTA_STR		VARCHAR(50),
	DADOSBC_FUNC_ID_INT				INT,
	DADOSBC_EXCLUIDO_BIT			BIT				NOT NULL,
	DADOSBC_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL
	
	--PK
	CONSTRAINT PK_DADOSBC_ID_INT PRIMARY KEY(DADOSBC_ID_INT),

	--FK
	 CONSTRAINT FK_DADOSBC_FUNC_ID_INT FOREIGN KEY(DADOSBC_FUNC_ID_INT)
	 REFERENCES FUNCIONARIO(FUNC_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de categoria das acomodações da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CATEGORIA_ACOMODACAO;
CREATE TABLE CATEGORIA_ACOMODACAO
(
	CAT_ACOMOD_ID_INT					INT			NOT NULL IDENTITY(1, 1),
	CAT_ACOMOD_DESCRICAO_STR			VARCHAR(50)	NOT NULL CHECK
	(
		CAT_ACOMOD_DESCRICAO_STR IN
		(
			'Chalé Standard', -- 1
			'Chalé Superior', -- 2
			'Chalé Master'    -- 3
		)
	),
	CAT_ACOMOD_EXCLUIDO_BIT				BIT			NOT NULL,
	CAT_ACOMOD_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	-- PK
	CONSTRAINT PK_CAT_ACOMOD_ID_INT PRIMARY KEY(CAT_ACOMOD_ID_INT)
);

INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Standard', 0, GETDATE()); -- 1
INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Superior', 0, GETDATE()); -- 2
INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Master'	 , 0, GETDATE()); -- 3



/****************************************************************************************************************************************
Tabela que armazena as informações específicas das acomodações da pousada. Essa tabela possui a chave estrangeira de CATEGORIA_ACOMODA-
CAO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS INFORMACOES_ACOMODACAO;
CREATE TABLE INFORMACOES_ACOMODACAO
(
	INFO_ACOMOD_ID_INT					INT			NOT NULL IDENTITY(1,1),
	INFO_ACOMOD_METROS_QUADRADOS_FLOAT	FLOAT(2)	NOT NULL CHECK
	(
		INFO_ACOMOD_METROS_QUADRADOS_FLOAT IN
		(
			35.00,
			40.00,
			45.00 
		)
	),
	INFO_ACOMOD_CAPACIDADE_INT			INT			NOT NULL CHECK
	(
		INFO_ACOMOD_CAPACIDADE_INT IN
		(
			4,
			3 
		)
	),
	INFO_ACOMOD_TIPO_DE_CAMA_STR		VARCHAR(255) NOT NULL CHECK
	(
		INFO_ACOMOD_TIPO_DE_CAMA_STR IN
		(
			'Double'
		)
	),
	INFO_ACOMOD_PRECO_FLOAT				FLOAT(2)	NOT NULL,
	INFO_ACOMOD_CAT_ACOMOD_ID_INT		INT			NOT NULL,
	INFO_ACOMOD_EXCLUIDO_BIT			BIT			NOT NULL,
	INFO_ACOMOD_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	
	--PK
	CONSTRAINT PK_INFO_ACOMOD_ID_INT PRIMARY KEY(INFO_ACOMOD_ID_INT),

	--FK
	CONSTRAINT FK_INFO_ACOMOD_CAT_ACOMOD_ID_INT FOREIGN KEY(INFO_ACOMOD_CAT_ACOMOD_ID_INT)
	REFERENCES CATEGORIA_ACOMODACAO(CAT_ACOMOD_ID_INT)
);

INSERT INTO INFORMACOES_ACOMODACAO VALUES (35.00, 4, 'Double', 530.00, 1, 0, GETDATE()); -- Chalé Standard	1
INSERT INTO INFORMACOES_ACOMODACAO VALUES (40.00, 3, 'Double', 580.00, 2, 0, GETDATE()); -- Chalé Superior	2
INSERT INTO INFORMACOES_ACOMODACAO VALUES (45.00, 3, 'Double', 650.00, 3, 0, GETDATE()); -- Chalé Master	3



/****************************************************************************************************************************************
Tabela que armazena os status das acomodações da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_ACOMODACAO;
CREATE TABLE STATUS_ACOMODACAO
(
	ST_ACOMOD_ID_INT					INT			NOT NULL IDENTITY(1,1),
	ST_ACOMOD_DESCRICAO_STR				VARCHAR(50)	NOT NULL CHECK
	(
		ST_ACOMOD_DESCRICAO_STR IN
		(
			'Ocupado',		-- 1
			'Iniciada',		-- 2
			'Disponível'	-- 3
		)
	),
	ST_ACOMOD_EXCLUIDO_BIT				BIT			NOT NULL,
	ST_ACOMOD_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	CONSTRAINT FK_ST_ACOMOD_ID_INT PRIMARY KEY(ST_ACOMOD_ID_INT)
);

INSERT INTO STATUS_ACOMODACAO VALUES ('Ocupado'		, 0, GETDATE()); -- 1
INSERT INTO STATUS_ACOMODACAO VALUES ('Iniciada'	, 0, GETDATE()); -- 2
INSERT INTO STATUS_ACOMODACAO VALUES ('Disponível'	, 0, GETDATE()); -- 3



/****************************************************************************************************************************************
Tabela que armazena as acomodações da pousada. Essa tabela possui as chaves estrangeiras de INFORMACOES_ACOMODACAO e STATUS_ACOMODACAO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ACOMODACAO;
CREATE TABLE ACOMODACAO
(
	ACO_ID_INT					INT				NOT NULL IDENTITY(1,1),
	ACO_NOME_STR				VARCHAR(255)	NOT NULL,
	ACO_ST_ACOMOD_INT			INT				NOT NULL,
	ACO_INFO_ACOMOD_ID_INT		INT				NOT NULL,
	ACO_EXCLUIDO_BIT			BIT				NOT NULL,
	ACO_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL
	
	--PK
	CONSTRAINT PK_ACO_ID_INT PRIMARY KEY(ACO_ID_INT),
	
	--FK
	CONSTRAINT FK_ACO_INFO_ACOMOD_ID_INT FOREIGN KEY(ACO_INFO_ACOMOD_ID_INT)
	REFERENCES INFORMACOES_ACOMODACAO(INFO_ACOMOD_ID_INT),
	
	CONSTRAINT FC_ACO_ST_ACOMOD_INT FOREIGN KEY(ACO_ST_ACOMOD_INT)
	REFERENCES STATUS_ACOMODACAO(ST_ACOMOD_ID_INT)
);


/************************************************************************************************************************************
CRIAÇÃO DE PROCEDURE PARA, AUTOMATICAMENTE, CRIAR AS ACOMODAÇÕES.
************************************************************************************************************************************/

USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspCriarAcomodacao]
	@NomeAcomodacao nvarchar(50),
	@InfoAcomodacao int
AS
	BEGIN
		DECLARE
		@ValidacaoNome	varchar(50),
		@Msg			varchar(255),
		@MsgResul		varchar(255)

		SELECT @ValidacaoNome = ACO_NOME_STR FROM RECPAPAGAIOS.dbo.[ACOMODACAO] WHERE ACO_NOME_STR = @NomeAcomodacao;

		IF @ValidacaoNome IS NOT NULL
			BEGIN
				SET @MsgResul = 'Já existe uma acomodação cadastrada com o nome ' + @ValidacaoNome;

				RAISERROR(@MsgResul, 20, -1) WITH LOG;
			END
		
		IF @InfoAcomodacao > 3
		BEGIN
			SET @Msg = 'O id das informações da acomodação deve ser igual ou menor a 3. *'
				+ 'O id do chalé deve ser correspondente aos seguintes: *'
				+ '1 - Chalé Standard *'
				+ '2 - Chalé Superior *'
				+ '3 - Chalé Master *';
			SET @MsgResul = REPLACE(@Msg, '*', CHAR(10));

			RAISERROR(@MsgResul, 20, -1) WITH LOG;
		END

		BEGIN TRANSACTION;

			BEGIN TRY

				INSERT INTO RECPAPAGAIOS.dbo.[ACOMODACAO]
				VALUES
				(
					@NomeAcomodacao,
					3,
					@InfoAcomodacao,
					0,
					GETDATE()
				);

			END TRY

			BEGIN CATCH

				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION;

			END CATCH;
		
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
		
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

	END;
GO

EXEC uspCriarAcomodacao 'Chalé 1'	, 1;
EXEC uspCriarAcomodacao 'Chalé 2'	, 1;
EXEC uspCriarAcomodacao 'Chalé 3'	, 1;
EXEC uspCriarAcomodacao 'Chalé 4'	, 1;
EXEC uspCriarAcomodacao 'Chalé 5'	, 1;
EXEC uspCriarAcomodacao 'Chalé 6'	, 1;
EXEC uspCriarAcomodacao 'Chalé 7'	, 2;
EXEC uspCriarAcomodacao 'Chalé 8'	, 2;
EXEC uspCriarAcomodacao 'Chalé 9'	, 3;
EXEC uspCriarAcomodacao 'Chalé 10'	, 3;


/************************************************************************************************************************************
CRIAÇÃO DE PROCEDURE PARA, AUTOMATICAMENTE, CRIAR AS ACOMODAÇÕES.
************************************************************************************************************************************/


/****************************************************************************************************************************************
Tabela que armazena os tipos de pagamento permitidos na pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS TIPO_PAGAMENTO;
CREATE TABLE TIPO_PAGAMENTO
(
	TPPGTO_ID_INT					INT			NOT NULL IDENTITY(1,1),
	TPPGTO_TIPO_PAGAMENTO_STR		VARCHAR(50)	NOT NULL CHECK
	(
		TPPGTO_TIPO_PAGAMENTO_STR IN
		(
			'Dinheiro',					-- 1
			'Cartão de Débito',			-- 2
			'Cartão de Crédito',		-- 3
			'Transferência Bancária',	-- 4
			'Deposito Bancário',		-- 5
			'PIX',						-- 6
			'Sem pagamentos adicionais' -- 7
		)
	),
	TPPGTO_EXCLUIDO_BIT				BIT			NOT NULL,
	TPPGTO_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL
	
	--PK
	CONSTRAINT PK_TPPGTO_ID_INT PRIMARY KEY(TPPGTO_ID_INT)
);

INSERT INTO TIPO_PAGAMENTO VALUES('Dinheiro'					, 0, GETDATE()); -- 1
INSERT INTO TIPO_PAGAMENTO VALUES('Cartão de Débito'			, 0, GETDATE()); -- 2
INSERT INTO TIPO_PAGAMENTO VALUES('Cartão de Crédito'			, 0, GETDATE()); -- 3
INSERT INTO TIPO_PAGAMENTO VALUES('Transferência Bancária'		, 0, GETDATE()); -- 4
INSERT INTO TIPO_PAGAMENTO VALUES('Deposito Bancário'			, 0, GETDATE()); -- 5
INSERT INTO TIPO_PAGAMENTO VALUES('PIX'							, 0, GETDATE()); -- 6
INSERT INTO TIPO_PAGAMENTO VALUES('Sem pagamentos adicionais'	, 0, GETDATE()); -- 7



/****************************************************************************************************************************************
Tabela que armazena os status dos pagamentos feitos à pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_PAGAMENTO;
CREATE TABLE STATUS_PAGAMENTO
(
	ST_PGTO_ID_INT					INT			NOT NULL IDENTITY(1,1),
	ST_PGTO_DESCRICAO_STR			VARCHAR(50)	NOT NULL CHECK
	(
		ST_PGTO_DESCRICAO_STR IN
		(
			'Aprovado',			-- 1
			'Cancelado',		-- 2
			'Não Autorizado',	-- 3
			'Em Processamento'	-- 4
		)
	),
	ST_PGTO_EXCLUIDO_BIT			BIT			NOT NULL,
	ST_PGTO_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	--PK
	CONSTRAINT FK_ST_PGTO_ID_INT PRIMARY KEY(ST_PGTO_ID_INT)
);

INSERT INTO STATUS_PAGAMENTO VALUES ('Aprovado'			, 0, GETDATE()); -- 1
INSERT INTO STATUS_PAGAMENTO VALUES ('Cancelado'		, 0, GETDATE()); -- 2
INSERT INTO STATUS_PAGAMENTO VALUES ('Não Autorizado'	, 0, GETDATE()); -- 3
INSERT INTO STATUS_PAGAMENTO VALUES ('Em Processamento'	, 0, GETDATE()); -- 4



/****************************************************************************************************************************************
Tabela que armazena os status de reserva da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_RESERVA;
CREATE TABLE STATUS_RESERVA
(
	ST_RES_ID_INT					INT			NOT NULL IDENTITY(1,1),
	ST_RES_DESCRICAO_STR			VARCHAR(50)	NOT NULL CHECK
	(
		ST_RES_DESCRICAO_STR IN
		(
			'Iniciada',			-- 1
			'Confirmada',		-- 2
			'Concluída',		-- 3
			'Cancelada'			-- 4
		)
	),
	ST_RES_EXCLUIDO_BIT				BIT			NOT NULL,
	ST_RES_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	--PK
	CONSTRAINT FK_ST_RES_ID_INT PRIMARY KEY(ST_RES_ID_INT)
);

INSERT INTO STATUS_RESERVA VALUES ('Iniciada'	, 0, GETDATE()); -- 1
INSERT INTO STATUS_RESERVA VALUES ('Confirmada'	, 0, GETDATE()); -- 2
INSERT INTO STATUS_RESERVA VALUES ('Concluída'	, 0, GETDATE()); -- 3
INSERT INTO STATUS_RESERVA VALUES ('Cancelada'	, 0, GETDATE()); -- 4



/****************************************************************************************************************************************
Tabela que armazena as reservas feitas à pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS RESERVA;
CREATE TABLE RESERVA
(
	RES_ID_INT					INT			NOT NULL IDENTITY(10000001, 1),
	RES_DATA_RESERVA_DATE		DATE		NOT NULL,
	RES_DATA_CHECKIN_DATE		DATE,
	RES_DATA_CHECKOUT_DATE		DATE,
	RES_VALOR_RESERVA_FLOAT		FLOAT(2)	NOT NULL,
	RES_ST_RES_INT				INT			NOT NULL,
	RES_HSP_ID_INT				INT			NOT NULL,
	RES_ACO_ID_INT				INT			NOT NULL,
	RES_ACOMPANHANTES_ID_INT	INT			NOT NULL,
	RES_EXCLUIDO_BIT			BIT			NOT NULL,
	RES_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL
	
	--PK
	CONSTRAINT PK_RES_ID_INT PRIMARY KEY(RES_ID_INT),
	
	--FK
	CONSTRAINT FK_RES_ST_RES_ID_INT FOREIGN KEY(RES_ST_RES_INT)
	REFERENCES STATUS_RESERVA(ST_RES_ID_INT),

	CONSTRAINT FK_HSP_HSP_ID_INT FOREIGN KEY(RES_HSP_ID_INT)
	REFERENCES HOSPEDE(HSP_ID_INT),

	CONSTRAINT FK_RES_ACO_ID_INT FOREIGN KEY(RES_ACO_ID_INT)
	REFERENCES ACOMODACAO(ACO_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena check-ins feitos em uma reserva.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CHECKIN;
CREATE TABLE CHECKIN
(
	CHECKIN_ID_INT					INT			NOT NULL IDENTITY(10000001, 1),
	CHECKIN_RES_ID_INT				INT,
	CHECKIN_FUNC_ID_INT				INT,
	CHECKIN_EXCLUIDO_BIT			BIT			NOT NULL,
	CHECKIN_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL
	
	--PK
	CONSTRAINT PK_CHECKIN_ID_INT PRIMARY KEY(CHECKIN_ID_INT)
	
	--FK
	CONSTRAINT FK_CHECKIN_FUNC_ID_INT FOREIGN KEY(CHECKIN_FUNC_ID_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT),
	
	CONSTRAINT FK_CHECKIN_RES_ID_INT FOREIGN KEY(CHECKIN_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena os check-outs feitos em uma reserva que, antes, passou pelo check-in.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CHECKOUT;
CREATE TABLE CHECKOUT
(
	CHECKOUT_ID_INT						INT			NOT NULL IDENTITY(10000001, 1),
	CHECKOUT_VALORES_ADICIONAIS_FLOAT	FLOAT(2)	NOT NULL,
	CHECKOUT_VALOR_TOTAL_FLOAT			FLOAT(2)	NOT NULL,
	CHECKOUT_CHECKIN_ID_INT				INT,	
	CHECKOUT_FUNC_ID_INT				INT,
	CHECKOUT_EXCLUIDO_BIT				BIT			NOT NULL,
	CHECKOUT_DATA_CADASTRO_DATETIME		DATETIME	NOT NULL
	
	--PK
	CONSTRAINT PK_CHECKOUT_ID_INT PRIMARY KEY(CHECKOUT_ID_INT)
	
	--FK
	CONSTRAINT FK_CHECKOUT_CHECKIN_ID_INT FOREIGN KEY(CHECKOUT_CHECKIN_ID_INT)
	REFERENCES CHECKIN(CHECKIN_ID_INT),

	CONSTRAINT FK_CHECKOUT_FUNC_ID_INT FOREIGN KEY(CHECKOUT_FUNC_ID_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT)
);



/****************************************************************************************************************************************
Tabela intermediária que armazena as informações de pagamento e reserva feitas de um hospede à pousada ao realizar a reserva ou ao reali-
zar o check-in.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PAGAMENTO_RESERVA;
CREATE TABLE PAGAMENTO_RESERVA
(
	PGTO_RES_ID_INT					INT			NOT NULL IDENTITY(10000001, 1),
	PGTO_RES_TPPGTO_ID_INT			INT			NOT NULL,
	PGTO_RES_RES_ID_INT				INT			NOT NULL,
	PGTO_RES_ST_PGTO_ID_INT			INT			NOT NULL,
	PGTO_RES_EXCLUIDO_BIT			BIT			NOT NULL,
	PGTO_RES_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	--PK
	CONSTRAINT PK_PGTO_RES_ID_INT PRIMARY KEY(PGTO_RES_ID_INT)

	--FK
	CONSTRAINT FK_PGTO_RES_TPPGTO_ID_INT FOREIGN KEY (PGTO_RES_TPPGTO_ID_INT)
	REFERENCES TIPO_PAGAMENTO(TPPGTO_ID_INT),

	CONSTRAINT FK_PGTO_RES_RES_ID_INT FOREIGN KEY(PGTO_RES_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT),

	CONSTRAINT FK_PGTO_RES_ST_PGTO_ID_INT FOREIGN KEY(PGTO_RES_ST_PGTO_ID_INT)
	REFERENCES STATUS_PAGAMENTO(ST_PGTO_ID_INT)
);



/****************************************************************************************************************************************
Tabela intermediária que armazena as informações de pagamento e reserva feitas de um hospede à pousada ao realizar o check-out.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PAGAMENTO_CHECK_OUT;
CREATE TABLE PAGAMENTO_CHECK_OUT
(
	PGTO_COUT_ID_INT					INT			NOT NULL IDENTITY(10000001, 1),
	PGTO_COUT_TPPGTO_ID_INT				INT			NOT NULL,
	PGTO_COUT_RES_ID_INT				INT			NOT NULL,
	PGTO_COUT_ST_PGTO_ID_INT			INT			NOT NULL,
	PGTO_COUT_CHECK_OUT_ID_INT			INT			NOT NULL,
	PGTO_COUT_EXCLUIDO_BIT				BIT			NOT NULL,
	PGTO_COUT_DATA_CADASTRO_DATETIME	DATETIME	NOT NULL

	--PK
	CONSTRAINT PK_PGTO_COUT_ID_IN PRIMARY KEY(PGTO_COUT_ID_INT)

	--FK
	CONSTRAINT FK_PGTO_COUT_TPPGTO_ID_INT FOREIGN KEY (PGTO_COUT_TPPGTO_ID_INT)
	REFERENCES TIPO_PAGAMENTO(TPPGTO_ID_INT),

	CONSTRAINT FK_PGTO_COUT_RES_ID_INT FOREIGN KEY(PGTO_COUT_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT),

	CONSTRAINT FK_PGTO_COUT_ST_PGTO_ID_INT FOREIGN KEY(PGTO_COUT_ST_PGTO_ID_INT)
	REFERENCES STATUS_PAGAMENTO(ST_PGTO_ID_INT),

	CONSTRAINT FK_PGTO_COUT_CHECK_OUT_ID_INT FOREIGN KEY(PGTO_COUT_CHECK_OUT_ID_INT)
	REFERENCES CHECKOUT(CHECKOUT_ID_INT)
);



/****************************************************************************************************************************************
Tabela utilizada para armazenar os alertas criados pelos funcionários:
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ALERTAS
CREATE TABLE ALERTAS
(
	 ALERTAS_ID_INT					INT				NOT NULL IDENTITY(10000001, 1)
	,ALERTAS_TITULO_STR				VARCHAR(50)		NOT NULL
	,ALERTAS_MENSAGEM_STR			VARCHAR(200)	NOT NULL
	,ALERTAS_FUNC_ID_INT			INT				NOT NULL
	,ALERTAS_EXCLUIDO_BIT			BIT				NOT NULL
	,ALERTAS_DATA_CADASTRO_DATETIME	DATETIME		NOT NULL

	CONSTRAINT PK_ALERTAS_ID_INT PRIMARY KEY(ALERTAS_ID_INT)

	CONSTRAINT FK_ALERTAS_FUNC_ID_INT FOREIGN KEY(ALERTAS_FUNC_ID_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT)
);



/****************************************************************************************************************************************
Tabela utilizada para armazenar logs de erros de TRANSACTIONS ao longo realizadas ao longo das procedures.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS LOGSERROS
CREATE TABLE LOGSERROS
(
	 LOG_ERR_ID_INT						INT				NOT NULL IDENTITY(10000001, 1)
	,LOG_ERR_ERRORNUMBER_INT			INT
	,LOG_ERR_ERRORSEVERITY_INT			INT
	,LOG_ERR_ERRORSTATE_INT				INT
	,LOG_ERR_ERRORPROCEDURE_VARCHAR		VARCHAR(255)
	,LOG_ERR_ERRORLINE_INT				INT
	,LOG_ERR_ERRORMESSAGE_VARCHAR		VARCHAR(500)
	,LOG_ERR_DATE						DATETIME		NOT NULL
	
	CONSTRAINT PK_LOG_ERR_ID_INT PRIMARY KEY(LOG_ERR_ID_INT)
);



/****************************************************************************************************************************************
Tabela utilizada para armazenar logs de integrações realizadas no momento das chamadas à API.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS LOGSINTEGRACOES
CREATE TABLE LOGSINTEGRACOES
(
	 LOG_INTE_ID_INT			INT				NOT NULL IDENTITY(10000001, 1)
	,LOG_INTE_ENTIDADE_STR		VARCHAR(50)		NOT NULL
	,LOG_INTE_JSON_STR			VARCHAR(MAX)	NOT NULL
	,LOG_INTE_MENSAGEM_STR		VARCHAR(600)	NOT NULL
	,LOG_INTE_ACAO_STR			VARCHAR(50)		NOT NULL
	,LOG_INTE_STATUSCODE_INT	INT				NOT NULL
	,LOG_INTE_ID_CADASTRO_INT	INT
	,LOG_INTE_DATE				DATETIME		NOT NULL

	CONSTRAINT PK_LOG_INTE_ID_INT PRIMARY KEY(LOG_INTE_ID_INT)
);