/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA ATUALIZAR ACOMODAÇÕES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspAtualizarAcomodacao]
	 @IdAcomodacao	int
	,@Nome			varchar(100)
	,@Categoria		int
	,@Capacidade	int
	,@Tamanho		float(2)
	,@TipoDeCama	varchar(200)
	,@Preco			float(2)
	,@Json			varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de acomodações (no momento, apenas na API).
Data.....: 27/10/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(max) = 'Início da análise para atualização do Chalé ' + CAST(@IdAcomodacao AS VARCHAR) + '.';
		DECLARE @Entidade	varchar(50)  = 'Acomodação';
		DECLARE @Acao		varchar(50)  = 'Atualizar';
		DECLARE @Codigo		int			 = 0;

/*********************************************************************************************************************************
Log de início:
*********************************************************************************************************************************/		
		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdAcomodacao,
		@StatusCode	= @Codigo;

		SET @Codigo   = NULL;
		SET @Mensagem = NULL;

/*********************************************************************************************************************************
Validando se a categoria informada está registrada no banco de dados:
*********************************************************************************************************************************/
		IF (SELECT 1 FROM INFORMACOES_ACOMODACAO WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'A categoria informada está inválida.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAcomodacao,
			@StatusCode	= @Codigo;
		END;

/*********************************************************************************************************************************
Validando se a capacidade informada está coerente com o cadastro de capacidade na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Capacidade <>
			   (
					SELECT INFO_ACOMOD_CAPACIDADE_INT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O capacidade informada está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o preço informado está coerente com o cadastro de preço na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Preco <>
			   (
					SELECT INFO_ACOMOD_PRECO_FLOAT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O preço informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o tamanho informado está coerente com o cadastro de tamanho na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Tamanho <>
			   (
					SELECT INFO_ACOMOD_METROS_QUADRADOS_FLOAT
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O tamanho informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
Validando se o tipe de cama informada está coerente com o cadastro de tipo de cama na categoria:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @TipoDeCama <>
			   (
					SELECT INFO_ACOMOD_TIPO_DE_CAMA_STR
					FROM INFORMACOES_ACOMODACAO
					WHERE INFO_ACOMOD_ID_INT = @Categoria AND INFO_ACOMOD_EXCLUIDO_BIT = 0
			   )
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O tipo de cama informado está divergente do permitido à categoria selecionada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdAcomodacao,
				@StatusCode	= @Codigo;
			END;
		END;

/*********************************************************************************************************************************
INÍCIO: Atualizando acomodação:
*********************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	ACOMODACAO
					SET
							 ACO_NOME_STR			= @Nome
							,ACO_INFO_ACOMOD_ID_INT = @Categoria
					WHERE	ACO_ID_INT = @IdAcomodacao;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdAcomodacao,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*********************************************************************************************************************************
FIM: Atualizando acomodação.
*********************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN

			SET @Codigo = 200;
			SET @Mensagem = 'Acomodação atualizada com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAcomodacao,
			@StatusCode	= @Codigo;

		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA ATUALIZAR ACOMODAÇÕES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA ATUALIZAR FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspAtualizarFNRH]
	 @IdFNRH			int
	,@Profissao			nvarchar(255)
	,@Nacionalidade		nvarchar(50)
	,@Sexo				nchar(1)
	,@Rg				nchar(9)
	,@ProximoDestino	nvarchar(255)
	,@UltimoDestino		nvarchar(255)
	,@MotivoViagem		nvarchar(255)
	,@MeioDeTransporte	nvarchar(255)
	,@PlacaAutomovel	nvarchar(255)
	,@NumAcompanhantes	int
	,@FNRHJson			nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de FNRHs (no momento, apenas na API).
Data.....: 26/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @IdHospede	INT;
		DECLARE @Codigo		INT;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para atualização de FNRH.';
		
		SET	@Entidade	= 'FNRH';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @FNRHJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdFNRH,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se já existe uma FNRH cadastrada com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FNRH WHERE FNRH_ID_INT = @IdFNRH AND FNRH_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não existe nenhuma FNRH cadastrada no sistema com o id ' + CAST(@IdFNRH AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFNRH,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Setando as variáveis como nulas, caso tenham encontrado com os valores vazios ou string:
*************************************************************************************************************************************/
		IF (@Profissao  = '' OR @Profissao = 'string')
		BEGIN
			SET @Profissao = NULL;
		END;

		IF (@Nacionalidade  = '' OR @Nacionalidade = 'string')
		BEGIN
			SET @Nacionalidade = NULL;
		END;

		IF (@Sexo  = '' OR @Sexo = 'string')
		BEGIN
			SET @Sexo = NULL;
		END;

		IF (@Rg  = '' OR @Rg = 'string')
		BEGIN
			SET @Rg = NULL;
		END;

		IF (@ProximoDestino  = '' OR @ProximoDestino = 'string')
		BEGIN
			SET @ProximoDestino = NULL;
		END;

		IF (@UltimoDestino  = '' OR @UltimoDestino = 'string')
		BEGIN
			SET @UltimoDestino = NULL;
		END;

		IF (@MotivoViagem  = '' OR @MotivoViagem = 'string')
		BEGIN
			SET @MotivoViagem = NULL;
		END;

		IF (@MeioDeTransporte  = '' OR @MeioDeTransporte = 'string')
		BEGIN
			SET @MeioDeTransporte = NULL;
		END;

		IF (@PlacaAutomovel  = '' OR @PlacaAutomovel = 'string')
		BEGIN
			SET @PlacaAutomovel = NULL;
		END;


/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela FNRH:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	FNRH
					SET
							 FNRH_PROFISSAO_STR				= @Profissao
							,FNRH_NACIONALIDADE_STR			= @Nacionalidade
							,FNRH_SEXO_CHAR					= @Sexo
							,FNRH_RG_CHAR					= @Rg
							,FNRH_PROXIMO_DESTINO_STR		= @ProximoDestino
							,FNRH_ULTIMO_DESTINO_STR		= @UltimoDestino
							,FNRH_MOTIVO_VIAGEM_STR			= @MotivoViagem
							,FNRH_MEIO_DE_TRANSPORTE_STR	= @MeioDeTransporte
							,FNRH_PLACA_AUTOMOVEL_STR		= @PlacaAutomovel
							,FNRH_NUM_ACOMPANHANTES_INT		= @NumAcompanhantes
					WHERE	FNRH_ID_INT = @IdFNRH;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SET @Codigo = ERROR_NUMBER();
					SET @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @FNRHJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdFNRH,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela FNRH.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'FNRH ' + CAST(@IdFNRH AS VARCHAR(8)) + ' atualizada com sucesso!'; 
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @FNRHJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFNRH,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA ATUALIZAR FNRHS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA ATUALIZAR FUNCIONÁRIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspAtualizarFuncionario]
	 @IdFuncionarioRota	int
	,@Nome				nvarchar(255)
	,@Cpf				nchar(11)
	,@Nacionalidade		nvarchar(255)
	,@DataDeNascimento	date
	,@Sexo				nchar(1)
	,@Rg				nchar(9)
	,@Cargo				nvarchar(50)
	,@Setor				nvarchar(50)
	,@Salario			float(2)
	,@Cep				nvarchar(255)
	,@Logradouro		nvarchar(255)
	,@Numero			nvarchar(8)
	,@Complemento		nvarchar(255)
	,@Bairro			nvarchar(255)
	,@Cidade			nvarchar(255)
	,@Estado			nvarchar(255)
	,@Pais				nvarchar(255)
	,@NomeUsuario		nvarchar(45)
	,@Senha				nvarchar(255)
	,@Email				nvarchar(50)
	,@Celular			nvarchar(13)
	,@Telefone			nvarchar(12)
	,@CategoriaAcesso	int
	,@Banco				nvarchar(50)
	,@Agencia			nvarchar(50)
	,@NumeroConta		nvarchar(50)
	,@PerguntaSeguranca nvarchar(255)
	,@RespostaSeguranca nvarchar(255)
	,@Json				varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de funcionários (no momento, apenas na API).
