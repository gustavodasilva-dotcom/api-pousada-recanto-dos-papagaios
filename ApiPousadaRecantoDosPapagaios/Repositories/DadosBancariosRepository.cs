using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
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
            var comando = $"EXEC InserirDadosBancarios '{dadosBancarios.Banco}', '{dadosBancarios.Agencia}', '{dadosBancarios.NumeroDaConta}', '{cpfFuncionario}', {dadosBancarios.Excluido}";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }
    }
}
