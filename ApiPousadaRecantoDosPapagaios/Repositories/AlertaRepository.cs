using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
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

        public async Task<Retorno> Inserir(Alerta alerta, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarAlerta]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Titulo", SqlDbType.VarChar).Value = alerta.Titulo;
            sqlCommand.Parameters.Add("@Mensagem", SqlDbType.VarChar).Value = alerta.Mensagem;
            sqlCommand.Parameters.Add("@IdFuncionario", SqlDbType.Int).Value = alerta.IdFuncionario;
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
    }
}