Data.....: 29/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @IdEndereco INT;
		DECLARE @IdContatos INT;
		DECLARE @IdUsuarios	INT;
		DECLARE @Codigo		INT;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para atualização de funcionário.';
		
		SET	@Entidade	= 'Funcionário';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdFuncionarioRota,
		@StatusCode	= 0;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM FUNCIONARIO WHERE FUNC_ID_INT = @IdFuncionarioRota AND FUNC_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não existe nenhum funcionário cadastrado no sistema com o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFuncionarioRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o nome de usuário da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO		U
					INNER JOIN	FUNCIONARIO F ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR				= @NomeUsuario
					AND			F.FUNC_USU_ID_INT					= @IdFuncionarioRota
				)
			IS NOT NULL
			BEGIN
				PRINT 'Encontrado o login ' + @NomeUsuario + ' para o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			END;
			
			
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO		U
					INNER JOIN	FUNCIONARIO F ON F.FUNC_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR				=  @NomeUsuario
					AND			F.FUNC_ID_INT						<> @IdFuncionarioRota
				)
			IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um usuário cadastrado com o nome de usuário ' + @NomeUsuario + '.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Verificando se já existe um funcionário cadastrado com o CPF da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT FUNC_CPF_CHAR FROM FUNCIONARIO WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_USU_ID_INT = @IdFuncionarioRota) IS NOT NULL
			BEGIN
				PRINT 'Encontrado o CPF ' + @CPF + ' para o id ' + CAST(@IdFuncionarioRota AS VARCHAR(8));
			END;
			
			
			IF (SELECT FUNC_CPF_CHAR FROM FUNCIONARIO WHERE FUNC_CPF_CHAR = @Cpf AND FUNC_ID_INT <> @IdFuncionarioRota) IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um funcionário cadastrado com o CPF ' + @Cpf + '.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Setando as variáveis @IdUsuarios, @IdEndereco e @IdContatos com o id do hóspede baseado no @IdFuncionarioRota:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = FUNC_END_ID_INT,
					@IdUsuarios = FUNC_USU_ID_INT,
					@IdContatos = FUNC_CONT_ID_INT
			FROM	FUNCIONARIO
			WHERE	FUNC_ID_INT = @IdFuncionarioRota AND FUNC_EXCLUIDO_BIT = 0;
		END;
