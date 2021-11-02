USE RECPAPAGAIOS;
GO

ALTER PROCEDURE [dbo].[uspCadastrarReserva]
	 @IdHospede		int
	,@Chale			int
	,@Pagamento		int
	,@DataCheckIn	date
	,@DataCheckOut	date
	,@Acompanhantes	int
	,@Json	varchar(max)
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para cadastro de reservas.
Data.....: 26/09/2021

2021-11-02: Correções #01
Validação que verifica se o check-in e check-out serão feitos no mesmo dia. Em caso positivo, é adicionado um dia a mais na data de
check-out, para que, no DATEDIFF, a diferença de dias seja um, e não zero.

2021-11-02: Correções #02
No caso da aplicação web, será passado, por padrão, id de pagamento 7. Nesse caso, o status será 3, ou seja, não autorizado. Isso
poderá ser corrigido atualizando a reserva por aplicação desktop.
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem			varchar(255);
		DECLARE @Entidade			varchar(255);
		DECLARE @Acao				varchar(255);
		DECLARE @Codigo				int;
		DECLARE @Acomodacao			int;
		DECLARE @ChaleOcupado		int;
		DECLARE @StatusPagamento	int;
		DECLARE @IdReserva			int;
		DECLARE @ValorAcomodacao	float(2);
		DECLARE @ValorTotal			float(2);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para cadastro de reserva.';
		
		SET @Entidade	= 'Reserva';

		SET @Acao		= 'Cadastrar';

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

		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '----------------------------------------------- CADASTRO DE RESERVAS ------------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';
/*************************************************************************************************************************************
INÍCIO: Validação geral dos dados:
*************************************************************************************************************************************/
		IF @IdHospede IS NULL OR @IdHospede = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'O id do hóspede não pode estar vazio.';
		END;

		IF @Chale IS NULL OR @Chale = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'É necessário selecionar um chalé.';
		END;

		IF @Pagamento IS NULL OR @Pagamento = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'É necessário selecionar uma forma de pagamento.';
		END;

		IF @DataCheckIn IS NULL OR @DataCheckIn = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'A data de check-in está ínválida.';
		END;

		IF @DataCheckOut IS NULL OR @DataCheckOut = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'A data de check-out está ínválida.';
		END;

		IF @Acompanhantes IS NULL OR @Acompanhantes = ''
		BEGIN
			SET @Codigo = 422;
			SET @Mensagem = 'O número de acompanhantes está inválido.';
		END;

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@StatusCode	= @Codigo;
/*************************************************************************************************************************************
FIM: Validação geral dos dados.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o hóspede está cadastrado no sistema:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'Não há hóspede cadastrado com o id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se ambos os dias do check-in ou dia do check-out são menores do que o dia atual:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND @DataCheckIn < CAST(GETDATE() AS DATE) OR @DataCheckOut < CAST(GETDATE() AS DATE)
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'As data de check-in e check-out não podem ser menores do que o dia atual.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se o dia do check-in está a mais de 3 dias de distância do dia em que a reserva está sendo realizada:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND @DataCheckIn > DATEADD(DAY, 3, GETDATE())
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'A data de check-in selecionada está a mais do que 3 dias de hoje. ' +
								'Em casos assim, deve-se contatar a Pousada para realizar a reserva.'

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se o dia do check-in é maior que o dia do check-out:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND @DataCheckIn > @DataCheckOut
		BEGIN
			SET @Codigo = 422;
			SET	@Mensagem = 'A data de check-out é maior do que a data de check-in.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Verificando se, no período selecionado pelo usuário para fazer a reserva, a acomodação está disponível.
*************************************************************************************************************************************/
		IF  @Mensagem IS NULL
			AND
			(
				SELECT		TOP 1 1
				FROM		RESERVA  AS R
				LEFT JOIN	CHECKIN  AS CI ON R.RES_ID_INT		= CI.CHECKIN_RES_ID_INT
				LEFT JOIN	CHECKOUT AS CO ON CI.CHECKIN_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
				WHERE		RES_ACO_ID_INT = @Chale
				AND			RES_DATA_CHECKIN_DATE BETWEEN @DataCheckIn AND @DataCheckOut
				AND			RES_EXCLUIDO_BIT = 0
			)
		IS NOT NULL
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'Esse chalé está ocupado no período selecionado.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END
		ELSE
			BEGIN
				PRINT 'Nesse período, não há reservas confirmadas.';
			END;

