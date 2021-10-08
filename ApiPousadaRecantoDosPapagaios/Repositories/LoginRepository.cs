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

        public async Task<Retorno> FazerLogin(Login login, string json)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspFazerLogin]";

            SqlCommand sqlCommand = new SqlCommand(procedure, _sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = login.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = login.SenhaUsuario;
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
    }
}