/*************************************************************************************************************************************
Verificando se é possível encontrar registros com as chaves-estrangeiras obtidas de FUNCIONARIO:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de endereço cadastrado para o funcionário informado.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM USUARIO WHERE USU_ID_INT = @IdUsuarios AND USU_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de dados de usuário cadastrados para o funcionário informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de contatos cadastrado para o funcionário informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdFuncionarioRota,
				@StatusCode	= @Codigo;
			END;
		END;


		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ENDERECO:
*************************************************************************************************************************************/
			IF (@Complemento IS NULL) OR (@Complemento = '') OR (@Complemento = 'string')
				BEGIN
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = NULL,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;

			ELSE

				BEGIN;
			
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = @Complemento,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela DADOSBANCARIOS:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
					BEGIN TRY

						UPDATE	DADOSBANCARIOS
						SET
								 DADOSBC_BANCO_STR			= @Banco
								,DADOSBC_AGENCIA_STR		= @Agencia
								,DADOSBC_NUMERO_CONTA_STR	= @NumeroConta
						WHERE	DADOSBC_FUNC_ID_INT			= @IdFuncionarioRota;

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();
						
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						
						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdFuncionarioRota,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela DADOSBANCARIOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela USUARIO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN

				IF LEN(@NomeUsuario) > 0 AND LEN(@Senha) > 0
				BEGIN

					BEGIN TRANSACTION;
		
						BEGIN TRY

							UPDATE	USUARIO
							SET
									USU_LOGIN_CPF_CHAR	 = @Cpf,
									USU_NOME_USUARIO_STR = @NomeUsuario,
									USU_SENHA_STR		 = ENCRYPTBYPASSPHRASE('key', @Senha)
							WHERE	USU_ID_INT = @IdUsuarios;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;
							
							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @Json,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdFuncionarioRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
					BEGIN

						BEGIN TRANSACTION;

							BEGIN TRY
								
								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= NULL
								WHERE	CONT_ID_INT = @IdContatos;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();
								
								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;
								
								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdFuncionarioRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					
					END;

				ELSE

					BEGIN

						BEGIN TRANSACTION;
							
							BEGIN TRY

								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= @Telefone
								WHERE	CONT_ID_INT = @IdContatos;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();

								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;

								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdFuncionarioRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela FUNCIONARIO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN

				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	FUNCIONARIO
						SET
								 FUNC_NOME_STR			= @Nome
								,FUNC_CPF_CHAR			= @Cpf
								,FUNC_NACIONALIDADE_STR	= @Nacionalidade
								,FUNC_DTNASC_DATE		= @DataDeNascimento
								,FUNC_SEXO_CHAR			= @Sexo
								,FUNC_RG_CHAR			= @Rg
								,FUNC_CARGO_STR			= @Cargo
								,FUNC_SETOR_STR			= @Setor
								,FUNC_SALARIO_FLOAT		= @Salario
								,FUNC_CATACESSO_ID_INT	= @CategoriaAcesso
						WHERE	FUNC_ID_INT = @IdFuncionarioRota;

					END TRY

					BEGIN CATCH

						INSERT INTO LOGSERROS
						(
							 LOG_ERR_ERRORNUMBER_INT
							,LOG_ERR_ERRORSEVERITY_INT
							,LOG_ERR_ERRORSTATE_INT
							,LOG_ERR_ERRORPROCEDURE_VARCHAR
							,LOG_ERR_ERRORLINE_INT
							,LOG_ERR_ERRORMESSAGE_VARCHAR
							,LOG_ERR_DATE
						)
						SELECT
							 ERROR_NUMBER()
							,ERROR_SEVERITY()
							,ERROR_STATE()
							,ERROR_PROCEDURE()
							,ERROR_LINE()
							,ERROR_MESSAGE()
							,GETDATE();

						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;

						SELECT @Mensagem = ERROR_MESSAGE();

						SELECT @Codigo = ERROR_NUMBER();
						SELECT @Mensagem = ERROR_MESSAGE();

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdFuncionarioRota,
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela FUNCIONARIO.
*************************************************************************************************************************************/
		END;


