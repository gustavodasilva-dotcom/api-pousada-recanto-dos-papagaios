/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA DELETAR ALERTAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspDeletarAlerta]
	 @IdAlerta	int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para excluir alertas.
Data.....: 15/10/2021
*************************************************************************************************************************************/
		SET NOCOUNT ON;

/*************************************************************************************************************************************
Declaração de variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem	varchar(200);
		DECLARE @Json		varchar(200);
		DECLARE @Entidade	varchar(50);
		DECLARE @Acao		varchar(50);
		DECLARE @Codigo		int;

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo		= 0;
		
		SET @Mensagem	= 'Início da análise para deleção de alertas.';
		
		SET @Json		= 'Solicitação de deleção do alerta ' + CAST(@IdAlerta AS VARCHAR) + '.';

		SET @Entidade	= 'Alertas';

		SET @Acao		= 'Cadastrar';

		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro = @IdAlerta,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se o id corresponde a um alerta na base de dados:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM ALERTAS WHERE ALERTAS_ID_INT = @IdAlerta AND ALERTAS_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'O alerta ' + CAST(@IdAlerta AS VARCHAR) + ' não foi encontrado.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAlerta,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
INÍCIO: Atualizando a tabela ALERTAS:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN

			BEGIN TRANSACTION;

				BEGIN TRY
				
					UPDATE ALERTAS
					SET
						ALERTAS_EXCLUIDO_BIT = 1
					WHERE ALERTAS_ID_INT = @IdAlerta;

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
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdAlerta,
					@StatusCode	= @Codigo;

				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

		END;
/*************************************************************************************************************************************
FIM: Atualizando a tabela ALERTAS.
*************************************************************************************************************************************/

		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Alerta ' + CAST(@IdAlerta AS VARCHAR) + ' deletado com sucesso.';

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdAlerta,
			@StatusCode	= @Codigo;
		END;

		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;

	END;
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
1 - PROCEDURE UTILIZADA PARA DELETAR ALERTAS
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA DELETAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS
GO

CREATE PROCEDURE [dbo].[uspDeletarHospede]
	@IdHospede	int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para deleção de hóspedes.
Data.....: 22/08/2021
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
		DECLARE @Json		VARCHAR(255);

/*************************************************************************************************************************************
Como não há JSON para deleção, adiciona-se uma mensagem padrão, no lugar do JSON, para todas as interações:
*************************************************************************************************************************************/
		SET @Json		= 'Solicitação de deleção do hóspede no id ' + CAST(@IdHospede AS VARCHAR(8)) + '.';

		SET @Entidade	= 'Hóspede';

		SET @Acao		= 'Deletar';
/*************************************************************************************************************************************
Como não há JSON para deleção, adiciona-se uma mensagem padrão, no lugar do JSON, para todas as interações:
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise.
*************************************************************************************************************************************/
		SET @Codigo = 0;
		
		SET @Mensagem = 'Início da análise para deleção de hóspede.'
		
		EXEC [dbo].[uspGravarLog]
		@Json		= @Json,
		@Entidade	= @Entidade,
		@Mensagem	= @Mensagem,
		@Acao		= @Acao,
		@IdCadastro	= @IdHospede,
		@StatusCode	= @Codigo;

		SET @Mensagem = NULL;
/*************************************************************************************************************************************
FIM: Gravando log de início de análise.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
Verificando se existe um hóspede cadastrado com o id da entrada:
*************************************************************************************************************************************/
		IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'Não existe nenhum hóspede cadastrado no sistema com o id ' + CAST(@IdHospede AS VARCHAR(8));

			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospede,
			@StatusCode	= 404;
		END
