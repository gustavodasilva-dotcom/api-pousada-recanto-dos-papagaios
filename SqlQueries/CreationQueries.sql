-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- CRIAÇÃO DAS TABELAS ------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

USE RECPAPAGAIOS
GO



/****************************************************************************************************************************************
Tabela que armazena as informações dos hóspedes.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS HOSPEDE;
CREATE TABLE HOSPEDE
(
	HSP_ID_INT				INT NOT NULL IDENTITY(1,1),
	HSP_NOME_STR			VARCHAR(255),
	HSP_CPF_CHAR			CHAR(11),
	HSP_DTNASC_DATE			DATE,
	HSP_EMAIL_STR			VARCHAR(50),
	HSP_LOGIN_CPF_CHAR		CHAR(11),
	HSP_LOGIN_SENHA_STR		VARCHAR(50),
	HSP_CELULAR_STR			CHAR(13),
	HSP_EXCLUIDO_BIT		BIT

	-- PRIMARY KEY
	CONSTRAINT PK_HSP_ID_INT PRIMARY KEY(HSP_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de endereço dos hóspedes. Essa tabela possui uma chave estrangeira da tabela HOSPEDE.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ENDERECO_HOSPEDE;
CREATE TABLE ENDERECO_HOSPEDE
(
	END_ID_ENDERECO_INT		INT NOT NULL IDENTITY(1,1),
	END_CEP_CHAR			CHAR(8),
	END_LOGRADOURO_STR		VARCHAR(255),
	END_NUMERO_CHAR			VARCHAR(8),
	END_COMPLEMENTO_STR		VARCHAR(255),
	END_CIDADE_STR			VARCHAR(255),
	END_BAIRRO_STR			VARCHAR(255),
	END_ESTADO_CHAR			CHAR(2),
	END_PAIS_STR			VARCHAR(255),
	END_ID_HOSPEDE_INT		INT, -- "FOREIGN KEY"
	END_CPF_HOSPEDE_STR		CHAR(11), -- CPF DO HÓSPEDE
	END_EXCLUIDO_BIT		BIT

	-- PRIMARY KEY
	CONSTRAINT PK_END_ID_ENDERECO_INT PRIMARY KEY(END_ID_ENDERECO_INT)

	-- FOREIGN KEY
	CONSTRAINT FK_END_ID_HOSPEDE_INT FOREIGN KEY(END_ID_HOSPEDE_INT)
	REFERENCES HOSPEDE(HSP_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações da FNRH dos hóspedes. Essa tabela possui uma chave estrangeira da tabela HOSPEDE.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS FNRH;
CREATE TABLE FNRH
(
	FNRH_ID_INT					INT NOT NULL IDENTITY(1,1),
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
	FNRH_CPF_HOSPEDE_STR		CHAR(11),
	FNRH_EXCLUIDO_BIT			BIT
	
	-- PRIMARY KEY
	CONSTRAINT PK_FNRH_ID_INT PRIMARY KEY(FNRH_ID_INT)

	-- FOREIGN KEY
	CONSTRAINT FK_HSP_ID_HOSPEDE_INT FOREIGN KEY(FNRH_HSP_ID_INT)
	REFERENCES HOSPEDE(HSP_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de acesso dos funcionários da pousada ao sistema.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CATEGORIA_ACESSO;
CREATE TABLE CATEGORIA_ACESSO
(
	CATACESSO_ID_INT			INT NOT NULL IDENTITY(1, 1),
	CATACESSO_DESCRICAO_STR		VARCHAR(50) NOT NULL CHECK
	(
		CATACESSO_DESCRICAO_STR IN
		(
			'Recepcao',			-- 1
			'Administrativo'	-- 2
		)
	),

	-- PK
	CONSTRAINT PK_CATACESSO_ID_INT PRIMARY KEY(CATACESSO_ID_INT)
);

INSERT INTO CATEGORIA_ACESSO VALUES ('Recepcao');		-- 1
INSERT INTO CATEGORIA_ACESSO VALUES ('Administrativo'); -- 2



/****************************************************************************************************************************************
Tabela que armazena as informações dos funcionários da pousada. Essa tabela possui a chave estrangeira de CATEGORIA_ACESSO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS FUNCIONARIO;
CREATE TABLE FUNCIONARIO
(
	FUNC_ID_INT				INT NOT NULL IDENTITY(1,1),
	FUNC_NOME_STR			VARCHAR(255) NOT NULL,
	FUNC_CPF_CHAR			CHAR(11) NOT NULL,
	FUNC_NACIONALIDADE_STR	VARCHAR(50) NOT NULL,
	FUNC_DTNASC_DATE		DATE NOT NULL,
	FUNC_SEXO_CHAR			CHAR(1) NOT NULL,
	FUNC_RG_CHAR			CHAR(9) NOT NULL,
	FUNC_CELULAR_CHAR		CHAR(13) NOT NULL,
	FUNC_CARGO_STR			VARCHAR(50) NOT NULL,
	FUNC_SETOR_STR			VARCHAR(50) NOT NULL,
	FUNC_SALARIO_FLOAT		FLOAT(2) NOT NULL,
	FUNC_EMAIL_STR			VARCHAR(50) NOT NULL,
	FUNC_NOME_USUARIO_STR	VARCHAR(45),
	FUNC_SENHA_USUARIO_STR	VARCHAR(45),
	FUNC_CATACESSO_ID_INT	INT,
	FUNC_EXCLUIDO_BIT		BIT
	
	-- PK
	CONSTRAINT PK_FUNC_ID_INT PRIMARY KEY(FUNC_ID_INT),

	-- FK
	 CONSTRAINT FK_FUNC_CATACESSO_ID_INT FOREIGN KEY(FUNC_CATACESSO_ID_INT)
	 REFERENCES CATEGORIA_ACESSO(CATACESSO_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de endereço dos funcionários da pousada. Essa tabela possui a chave estrangeira de FUNCIONARIO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ENDERECO_FUNCIONARIO;
CREATE TABLE ENDERECO_FUNCIONARIO
(
	END_FUNC_ID_ENDERECO_INT	INT NOT NULL IDENTITY(1,1),
	END_FUNC_CEP_CHAR			CHAR(8),
	END_FUNC_LOGRADOURO_STR		VARCHAR(255),
	END_FUNC_NUMERO_CHAR		VARCHAR(8),
	END_FUNC_COMPLEMENTO_STR	VARCHAR(255),
	END_FUNC_BAIRRO_STR			VARCHAR(255),
	END_FUNC_CIDADE_STR			VARCHAR(255),
	END_FUNC_ESTADO_CHAR		CHAR(2),
	END_FUNC_PAIS_STR			VARCHAR(255),
	END_FUNC_ID_FUNCIONARIO_INT INT,
	END_FUNC_CPF_HOSPEDE_STR	CHAR(11),
	END_FUNC_EXCLUIDO_BIT		BIT

	-- PRIMARY KEY
	CONSTRAINT PK_END_ID_ENDERECO_FUNCIONARIO_INT PRIMARY KEY(END_FUNC_ID_ENDERECO_INT)

	-- FOREIGN KEY
	CONSTRAINT FK_END_ID_FUNCIONARIO_INT FOREIGN KEY(END_FUNC_ID_FUNCIONARIO_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de dados bancários dos funcionários da pousada. Essa tabela possui a chave estrangeira de FUNCIONARIO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS DADOSBANCARIOS;
CREATE TABLE DADOSBANCARIOS
(
	DADOSBC_ID_INT					INT NOT NULL IDENTITY(1,1),
	DADOSBC_BANCO_STR				VARCHAR(50),
	DADOSBC_AGENCIA_STR				VARCHAR(50),
	DADOSBC_NUMERO_CONTA_STR		VARCHAR(50),
	DADOSBC_FUNCIONARIO_ID_INT		INT, -- "FOREIGN KEY" FUNCIONARIO
	DADOSBC_FUNCIONARIO_CPF_CHAR	CHAR(11),
	DADOSBC_EXCLUIDO_BIT			BIT
	
	--PK
	CONSTRAINT PK_DADOSBC_ID_INT PRIMARY KEY(DADOSBC_ID_INT),

	--FK
	 CONSTRAINT FK_DADOSBC_FUNC_ID_INT FOREIGN KEY(DADOSBC_FUNCIONARIO_ID_INT)
	 REFERENCES FUNCIONARIO(FUNC_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena as informações de categoria das acomodações da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CATEGORIA_ACOMODACAO;
CREATE TABLE CATEGORIA_ACOMODACAO
(
	CAT_ACOMOD_ID_INT				INT NOT NULL IDENTITY(1, 1),
	CAT_ACOMOD_DESCRICAO_STR		VARCHAR(50) NOT NULL CHECK
	(
		CAT_ACOMOD_DESCRICAO_STR IN
		(
			'Chalé Standard', -- 1
			'Chalé Superior', -- 2
			'Chalé Master'    -- 3
		)
	),

	-- PK
	CONSTRAINT PK_CAT_ACOMOD_ID_INT PRIMARY KEY(CAT_ACOMOD_ID_INT)
);

INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Standard');	-- 1
INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Superior'); -- 2
INSERT INTO CATEGORIA_ACOMODACAO VALUES ('Chalé Master');	-- 3



/****************************************************************************************************************************************
Tabela que armazena as informações específicas das acomodações da pousada. Essa tabela possui a chave estrangeira de CATEGORIA_ACOMODA-
CAO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS INFORMACOES_ACOMODACAO;
CREATE TABLE INFORMACOES_ACOMODACAO
(
	INFO_ACOMOD_ID_INT					INT NOT NULL IDENTITY(1,1),
	INFO_ACOMOD_METROS_QUADRADOS_FLOAT	FLOAT(2) NOT NULL CHECK
	(
		INFO_ACOMOD_METROS_QUADRADOS_FLOAT IN
		(
			35.00,
			40.00,
			45.00 
		)
	),
	INFO_ACOMOD_CAPACIDADE_INT			INT NOT NULL CHECK
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
	INFO_ACOMOD_PRECO_FLOAT				FLOAT(2) NOT NULL,
	INFO_ACOMOD_CAT_ACOMOD_ID_INT		INT NOT NULL
	
	--PK
	CONSTRAINT PK_INFO_ACOMOD_ID_INT PRIMARY KEY(INFO_ACOMOD_ID_INT)

	--FK
	CONSTRAINT FK_INFO_ACOMOD_CAT_ACOMOD_ID_INT FOREIGN KEY(INFO_ACOMOD_CAT_ACOMOD_ID_INT)
	REFERENCES CATEGORIA_ACOMODACAO(CAT_ACOMOD_ID_INT)
);

INSERT INTO INFORMACOES_ACOMODACAO VALUES (35.00, 4, 'Double', 530.00, 1); -- Chalé Standard	1
INSERT INTO INFORMACOES_ACOMODACAO VALUES (40.00, 3, 'Double', 580.00, 2); -- Chalé Superior	2
INSERT INTO INFORMACOES_ACOMODACAO VALUES (45.00, 3, 'Double', 650.00, 3); -- Chalé Master		3



/****************************************************************************************************************************************
Tabela que armazena os status das acomodações da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_ACOMODACAO;
CREATE TABLE STATUS_ACOMODACAO
(
	ST_ACOMOD_ID_INT				INT NOT NULL IDENTITY(1,1),
	ST_ACOMOD_DESCRICAO_STR			VARCHAR(50) NOT NULL CHECK
	(
		ST_ACOMOD_DESCRICAO_STR IN
		(
			'Ocupado',		-- 1
			'Iniciada',		-- 2
			'Disponível'	-- 3
		)
	)

	CONSTRAINT FK_ST_ACOMOD_ID_INT PRIMARY KEY(ST_ACOMOD_ID_INT)
);

INSERT INTO STATUS_ACOMODACAO VALUES ('Ocupado');		-- 1
INSERT INTO STATUS_ACOMODACAO VALUES ('Iniciada');		-- 2
INSERT INTO STATUS_ACOMODACAO VALUES ('Disponível');	-- 3



/****************************************************************************************************************************************
Tabela que armazena as acomodações da pousada. Essa tabela possui as chaves estrangeiras de INFORMACOES_ACOMODACAO e STATUS_ACOMODACAO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS ACOMODACAO;
CREATE TABLE ACOMODACAO
(
	ACO_ID_INT				INT NOT NULL IDENTITY(1,1),
	ACO_NOME_STR			VARCHAR(255) NOT NULL,
	ACO_ST_ACOMOD_INT		INT NOT NULL,
	ACO_INFO_ACOMOD_ID_INT	INT NOT NULL,
	ACO_EXCLUIDO_BIT		BIT
	
	--PK
	CONSTRAINT PK_ACO_ID_INT PRIMARY KEY(ACO_ID_INT),
	
	--FK
	CONSTRAINT FK_ACO_INFO_ACOMOD_ID_INT FOREIGN KEY(ACO_INFO_ACOMOD_ID_INT)
	REFERENCES INFORMACOES_ACOMODACAO(INFO_ACOMOD_ID_INT),
	
	CONSTRAINT FC_ACO_ST_ACOMOD_INT FOREIGN KEY(ACO_ST_ACOMOD_INT)
	REFERENCES STATUS_ACOMODACAO(ST_ACOMOD_ID_INT)
);

EXEC SP_CriarAcomodacao 'Chale 1', 1;
EXEC SP_CriarAcomodacao 'Chale 2', 1;
EXEC SP_CriarAcomodacao 'Chale 3', 1;
EXEC SP_CriarAcomodacao 'Chale 4', 1;
EXEC SP_CriarAcomodacao 'Chale 5', 1;
EXEC SP_CriarAcomodacao 'Chale 6', 1;
EXEC SP_CriarAcomodacao 'Chale 7', 2;
EXEC SP_CriarAcomodacao 'Chale 8', 2;
EXEC SP_CriarAcomodacao 'Chale 9', 3;
EXEC SP_CriarAcomodacao 'Chale 10', 3;



/****************************************************************************************************************************************
Tabela que armazena os tipos de pagamento permitidos na pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS TIPO_PAGAMENTO;
CREATE TABLE TIPO_PAGAMENTO
(
	TPPGTO_ID_INT					INT NOT NULL IDENTITY(1,1),
	TPPGTO_TIPO_PAGAMENTO_STR		VARCHAR(50) NOT NULL CHECK
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
	)
	
	--PK
	CONSTRAINT PK_TPPGTO_ID_INT PRIMARY KEY(TPPGTO_ID_INT)
);

INSERT INTO TIPO_PAGAMENTO VALUES('Dinheiro');					-- 1
INSERT INTO TIPO_PAGAMENTO VALUES('Cartão de Débito');			-- 2
INSERT INTO TIPO_PAGAMENTO VALUES('Cartão de Crédito');			-- 3
INSERT INTO TIPO_PAGAMENTO VALUES('Transferência Bancária');	-- 4
INSERT INTO TIPO_PAGAMENTO VALUES('Deposito Bancário');			-- 5
INSERT INTO TIPO_PAGAMENTO VALUES('PIX');						-- 6
INSERT INTO TIPO_PAGAMENTO VALUES('Sem pagamentos adicionais'); -- 7



/****************************************************************************************************************************************
Tabela que armazena os status dos pagamentos feitos à pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_PAGAMENTO;
CREATE TABLE STATUS_PAGAMENTO
(
	ST_PGTO_ID_INT				INT NOT NULL IDENTITY(1,1),
	ST_PGTO_DESCRICAO_STR		VARCHAR(50) NOT NULL CHECK
	(
		ST_PGTO_DESCRICAO_STR IN
		(
			'Aprovado',			-- 1
			'Cancelado',		-- 2
			'Não Autorizado',	-- 3
			'Em Processamento'	-- 4
		)
	)

	--PK
	CONSTRAINT FK_ST_PGTO_ID_INT PRIMARY KEY(ST_PGTO_ID_INT)
);

INSERT INTO STATUS_PAGAMENTO VALUES ('Aprovado');			-- 1
INSERT INTO STATUS_PAGAMENTO VALUES ('Cancelado');			-- 2
INSERT INTO STATUS_PAGAMENTO VALUES ('Não Autorizado');		-- 3
INSERT INTO STATUS_PAGAMENTO VALUES ('Em Processamento');	-- 4



/****************************************************************************************************************************************
Tabela que armazena os pagamentos permitidos na pousada. Possui a chave estrangeira de TIPO_PAGAMENTO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PAGAMENTO;
CREATE TABLE PAGAMENTO
(
	PGTO_ID_INT				INT NOT NULL IDENTITY(1,1),
	PGTO_TPPGTO_ID_INT		INT NOT NULL
	
	--PK
	CONSTRAINT PK_PGTO_ID_INT PRIMARY KEY(PGTO_ID_INT)
	
	--FK
	CONSTRAINT FK_PGTO_TPPGTO_ID_INT FOREIGN KEY(PGTO_TPPGTO_ID_INT)
	REFERENCES TIPO_PAGAMENTO(TPPGTO_ID_INT),
);

INSERT INTO PAGAMENTO VALUES (1); -- 1
INSERT INTO PAGAMENTO VALUES (2); -- 2
INSERT INTO PAGAMENTO VALUES (3); -- 3
INSERT INTO PAGAMENTO VALUES (4); -- 4
INSERT INTO PAGAMENTO VALUES (5); -- 5
INSERT INTO PAGAMENTO VALUES (6); -- 6
INSERT INTO PAGAMENTO VALUES (7); -- 7



/****************************************************************************************************************************************
Tabela que armazena os status de reserva da pousada.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS STATUS_RESERVA;
CREATE TABLE STATUS_RESERVA
(
	ST_RES_ID_INT			INT NOT NULL IDENTITY(1,1),
	ST_RES_DESCRICAO_STR	VARCHAR(50) NOT NULL CHECK
	(
		ST_RES_DESCRICAO_STR IN
		(
			'Iniciada',			-- 1
			'Confirmada',		-- 2
			'Concluída'			-- 3
		)
	)

	--PK
	CONSTRAINT FK_ST_RES_ID_INT PRIMARY KEY(ST_RES_ID_INT)
);

INSERT INTO STATUS_RESERVA VALUES ('Iniciada');   -- 1
INSERT INTO STATUS_RESERVA VALUES ('Confirmada'); -- 2
INSERT INTO STATUS_RESERVA VALUES ('Concluída');  -- 3




/****************************************************************************************************************************************
Tabela que armazena as reservas feitas à pousada. Possui as chaves estrangeiras de STATUS_RESERVA, HOSPEDE e ACOMODACAO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS RESERVA;
CREATE TABLE RESERVA
(
	RES_ID_INT					INT NOT NULL IDENTITY(1,1),
	RES_DATA_RESERVA_DATE		DATE NOT NULL,
	RES_DATA_CHECKIN_DATE		DATE,
	RES_DATA_CHECKOUT_DATE		DATE,
	RES_VALOR_RESERVA_FLOAT		FLOAT(2) NOT NULL,
	RES_STATUS_RESERVA_INT		INT NOT NULL,
	RES_HSP_ID_INT				INT NOT NULL,
	RES_ACO_ID_INT				INT NOT NULL,
	RES_ACOMPANHANTES_ID_INT	INT NOT NULL,
	RES_EXCLUIDO_BIT			BIT NOT NULL
	
	--PK
	CONSTRAINT PK_RES_ID_INT PRIMARY KEY(RES_ID_INT),
	
	--FK
	CONSTRAINT FK_RES_ST_RES_ID_INT FOREIGN KEY(RES_STATUS_RESERVA_INT)
	REFERENCES STATUS_RESERVA(ST_RES_ID_INT),

	CONSTRAINT FK_HSP_HSP_ID_INT FOREIGN KEY(RES_HSP_ID_INT)
	REFERENCES HOSPEDE(HSP_ID_INT),

	CONSTRAINT FK_RES_ACO_ID_INT FOREIGN KEY(RES_ACO_ID_INT)
	REFERENCES ACOMODACAO(ACO_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena check-ins feitos em uma reserva. Possui as chaves estrangeiras de FUNCIONARIO e RESERVA.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CHECKIN;
CREATE TABLE CHECKIN
(
	CHECKIN_ID_INT			INT NOT NULL IDENTITY(1,1),
	CHECKIN_RES_ID_INT		INT,
	CHECKIN_FUNC_ID_INT		INT,
	CHECKIN_EXCLUIDO_BIT	BIT
	
	--PK
	CONSTRAINT PK_CHECKIN_ID_INT PRIMARY KEY(CHECKIN_ID_INT)
	
	--FK
	CONSTRAINT FK_CHECKIN_FUNC_ID_INT FOREIGN KEY(CHECKIN_FUNC_ID_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT),
	
	CONSTRAINT FK_CHECKIN_RES_ID_INT FOREIGN KEY(CHECKIN_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT)
);



/****************************************************************************************************************************************
Tabela que armazena os check-outs feitos em uma reserva que, antes, passou pelo check-in. Possui as chaves estrangeiras de CHECKIN, FUN-
CIONARIO e PAGAMENTO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS CHECKOUT;
CREATE TABLE CHECKOUT
(
	CHECKOUT_ID_INT						INT NOT NULL IDENTITY(1,1),
	CHECKOUT_VALORES_ADICIONAIS_FLOAT	FLOAT(2) NOT NULL,
	CHECKOUT_VALOR_TOTAL_FLOAT			FLOAT(2) NOT NULL,
	CHECKOUT_CHECKIN_ID_INT				INT,	
	CHECKOUT_FUNC_ID_INT				INT,
	CHECKOUT_PGTO_ID_INT				INT,
	CHECKOUT_EXCLUIDO_BIT				BIT
	
	--PK
	CONSTRAINT PK_CHECKOUT_ID_INT PRIMARY KEY(CHECKOUT_ID_INT)
	
	--FK
	CONSTRAINT FK_CHECKOUT_CHECKIN_ID_INT FOREIGN KEY(CHECKOUT_CHECKIN_ID_INT)
	REFERENCES CHECKIN(CHECKIN_ID_INT),

	CONSTRAINT FK_CHECKOUT_FUNC_ID_INT FOREIGN KEY(CHECKOUT_FUNC_ID_INT)
	REFERENCES FUNCIONARIO(FUNC_ID_INT),

	CONSTRAINT FK_CHECKOUT_PGTO_ID_INT FOREIGN KEY(CHECKOUT_PGTO_ID_INT)
	REFERENCES PAGAMENTO(PGTO_ID_INT)
);



/****************************************************************************************************************************************
Tabela intermediária que armazena as informações de pagamento e reserva feitas de um hospede à pousada ao realizar a reserva ou ao reali-
zar o check-in. Possui as chaves estrangeiras de PAGAMENTO, RESERVA e STATUS_PAGAMENTO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PAGAMENTO_RESERVA;
CREATE TABLE PAGAMENTO_RESERVA
(
	PGTO_RES_ID_INT				INT NOT NULL IDENTITY(1,1),
	PGTO_RES_PGTO_ID_INT		INT NOT NULL,
	PGTO_RES_RES_ID_INT			INT NOT NULL,
	PGTO_RES_ST_PGTO_ID_INT		INT NOT NULL,
	PGTO_RES_EXCLUIDO_BIT		BIT NOT NULL

	--PK
	CONSTRAINT PK_PGTO_RES_ID_INT PRIMARY KEY(PGTO_RES_ID_INT)

	--FK
	CONSTRAINT FK_PGTO_RES_PGTO_ID_INT FOREIGN KEY (PGTO_RES_PGTO_ID_INT)
	REFERENCES PAGAMENTO(PGTO_ID_INT),

	CONSTRAINT FK_PGTO_RES_RES_ID_INT FOREIGN KEY(PGTO_RES_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT),

	CONSTRAINT FK_PGTO_RES_ST_PGTO_ID_INT FOREIGN KEY(PGTO_RES_ST_PGTO_ID_INT)
	REFERENCES STATUS_PAGAMENTO(ST_PGTO_ID_INT)
);



/****************************************************************************************************************************************
Tabela intermediária que armazena as informações de pagamento e reserva feitas de um hospede à pousada ao realizar o check-out. Possui as
chaves estrangeiras de PAGAMENTO, RESERVA e STATUS_PAGAMENTO.
****************************************************************************************************************************************/
DROP TABLE IF EXISTS PAGAMENTO_CHECK_OUT;
CREATE TABLE PAGAMENTO_CHECK_OUT
(
	PGTO_COUT_ID_INT				INT NOT NULL IDENTITY(1,1),
	PGTO_COUT_PGTO_ID_INT			INT NOT NULL,
	PGTO_COUT_RES_ID_INT			INT NOT NULL,
	PGTO_COUT_ST_PGTO_ID_INT		INT NOT NULL,
	PGTO_COUT_CHECK_OUT_ID_INT		INT NOT NULL,
	PGTO_COUT_EXCLUIDO_BIT			BIT NOT NULL

	--PK
	CONSTRAINT PK_PGTO_COUT_ID_IN PRIMARY KEY(PGTO_COUT_ID_INT)

	--FK
	CONSTRAINT FK_PGTO_COUT_PGTO_ID_INT FOREIGN KEY (PGTO_COUT_PGTO_ID_INT)
	REFERENCES PAGAMENTO(PGTO_ID_INT),

	CONSTRAINT FK_PGTO_COUT_RES_ID_INT FOREIGN KEY(PGTO_COUT_RES_ID_INT)
	REFERENCES RESERVA(RES_ID_INT),

	CONSTRAINT FK_PGTO_COUT_ST_PGTO_ID_INT FOREIGN KEY(PGTO_COUT_ST_PGTO_ID_INT)
	REFERENCES STATUS_PAGAMENTO(ST_PGTO_ID_INT),

	CONSTRAINT FK_PGTO_COUT_CHECK_OUT_ID_INT FOREIGN KEY(PGTO_COUT_CHECK_OUT_ID_INT)
	REFERENCES CHECKOUT(CHECKOUT_ID_INT)
);