/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Funcionário com id ' + CAST(@IdFuncionarioRota AS VARCHAR(8)) + ' atualizado com sucesso.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdFuncionarioRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;

GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA ATUALIZAR FUNCIONÁRIOS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA ATUALIZAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspAtualizarHospede]
	 @IdHospedeRota		char(11)
	,@NomeCompleto		nvarchar(255)
	,@Cpf				char(11)
	,@DataDeNascimento	date
	,@Email				nvarchar(50)
	,@Celular			nvarchar(13)
	,@Telefone			nvarchar(12)
	,@NomeUsuario		nvarchar(45)
	,@Senha				nvarchar(255)
	,@Cep				nvarchar(255)
	,@Logradouro		nvarchar(255)
	,@Numero			nvarchar(8)
	,@Complemento		nvarchar(255)
	,@Bairro			nvarchar(255)
	,@Cidade			nvarchar(255)
	,@Estado			nvarchar(255)
	,@Pais				nvarchar(255)
	,@HospedeJson		nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de hóspedes (no momento, apenas na API).
Data.....: 22/08/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	VARCHAR(255);
		DECLARE @Entidade	VARCHAR(50);
		DECLARE @Acao		VARCHAR(50);
		DECLARE @Codigo		INT;
		DECLARE @IdEndereco INT;
		DECLARE @IdContatos INT;
		DECLARE @IdUsuarios	INT;
		DECLARE @NomeUsu	VARCHAR(80);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;

		SET @Mensagem	= 'Início da análise para atualização de hóspede.';
		
		SET	@Entidade	= 'Hóspede';

		SET @Acao		= 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @HospedeJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdHospedeRota,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se já existe um hóspede cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospedeRota AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET	@Mensagem = 'Não existe nenhum hóspede cadastrado no sistema com o id ' + @IdHospedeRota;
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @HospedeJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospedeRota,
			@StatusCode	= @Codigo;
		END;