/*************************************************************************************************************************************
Validações da forma de pagamento:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL AND (SELECT 1 FROM TIPO_PAGAMENTO WHERE TPPGTO_ID_INT = @Pagamento) IS NULL
			BEGIN
				SET @Codigo = 404;
				SET @Mensagem = 'A forma de pagamento selecionada é inválida.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		ELSE
			BEGIN
				IF @Pagamento = 1 OR @Pagamento = 2
					BEGIN
						SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 1);
					END;
				ELSE
					IF @Pagamento = 3 OR @Pagamento = 4 OR @Pagamento = 5 OR @Pagamento = 6
					BEGIN
						SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 4);
					END;

				-- 2021-11-02: Correções #02
				IF @Pagamento = 7
				BEGIN
					SET @StatusPagamento = (SELECT ST_PGTO_ID_INT FROM STATUS_PAGAMENTO WHERE ST_PGTO_ID_INT = 3);
				END;

				PRINT 'Forma de pagamento selecionada: ' + CAST(@Pagamento AS VARCHAR) + ' e o status é: '
				+ CAST(@StatusPagamento AS VARCHAR)
			END;

/*************************************************************************************************************************************
Validação da acomodação e do número de acompanhantes, e, a partir disso, calculo da reserva:
*************************************************************************************************************************************/
		IF	@Mensagem IS NULL 
			AND
			(
				SELECT 1 FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0
			)
			IS NULL
			BEGIN
				SET @Codigo = 422;
				SET @Mensagem = 'A acomodação selecionada está inválida.';

				EXEC [dbo].[uspGravarLog]
				@Json		= @Json,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@StatusCode	= @Codigo;
			END;
		ELSE
			BEGIN

				SELECT @Acomodacao = ACO_INFO_ACOMOD_ID_INT FROM ACOMODACAO WHERE ACO_ID_INT = @Chale AND ACO_EXCLUIDO_BIT = 0

				IF @Acompanhantes > 4
					BEGIN
						SET @Codigo = 422;
						SET @Mensagem = 'O número máximo de acompanhantes permitidos é quatro.';

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@StatusCode	= @Codigo;
					END;
				ELSE
					BEGIN

						IF @Acompanhantes > 2 AND @Acomodacao = 2
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Superior e Master comportam, apenas, 3 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						IF @Acompanhantes > 2 AND @Acomodacao = 3
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Superior e Master comportam, apenas, 3 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						ELSE
							IF @Acompanhantes > 3 AND @Acomodacao = 1
							BEGIN
								SET @Codigo = 409;
								SET @Mensagem = 'Acomodações Standard comportam, apenas, 4 pessoas.';

								EXEC [dbo].[uspGravarLog]
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@StatusCode	= @Codigo;
							END;
						ELSE
							BEGIN

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

								-- 2021-	11-02: Correções #01
								IF @DataCheckIn = @DataCheckOut
									BEGIN

										DECLARE @DataCheckOutValida DATETIME = DATEADD(DAY, 1, CAST(@DataCheckOut AS DATE));

										SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOutValida, @Acompanhantes);

									END;
								ELSE
									BEGIN

										SET @ValorTotal = dbo.CalcularValorDaReserva(@ValorAcomodacao, @DataCheckIn, @DataCheckOut, @Acompanhantes);

									END;

								PRINT 'Acomodacao selecionada: Chalé ' + CAST(@Chale AS VARCHAR);
								PRINT 'Valor total da reserva: R$ ' + CAST(@ValorTotal AS VARCHAR) + '.';

							END;
					END;
			END;

/*************************************************************************************************************************************
********************************************************** INSERINDO NAS TABELAS *****************************************************
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela RESERVA:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			BEGIN TRANSACTION;

				BEGIN TRY

					INSERT INTO RESERVA
					VALUES
					(
						GETDATE(),
						@DataCheckIn,
						@DataCheckOut,
						@ValorTotal,
						1,
						@IdHospede,
						@Chale,
						@Acompanhantes,
						0,
						GETDATE()
					);

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
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

			SET @IdReserva = @@IDENTITY;
/*************************************************************************************************************************************
FIM: Inserindo na tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Inserindo na tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;
		
					BEGIN TRY

						INSERT INTO [RECPAPAGAIOS].[dbo].[PAGAMENTO_RESERVA]
						VALUES
						(
							@Pagamento,
							@IdReserva,
							@StatusPagamento,
							0,
							GETDATE()
						);

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
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Inserindo na tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/
		
/*************************************************************************************************************************************
INÍCIO: Atualizando na tabela ACOMODACAO:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	[RECPAPAGAIOS].[dbo].[ACOMODACAO]
						SET
								ACO_ST_ACOMOD_INT = 1
						WHERE	ACO_ID_INT = @Chale;

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
						@StatusCode	= @Codigo;

					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Atualizando na tabela ACOMODACAO.
*************************************************************************************************************************************/
		END;
/*************************************************************************************************************************************
********************************************************** INSERINDO NAS TABELAS *****************************************************
*************************************************************************************************************************************/
		PRINT '---------------------------------------------------------------------------------------------------------------------';
		PRINT '----------------------------------------------- CADASTRO DE RESERVAS ------------------------------------------------';
		PRINT '---------------------------------------------------------------------------------------------------------------------';

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 201;
			SET @Mensagem = 'Reserva cadastrada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR) + '.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
	END
GO