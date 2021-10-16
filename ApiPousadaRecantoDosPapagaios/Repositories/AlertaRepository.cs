using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class AlertaRepository : IAlertaRepository
    {
        private readonly SqlConnection sqlConnection;

        public AlertaRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public async Task<List<Alerta>> Obter(int pagina, int quantidade)
        {
            #region SQL

            var alertas = new List<Alerta>();

            var query =
            $@"  SELECT		 ALERTAS_ID_INT
                			,ALERTAS_TITULO_STR
                			,ALERTAS_MENSAGEM_STR
                			,FUNC_NOME_STR
                			,USU_NOME_USUARIO_STR
                FROM		ALERTAS		AS A
                INNER JOIN	FUNCIONARIO AS F ON A.ALERTAS_FUNC_ID_INT = FUNC_ID_INT
                INNER JOIN	USUARIO		AS U ON F.FUNC_USU_ID_INT	  = USU_ID_INT
                WHERE       ALERTAS_EXCLUIDO_BIT = 0
                ORDER BY	F.FUNC_ID_INT OFFSET (({pagina} - 1) * {quantidade}) ROWS FETCH NEXT {quantidade} ROWS ONLY;";

            SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);

            sqlCommand.CommandType = CommandType.Text;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader reader = await sqlCommand.ExecuteReaderAsync();

                while (reader.Read())
                {
                    alertas.Add(new Alerta
                    {
                        Id = (int)reader["ALERTAS_ID_INT"],
                        Titulo = (string)reader["ALERTAS_TITULO_STR"],
                        Mensagem = (string)reader["ALERTAS_MENSAGEM_STR"],
                        Funcionario = new Funcionario
                        {
                            NomeCompleto = (string)reader["FUNC_NOME_STR"],
                            Usuario = new Usuario
                            {
                                NomeUsuario = (string)reader["USU_NOME_USUARIO_STR"]
                            }
                        }
                    });
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return alertas;
        }

        public async Task<Retorno> Inserir(Alerta alerta, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarAlerta]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Titulo", SqlDbType.VarChar).Value = alerta.Titulo;
            sqlCommand.Parameters.Add("@Corpo", SqlDbType.VarChar).Value = alerta.Mensagem;
            sqlCommand.Parameters.Add("@IdFuncionario", SqlDbType.Int).Value = alerta.Funcionario.Id;
            sqlCommand.Parameters.Add("@Json", SqlDbType.VarChar).Value = json;

            try
            {
                await sqlConnection.OpenAsync();

                var adapter = new SqlDataAdapter(sqlCommand);

                adapter.Fill(dataTable);

                retorno.StatusCode = (int)dataTable.Rows[0]["Codigo"];
                retorno.Mensagem = dataTable.Rows[0]["Mensagem"].ToString();
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return retorno;
        }

        public async Task<Retorno> Deletar(int idAlerta)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspDeletarAlerta]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdAlerta", SqlDbType.Int).Value = idAlerta;

            try
            {
                await sqlConnection.OpenAsync();

                var adapter = new SqlDataAdapter(sqlCommand);

                adapter.Fill(dataTable);

                retorno.StatusCode = (int)dataTable.Rows[0]["Codigo"];
                retorno.Mensagem = dataTable.Rows[0]["Mensagem"].ToString();
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return retorno;
        }
    }
}