/*************************************************************************************************************************************
Verificando se já existe um hóspede cadastrado com o nome de usuário da entrada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO	U
					INNER JOIN	HOSPEDE H ON H.HSP_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR			= @NomeUsuario
					AND			H.HSP_USU_ID_INT				= @IdHospedeRota
				)
			IS NOT NULL
			BEGIN
				
				PRINT 'Encontrado o login ' + @NomeUsuario + ' para o id ' + @IdHospedeRota;

			END;
			
			
			IF	(
					SELECT		U.USU_NOME_USUARIO_STR
					FROM		USUARIO	U
					INNER JOIN	HOSPEDE H ON H.HSP_USU_ID_INT	= U.USU_ID_INT
					WHERE		U.USU_NOME_USUARIO_STR			=  @NomeUsuario
					AND			H.HSP_ID_INT					<> @IdHospedeRota
				)
			IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET	@Mensagem = 'Já existe um hóspede cadastrado com o nome de usuário ' + @NomeUsuario + '.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;
		END;
/*************************************************************************************************************************************
Setando as variáveis @IdHospede, @IdEndereco com o id do hóspede baseado no @IdHospedeRota.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = HSP_END_ID_INT,
					@IdUsuarios = HSP_USU_ID_INT,
					@IdContatos = HSP_CONT_ID_INT
			FROM	HOSPEDE
			WHERE	HSP_ID_INT = @IdHospedeRota AND HSP_EXCLUIDO_BIT = 0;
		END;
/*************************************************************************************************************************************
Verificando se é possível encontrar registros com as chaves-estrangeiras obtidas de HOSPEDE.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de endereço cadastrado para o hóspede informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;

			IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET	@Mensagem = 'Não existe nenhum registro de contatos cadastrado para o hóspede informado.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @HospedeJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro	= @IdHospedeRota,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN -- ATUALIZANDO TABELAS

			IF (@Complemento IS NULL) OR (@Complemento = '') OR (@Complemento = 'string')
				BEGIN
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = NULL,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= 500;

							RAISERROR(@Mensagem, 20, -1) WITH LOG;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
			ELSE
				BEGIN;
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_CEP_CHAR		= @Cep,
									END_LOGRADOURO_STR	= @Logradouro,
									END_NUMERO_CHAR		= @Numero,
									END_COMPLEMENTO_STR = @Complemento,
									END_CIDADE_STR		= @Cidade,
									END_BAIRRO_STR		= @Bairro,
									END_ESTADO_CHAR		= @Estado,
									END_PAIS_STR		= @Pais
							WHERE	END_ID_INT = @IdEndereco;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela USUARIO.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL AND @IdUsuarios IS NOT NULL
			BEGIN

				IF LEN(@NomeUsuario) > 0 AND LEN(@Senha) > 0
				BEGIN

					BEGIN TRANSACTION;
		
						BEGIN TRY

							UPDATE	USUARIO
							SET
									USU_LOGIN_CPF_CHAR	 = @Cpf,
									USU_NOME_USUARIO_STR = @NomeUsuario,
									USU_SENHA_STR		 = ENCRYPTBYPASSPHRASE('key', @Senha)
							WHERE	USU_ID_INT = @IdUsuarios;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();
							
							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;
							
							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @HospedeJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro	= @IdHospedeRota,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;
					
				END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN

				IF (@Telefone IS NULL) OR (@Telefone = '') OR (@Telefone = 'string')
					BEGIN


						BEGIN TRANSACTION

							BEGIN TRY
								
								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= NULL
								WHERE	CONT_ID_INT = @IdContatos;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();
								
								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;
								
								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @HospedeJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospedeRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					END
				ELSE
					BEGIN
						BEGIN TRANSACTION;
							
							BEGIN TRY

								UPDATE	CONTATOS
								SET
										CONT_EMAIL_STR		= @Email,
										CONT_CELULAR_CHAR	= @Celular,
										CONT_TELEFONE_CHAR	= @Telefone
								WHERE	CONT_ID_INT = @IdContatos;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();

								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;

								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @HospedeJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospedeRota,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;
					END;

			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela HOSPEDE.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
				BEGIN TRY
					
					UPDATE	HOSPEDE
					SET
							HSP_NOME_STR	= @NomeCompleto,
							HSP_CPF_CHAR	= @Cpf,
							HSP_DTNASC_DATE	= @DataDeNascimento
					WHERE	HSP_ID_INT = @IdHospedeRota;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();
					
					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;
					
					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @HospedeJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdHospedeRota,
					@StatusCode	= @Codigo;

				END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;

			END;

		END; -- ATUALIZANDO TABELAS
/*************************************************************************************************************************************
FIM: Atualizando na tabela HOSPEDE.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Hóspede com id ' + CAST(@IdHospedeRota AS VARCHAR(8)) + ' atualizado com sucesso.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @HospedeJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospedeRota,
			@StatusCode	= @Codigo;
		END
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
4 - PROCEDURE UTILIZADA PARA ATUALIZAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA ATUALIZAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspAtualizarReserva]
	 @IdReserva		int
	,@Chale			int
	,@Pagamento		int
	,@DataCheckIn	date
	,@DataCheckOut	date
	,@Acompanhantes	int
	,@ReservaJson	nvarchar(600)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para atualização de reservas (no momento, apenas na API).
Data.....: 20/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);
		DECLARE @DescricaoPagamento		nvarchar(50);
		DECLARE @IdReservaCadastrada	int;
		DECLARE @IdReservaCheckIn		int;
		DECLARE @IdStatusPagamento		int;
		DECLARE @IdAcomodacao			int;
		DECLARE @TipoPagamento			int;
		DECLARE @Acomodacao				int;
		DECLARE @StatusPagamento		int;
		DECLARE @Codigo					int;
		DECLARE @ValorAcomodacao		float(2);
		DECLARE @ValorTotal				float(2);
		DECLARE @DataCheckInReserva		date;
		DECLARE @DataCheckOutReserva	date;


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'Início da análise para atualização de reserva.';
		
		SET @Entidade = 'Reserva';

		SET @Acao	  = 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @ReservaJson,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdReserva,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
SELECT principal que busca as informações que serão, futuramente, validadas:
*************************************************************************************************************************************/
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@IdReservaCheckIn		= CI.CHECKIN_RES_ID_INT
					,@IdAcomodacao			= R.RES_ACO_ID_INT
					,@TipoPagamento			= PR.PGTO_RES_TPPGTO_ID_INT
					,@IdStatusPagamento		= PGTO_RES_ST_PGTO_ID_INT
					,@IdAcomodacao			= R.RES_ACO_ID_INT
					,@DataCheckInReserva	= R.RES_DATA_CHECKIN_DATE
					,@DataCheckOutReserva	= R.RES_DATA_CHECKOUT_DATE
		FROM		RESERVA					AS R
		LEFT JOIN	PAGAMENTO_RESERVA		AS PR ON R.RES_ID_INT = PR.PGTO_RES_RES_ID_INT
		LEFT JOIN	CHECKIN					AS CI ON R.RES_ID_INT = CI.CHECKIN_RES_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;