/*************************************************************************************************************************************
Setando as variáveis @IdHospede, @IdEndereco com o id do hóspede baseado no @IdUsuario.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SELECT	@IdEndereco = HSP_END_ID_INT,
					@IdUsuarios = HSP_USU_ID_INT,
					@IdContatos = HSP_CONT_ID_INT
			FROM	HOSPEDE
			WHERE	HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0;
		END;

/*************************************************************************************************************************************
INÍCIO: Deletando na tabela ENDERECO.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			IF (SELECT 1 FROM ENDERECO WHERE END_ID_INT = @IdEndereco AND END_EXCLUIDO_BIT = 0) IS NOT NULL
				BEGIN
				
					BEGIN TRANSACTION;

						BEGIN TRY

							UPDATE	ENDERECO
							SET
									END_EXCLUIDO_BIT = 1
							WHERE	END_ID_INT = @IdEndereco;

							PRINT 'Endereço deletado com sucesso!';

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
							@IdCadastro	= @IdHospede,
							@StatusCode	= @Codigo;

						END CATCH;

					IF @@TRANCOUNT > 0
						COMMIT TRANSACTION;

				END
			ELSE
				BEGIN

					SET @Codigo = 404;
					SET @Mensagem = 'Não há endereço para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));;

					EXEC [dbo].[uspGravarLog]
					@Json		= @Json,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro	= @IdHospede,
					@StatusCode	= @Codigo;

				END;
/*************************************************************************************************************************************
FIM: Deletando na tabela ENDERECO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Deletando na tabela USUARIO.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM USUARIO WHERE USU_ID_INT = @IdUsuarios AND USU_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	USUARIO
								SET
										USU_EXCLUIDO_BIT = 1
								WHERE	USU_ID_INT = @IdUsuarios;

								PRINT 'Usuário deletado com sucesso!';

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
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						SET @Codigo = 404;
						SET @Mensagem = 'Não há usuário para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdHospede,
						@StatusCode	= @Codigo;
					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela USUARIO.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Deletando na tabela CONTATOS.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM CONTATOS WHERE CONT_ID_INT = @IdContatos AND CONT_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	CONTATOS
								SET
										CONT_EXCLUIDO_BIT = 1
								WHERE	CONT_ID_INT = @IdContatos;

								PRINT 'Contato deletado com sucesso!';

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
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						SET @Codigo = 404;
						SET @Mensagem = 'Não há contatos para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

						EXEC [dbo].[uspGravarLog]
						@Json		= @Json,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro	= @IdHospede,
						@StatusCode	= @Codigo;
					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela CONTATOS.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Deletando na tabela HOSPEDE.
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF (SELECT 1 FROM HOSPEDE WHERE HSP_ID_INT = @IdHospede AND HSP_EXCLUIDO_BIT = 0) IS NOT NULL
					BEGIN
					
						BEGIN TRANSACTION;

							BEGIN TRY

								UPDATE	HOSPEDE
								SET
										HSP_EXCLUIDO_BIT = 1
								WHERE	HSP_ID_INT = @IdHospede;

								PRINT 'Hóspede deletado com sucesso!';

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
								@Json		= @Json,
								@Entidade	= @Entidade,
								@Mensagem	= @Mensagem,
								@Acao		= @Acao,
								@IdCadastro	= @IdHospede,
								@StatusCode	= 500;

								RAISERROR(@Mensagem, 20, -1) WITH LOG;

							END CATCH;

						IF @@TRANCOUNT > 0
							COMMIT TRANSACTION;

					END
				ELSE
					BEGIN

						PRINT 'Não há hóspede para o id do hóspede ' + CAST(@IdHospede AS VARCHAR(8));

					END;
			END;
/*************************************************************************************************************************************
FIM: Deletando na tabela HOSPEDE.
*************************************************************************************************************************************/
		END;

/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso.
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Hóspede ' + CAST(@IdHospede AS VARCHAR(8)) + ' deletado com sucesso.';
		
			EXEC [dbo].[uspGravarLog]
			@Json		= @Json,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro	= @IdHospede,
			@StatusCode	= @Codigo;
		END;
		
		SELECT @Codigo AS Codigo, @Mensagem AS Mensagem;
/*************************************************************************************************************************************
FIM: Gravando log de sucesso.
*************************************************************************************************************************************/

	END
GO
/*************************************************************************************************************************************
**************************************************************************************************************************************
2 - PROCEDURE UTILIZADA PARA DELETAR HÓSPEDES
**************************************************************************************************************************************
*************************************************************************************************************************************/


/*************************************************************************************************************************************
**************************************************************************************************************************************
3 - PROCEDURE UTILIZADA PARA DELETAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/
USE RECPAPAGAIOS;
GO

CREATE PROCEDURE [dbo].[uspDeletarReserva]
	 @IdReserva		int
AS
	BEGIN
/*************************************************************************************************************************************
Descrição: Procedure utilizada para deleção de reservas (no momento, apenas na API).
Data.....: 21/09/2021

--2021-11-06: Correções #1
Alterando as validações do status. Agora, a rotina valida se a reserva está iniciada. Estando com um status de reserva diferente de
iniciada, a solicitação é barrada.

--2021-11-06: Correções #2
Quando a reserva for cancelada, o status da reserva será alterado para cancelada.
*************************************************************************************************************************************/
		SET NOCOUNT ON;
/*************************************************************************************************************************************
Declaração das variáveis:
*************************************************************************************************************************************/
		DECLARE @Mensagem				nvarchar(255);
		DECLARE @IdReservaCadastrada	int;
		DECLARE @StatusReserva			int;
		DECLARE @Chale					int;
		DECLARE @Codigo					int;
		DECLARE @Entidade				nvarchar(50);
		DECLARE @Acao					nvarchar(50);

