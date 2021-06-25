using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class DadosBancariosRepository : IDadosBancariosRepository
    {
        private readonly SqlConnection sqlConnection;

        public DadosBancariosRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task Inserir(DadosBancarios dadosBancarios, string cpfFuncionario)
        {
            var procedure = @"dbo.[InserirDadosBancarios]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Banco", SqlDbType.NVarChar).Value = dadosBancarios.Banco;
            sqlCommand.Parameters.Add("@Agencia", SqlDbType.NVarChar).Value = dadosBancarios.Agencia;
            sqlCommand.Parameters.Add("@NumeroDaConta", SqlDbType.NVarChar).Value = dadosBancarios.NumeroDaConta;
            sqlCommand.Parameters.Add("@CpfFuncionario", SqlDbType.NChar).Value = cpfFuncionario;
            sqlCommand.Parameters.Add("@Excluido", SqlDbType.Bit).Value = dadosBancarios.Excluido;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(string cpfFuncionario, DadosBancarios dadosBancarios)
        {
            var procedure = @"dbo.[AtualizarDadosBancarios]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;
            
            sqlCommand.Parameters.Add("@Banco", SqlDbType.NVarChar).Value = dadosBancarios.Banco;
            sqlCommand.Parameters.Add("@Agencia", SqlDbType.NVarChar).Value = dadosBancarios.Agencia;
            sqlCommand.Parameters.Add("@NumeroDaConta", SqlDbType.NVarChar).Value = dadosBancarios.NumeroDaConta;
            sqlCommand.Parameters.Add("@CpfFuncionario", SqlDbType.NChar).Value = cpfFuncionario;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();
        }
    }
}