/*************************************************************************************************************************************
Verificando se a reserva existe na base de dados:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não há reserva com o id ' + CAST(@IdReserva AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @ReservaJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Validando se a atualização está sendo realizada antes da data de check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF CAST(GETDATE() AS date) > @DataCheckInReserva
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'Não é possível atualizar uma reserva que já passou da data de check-in.';
				
				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a reserva possui check-in:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdReservaCheckIn IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' possui check-in.' +
								' Não é possível alterar reservas com check-in.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando qual a forma de pagamento da reserva -- caso seja igual a dinheiro (1) ou débido (2), não será possível alterar a reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @DescricaoPagamento = TPPGTO_TIPO_PAGAMENTO_STR FROM TIPO_PAGAMENTO WHERE TPPGTO_ID_INT = @TipoPagamento;

			IF @TipoPagamento = 1 OR @TipoPagamento = 2
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'O tipo de pagamento é igual a dinheiro e cartão de débito. ' +
								'Portanto, não é possível alterar as informações dessa reserva.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Caso o pagamento seja diferente de dinheiro (1) e débito (2), será validado o status do pagamento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdStatusPagamento = 1 OR @IdStatusPagamento = 4
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'O pagamento da reserva está aprovado ou em processamento. Portanto, não é possível atualizar a reserva.'

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a acomodação escolhida está disponível do período informado, caso a acomodação seja diferente da acomodação já regis-
trada na reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @IdAcomodacao <> @Chale
			BEGIN

				IF  (
						SELECT		TOP 1 1
						FROM		RESERVA	 R
						LEFT JOIN	CHECKIN  CI ON R.RES_ID_INT			= CI.CHECKIN_RES_ID_INT
						LEFT JOIN	CHECKOUT CO ON CI.CHECKIN_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
						WHERE		RES_ACO_ID_INT = @Chale
						AND			RES_DATA_CHECKIN_DATE BETWEEN @DataCheckIn AND @DataCheckOut
						AND			RES_EXCLUIDO_BIT = 0
					)
				IS NOT NULL
				BEGIN
					SET @Codigo = 409;
					SET @Mensagem = 'A acomodação selecionada está indisponível no período selecionado.';

					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a data de check-in está sendo escolhida para mais de três dias:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataCheckIn <> @DataCheckInReserva
			BEGIN

				IF @DataCheckIn > DATEADD(DAY, 3, GETDATE())
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A data de check-in selecionada está a mais do que 3 dias de hoje. ' +
									'Em casos assim, deve-se contatar a Pousada para realizar a reserva.'

					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;
			END;
		END;

/*************************************************************************************************************************************
Verificando se a data de check-in é menor que a data de check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @DataCheckIn <> @DataCheckInReserva
			BEGIN
				
				IF @DataCheckIn > @DataCheckOutReserva
				BEGIN
					SET @Codigo = 422;
					SET @Mensagem = 'A data de check-in não pode ser maior que a data de check-out primeiramente cadastrada.'
					
					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END;

				IF @DataCheckOut <> @DataCheckOutReserva
				BEGIN

					IF @DataCheckIn > @DataCheckOut
					BEGIN
						SET @Codigo = 422;
						SET @Mensagem = 'A data de check-in não pode ser maior que a data de check-out.';

						EXEC [dbo].[uspGravarLog]
						@Json		= @ReservaJson,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro = @IdReserva,
						@StatusCode	= @Codigo;
					END;
				END;
			END;
		END;
		
/*************************************************************************************************************************************
Validando a quantidade de acompanhantes:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Acompanhantes > 3
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'O número de acompanhantes não pode ser maior do que 3.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @ReservaJson,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;
		
/*************************************************************************************************************************************
Atualizando o preço da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT @Acomodacao = ACO_INFO_ACOMOD_ID_INT FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0;
			
			IF @Acomodacao = 1
				BEGIN

					SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
					FROM	INFORMACOES_ACOMODACAO
					WHERE	INFO_ACOMOD_ID_INT = @Acomodacao;
				
				END;

			ELSE
			
			IF @Acomodacao = 2
				BEGIN

					SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
					FROM	INFORMACOES_ACOMODACAO
					WHERE	INFO_ACOMOD_ID_INT = @Acomodacao
				
				END;
			
			ELSE

				BEGIN

					SELECT	@ValorAcomodacao = INFO_ACOMOD_PRECO_FLOAT
					FROM	INFORMACOES_ACOMODACAO
					WHERE	INFO_ACOMOD_ID_INT = @Acomodacao
				
				END;

			SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOut, @Acompanhantes);
		END;

/*************************************************************************************************************************************
Atualizando o preço da reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF @Pagamento = 1 OR @Pagamento = 2
				BEGIN

					SET @StatusPagamento = 1;

				END;

			ELSE
				
				BEGIN

					SET @StatusPagamento = 4;

				END;
		END;


/*************************************************************************************************************************************
******************************************************** ATUALIZANDO TABELAS *********************************************************
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							 RES_DATA_CHECKIN_DATE		= @DataCheckIn
							,RES_DATA_CHECKOUT_DATE		= @DataCheckOut
							,RES_VALOR_RESERVA_FLOAT	= @ValorTotal
							,RES_ACO_ID_INT				= @Chale
							,RES_ACOMPANHANTES_ID_INT	= @Acompanhantes
					WHERE	RES_ID_INT = @IdReserva;

				END TRY

				BEGIN CATCH

					INSERT INTO LOGSERROS
					(
						 LOG_ERR_ERRORNUMBER_INT
						,LOG_ERR_ERRORSEVERITY_INT
						,LOG_ERR_ERRORSTATE_INT
						,LOG_ERR_ERRORPROCEDURE_VARCHAR
						,LOG_ERR_ERRORLINE_INT
						,LOG_ERR_ERRORMESSAGE_VARCHAR
						,LOG_ERR_DATE
					)
					SELECT
						 ERROR_NUMBER()
						,ERROR_SEVERITY()
						,ERROR_STATE()
						,ERROR_PROCEDURE()
						,ERROR_LINE()
						,ERROR_MESSAGE()
						,GETDATE();

					IF @@TRANCOUNT > 0
						ROLLBACK TRANSACTION;

					SELECT @Codigo = ERROR_NUMBER();
					SELECT @Mensagem = ERROR_MESSAGE();

					EXEC [dbo].[uspGravarLog]
					@Json		= @ReservaJson,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;
/*************************************************************************************************************************************
FIM: Atualizando na tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ACOMODACAO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @Chale <> @IdAcomodacao
				BEGIN

					/************************************************************************************************************************
					* Atualizando a acomodação anterior como disponível:
					************************************************************************************************************************/
					IF	(
							SELECT		TOP 1 1
							FROM		RESERVA AS R
							INNER JOIN	ACOMODACAO AS A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
							WHERE A.ACO_ID_INT = @IdAcomodacao
							  AND R.RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						)
					IS NULL
					BEGIN

						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	ACOMODACAO
								SET
										ACO_ST_ACOMOD_INT	= 3
								WHERE	ACO_ID_INT			= @IdAcomodacao;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();

								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;

								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @ReservaJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro = @IdReserva,
								@StatusCode	= @Codigo;
							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END;


					/************************************************************************************************************************
					* Atualizando a acomodação atual como ocupada:
					************************************************************************************************************************/
					IF	(
							SELECT		TOP 1 1
							FROM		RESERVA AS R
							INNER JOIN	ACOMODACAO AS A ON R.RES_ACO_ID_INT = A.ACO_ID_INT
							WHERE A.ACO_ID_INT = @Chale
							  AND R.RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						)
					IS NULL
					BEGIN

						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	ACOMODACAO
								SET
										ACO_ST_ACOMOD_INT	= 1
								WHERE	ACO_ID_INT			= @Chale;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();

								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;

								SELECT @Codigo = ERROR_NUMBER();
								SELECT @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @ReservaJson,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro = @IdReserva,
								@StatusCode	= @Codigo;
							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END;
				END;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ACOMODACAO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF @Pagamento <> @TipoPagamento
				BEGIN

					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	PAGAMENTO_RESERVA
							SET
									 PGTO_RES_TPPGTO_ID_INT		= @Pagamento
									,PGTO_RES_ST_PGTO_ID_INT	= @StatusPagamento
							WHERE	PGTO_RES_RES_ID_INT			= @IdReserva;

						END TRY

						BEGIN CATCH

							INSERT INTO LOGSERROS
							(
								 LOG_ERR_ERRORNUMBER_INT
								,LOG_ERR_ERRORSEVERITY_INT
								,LOG_ERR_ERRORSTATE_INT
								,LOG_ERR_ERRORPROCEDURE_VARCHAR
								,LOG_ERR_ERRORLINE_INT
								,LOG_ERR_ERRORMESSAGE_VARCHAR
								,LOG_ERR_DATE
							)
							SELECT
								 ERROR_NUMBER()
								,ERROR_SEVERITY()
								,ERROR_STATE()
								,ERROR_PROCEDURE()
								,ERROR_LINE()
								,ERROR_MESSAGE()
								,GETDATE();

							IF @@TRANCOUNT > 0
								ROLLBACK TRANSACTION;

							SELECT @Codigo = ERROR_NUMBER();
							SELECT @Mensagem = ERROR_MESSAGE();

							EXEC [dbo].[uspGravarLog]
							@Json		= @ReservaJson,
							@Entidade	= @Entidade,
							@Mensagem	= @Mensagem,
							@Acao		= @Acao,
							@IdCadastro = @IdReserva,
							@StatusCode	= @Codigo;
						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