/*************************************************************************************************************************************
INÍCIO: Gravando log de início de análise:
*************************************************************************************************************************************/
		SET @Codigo	  = 0;
		
		SET @Mensagem = 'Início da análise para deleção de reserva.';
		
		SET @Entidade = 'Reserva';

		SET @Acao	  = 'Deletar';

		EXEC [dbo].[uspGravarLog]
		@Json		= NULL,
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
SELECT principal que atribui valor às variáveis que, posteriormente, serão validadas:
*************************************************************************************************************************************/
		--2021-11-06: Correções #1
		SELECT		 @IdReservaCadastrada	= R.RES_ID_INT
					,@StatusReserva			= R.RES_ST_RES_INT
					,@Chale					= R.RES_ACO_ID_INT
		FROM		RESERVA				AS R
		INNER JOIN	PAGAMENTO_RESERVA	AS PR ON PR.PGTO_RES_ID_INT		= R.RES_ID_INT
		LEFT JOIN	CHECKIN				AS CI ON R.RES_ID_INT			= CI.CHECKIN_RES_ID_INT
		LEFT JOIN	CHECKOUT			AS CO ON CI.CHECKIN_RES_ID_INT	= CO.CHECKOUT_CHECKIN_ID_INT
		WHERE		R.RES_ID_INT = @IdReserva;

/*************************************************************************************************************************************
Validando se a reserva informada existe no sistema:
*************************************************************************************************************************************/
		IF @IdReservaCadastrada IS NULL
		BEGIN
			SET @Codigo = 404;
			SET @Mensagem = 'A reserva ' + CAST(@IdReserva AS VARCHAR) + ' não existe em sistema.';

			EXEC [dbo].[uspGravarLog]
			@Json		= NULL,
			@Entidade	= @Entidade,
			@Mensagem	= @Mensagem,
			@Acao		= @Acao,
			@IdCadastro = @IdReserva,
			@StatusCode	= @Codigo;
		END;

/*************************************************************************************************************************************
Se o pagamento estiver "Em processamento", não será possível excluir a reserva:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			--2021-11-06: Correções #1
			IF @StatusReserva <> 1
			BEGIN
				SET @Codigo = 409;
				SET @Mensagem = 'Não é possível excluir uma reserva que está iniciada.';

				EXEC [dbo].[uspGravarLog]
				@Json		= NULL,
				@Entidade	= @Entidade,
				@Mensagem	= @Mensagem,
				@Acao		= @Acao,
				@IdCadastro = @IdReserva,
				@StatusCode	= @Codigo;
			END;
		END;


		IF @Mensagem IS NULL
		BEGIN
/*************************************************************************************************************************************
INÍCIO: Atualizando tabela RESERVA:
*************************************************************************************************************************************/
			BEGIN TRANSACTION;

				BEGIN TRY

					UPDATE	RESERVA
					SET
							 --2021-11-06: Correções #2
							 RES_ST_RES_INT		= 4
							,RES_EXCLUIDO_BIT	= 1
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
					@Json		= NULL,
					@Entidade	= @Entidade,
					@Mensagem	= @Mensagem,
					@Acao		= @Acao,
					@IdCadastro = @IdReserva,
					@StatusCode	= @Codigo;
				END CATCH;

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION;

/*************************************************************************************************************************************
FIM: Atualizando tabela RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando tabela PAGAMENTO_RESERVA:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				BEGIN TRANSACTION;

					BEGIN TRY

						UPDATE	PAGAMENTO_RESERVA
						SET
								PGTO_RES_EXCLUIDO_BIT = 1
						WHERE	PGTO_RES_RES_ID_INT = @IdReserva;

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
						@Json		= NULL,
						@Entidade	= @Entidade,
						@Mensagem	= @Mensagem,
						@Acao		= @Acao,
						@IdCadastro = @IdReserva,
						@StatusCode	= @Codigo;
					END CATCH;

				IF @@TRANCOUNT > 0
					COMMIT TRANSACTION;
			END;
/*************************************************************************************************************************************
FIM: Atualizando tabela PAGAMENTO_RESERVA.
*************************************************************************************************************************************/

/*************************************************************************************************************************************
INÍCIO: Atualizando tabela ACOMODACAO, caso não haja, nos próximos três dias, reservas:
*************************************************************************************************************************************/
			IF @Mensagem IS NULL
			BEGIN
				IF  (
						SELECT	TOP 1 1
						FROM	RESERVA
						WHERE	RES_ACO_ID_INT = @Chale
						  AND	RES_DATA_CHECKIN_DATE BETWEEN GETDATE() AND GETDATE() + 3
						  AND	RES_ID_INT <> @IdReserva
					)
				IS NULL
				BEGIN

					BEGIN TRANSACTION;

						BEGIN TRY
						
							UPDATE	ACOMODACAO
							SET
									ACO_ST_ACOMOD_INT = 3
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
							@Json		= NULL,
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
FIM: Atualizando tabela ACOMODACAO, caso não haja, nos próximos três dias, reservas.
*************************************************************************************************************************************/
		END;


/*************************************************************************************************************************************
INÍCIO: Gravando log de sucesso:
*************************************************************************************************************************************/
		IF @Mensagem IS NULL
		BEGIN
			SET @Codigo = 200;
			SET @Mensagem = 'Reserva deletada com sucesso. Id: ' + CAST(@IdReserva AS VARCHAR(8)) + '.';
			
			EXEC [dbo].[uspGravarLog]
			@Json		= NULL,
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
3 - PROCEDURE UTILIZADA PARA DELETAR RESERVAS
**************************************************************************************************************************************
*************************************************************************************************************************************/