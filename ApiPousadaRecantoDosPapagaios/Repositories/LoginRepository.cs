using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class LoginRepository : ILoginRepository
    {
        private readonly SqlConnection _sqlConnection;

        public LoginRepository(IConfiguration configuration)
        {
            _sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public async Task<Login> FazerLogin(Login login, string json)
        {
            #region SQL

            var loginRetorno = new Login();
            
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspFazerLogin]";

            SqlCommand sqlCommand = new SqlCommand(procedure, _sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = login.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = login.SenhaUsuario;
            sqlCommand.Parameters.Add("@Json", SqlDbType.NVarChar).Value = json;

            try
            {
                await _sqlConnection.OpenAsync();

                SqlDataReader reader = await sqlCommand.ExecuteReaderAsync();

                while (reader.Read())
                {
                    loginRetorno = new Login()
                    {
                        Retorno = new Retorno
                        {
                            StatusCode = (int)reader["Codigo"],
                            Mensagem = (string)reader["Mensagem"]
                        },
                        Id = (int)reader["Id"],
                        NomeUsuario = (string)reader["Usuario"],
                        Cpf = (string)reader["Cpf"]
                    };
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await _sqlConnection.CloseAsync();
            }

            #endregion SQL

            return loginRetorno;
        }

        public async Task<Retorno> DenificaoSenha(DefinicaoSenha definicaoSenha, string json)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspDefinirNovaSenha]";

            var sqlCommand = new SqlCommand(procedure, _sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = definicaoSenha.Cpf;
            sqlCommand.Parameters.Add("@NovaSenha", SqlDbType.NVarChar).Value = definicaoSenha.NovaSenha;
            sqlCommand.Parameters.Add("@RepeticaoSenha", SqlDbType.NVarChar).Value = definicaoSenha.RepeticaoSenha;
            sqlCommand.Parameters.Add("@Json", SqlDbType.NVarChar).Value = json;

            try
            {
                await _sqlConnection.OpenAsync();

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
                await _sqlConnection.CloseAsync();
            }

            #endregion SQL

            return retorno;
        }

        public async Task<PerguntaDeSeguranca> PerguntaSeguranca(string cpf)
        {
            #region SQL

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspEsqueciMinhaSenha_EncontrarConta]";

            PerguntaDeSeguranca perguntaDeSeguranca = null;

            var sqlCommand = new SqlCommand(procedure, _sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = cpf;

            try
            {
                await _sqlConnection.OpenAsync();

                SqlDataReader reader = await sqlCommand.ExecuteReaderAsync();

                while (reader.Read())
                {
                    perguntaDeSeguranca = new PerguntaDeSeguranca
                    {
                        Cpf = (string)reader["CPF"],
                        PerguntaSeguranca = (string)reader["PERG_SEG_PERGUNTA_STR"],
                        RespostaSeguranca = (string)reader["PERG_SEG_RESPOSTA_STR"],
                    };
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await _sqlConnection.CloseAsync();
            }

            #endregion SQL

            return perguntaDeSeguranca;
        }
    }
}