******************************************************** ATUALIZANDO TABELAS *********************************************************
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Reserva atualizada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= @ReservaJson,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdReserva,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
5 - PROCEDURE UTILIZADA PARA ATUALIZAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA ATUALIZAR SENHA
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspDefinirNovaSenha]
	 @Cpf				nchar(11)
	,@NovaSenha			nvarchar(200)
	,@RepeticaoSenha	nvarchar(200)
	,@Json				nvarchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada, na aplicação desktop, para atualizar a senha do usuário, no processo de "Esqueci Minha Senha".
Data.....: 23/09/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	nvarchar(max);
		DECLARE @Entidade	nvarchar(50);
		DECLARE @Acao		nvarchar(50);
		DECLARE @Codigo		int;
		DECLARE @IdUsuario	int;


/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'Início da análise para atualização de senha.';
		
		SET @Entidade = 'Usuário';

		SET @Acao	  = 'Atualizar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/


/*************************************************************************************************************************************
SELECT principal que atribui valor às variáveis:
*************************************************************************************************************************************/
		SELECT		@IdUsuario = USU_ID_INT
		FROM		FUNCIONARIO AS F
		INNER JOIN	USUARIO		AS U ON F.FUNC_USU_ID_INT = U.USU_ID_INT
		WHERE		F.FUNC_CPF_CHAR			= @Cpf
		  AND		U.USU_LOGIN_CPF_CHAR	= @Cpf;
		
/*************************************************************************************************************************************
INÍCIO: Validação dos dados de entrada:
*************************************************************************************************************************************/
		IF @IdUsuario IS NOT NULL
			BEGIN

				IF @NovaSenha = @RepeticaoSenha
					BEGIN

					/*****************************************************************************************************************
					* INÍCIO: Atualizando tabela de USUARIO:
					*****************************************************************************************************************/
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE USUARIO
								SET
										USU_SENHA_STR = ENCRYPTBYPASSPHRASE('key', @NovaSenha)
								WHERE	USU_ID_INT = @IdUsuario;

							END TRY

							BEGIN CATCH

								INSERT INTO LOGSERROS
								(
									 LOG_ERR_ERRORNUMBER_INT
									,LOG_ERR_ERRORSEVERITY_INT
									,LOG_ERR_ERRORSTATE_INT
									,LOG_ERR_ERRORPROCEDURE_VARCHAR
									,LOG_ERR_ERRORLINE_INT
									,LOG_ERR_ERRORMESSAGE_VARCHAR
									,LOG_ERR_DATE
								)
								SELECT
									 ERROR_NUMBER()
									,ERROR_SEVERITY()
									,ERROR_STATE()
									,ERROR_PROCEDURE()
									,ERROR_LINE()
									,ERROR_MESSAGE()
									,GETDATE();
								
								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION;

								SELECT @Codigo = ERROR_NUMBER(), @Mensagem = ERROR_MESSAGE();

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

						SET @Mensagem = 'Senha atualizada com sucesso.';
						SET @Codigo = 200;

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END;
					/*****************************************************************************************************************
					* FIM: Atualizando tabela de USUARIO.
					*****************************************************************************************************************/

				ELSE

					BEGIN

						SET @Mensagem = 'As senhas informadas não correspondem.';
						SET @Codigo = 422;

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;

					END;

			END;

		ELSE
			
			BEGIN

				SET @Mensagem = 'Usuário não encontrado no sistema. Por favor, contatar o Suporte.'
				SET @Codigo = 404;

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;

			END;
/*************************************************************************************************************************************
FIM: Validação dos dados de entrada.
*************************************************************************************************************************************/
		
		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
6 - PROCEDURE UTILIZADA PARA ATUALIZAR SENHA
**************************************************************************************************************************************
*************************************************************************************************************************************/