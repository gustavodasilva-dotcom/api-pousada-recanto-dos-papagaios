using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace VerificarReservas.Repository
{
    public class PagamentoRepository : IPagamentoRepository
    {
        private readonly SqlConnection sqlConnection;

        public PagamentoRepository()
        {
            sqlConnection = new SqlConnection(connectionString: "Data Source=DESKTOP-8J62RD3\\SQLEXPRESS;Initial Catalog=RECPAPAGAIOS;Integrated Security=True;Connect Timeout=30");
        }

        public void Dispose()
        
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<string> CertaoDeCreditoPagamentoPendente()
        {
            var mensagem = "";

            DataTable dataTable = new DataTable();
            
            var procedure = @"[dbo].[uspVerificarPagamentosPendentes_CartaoCredito]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            await sqlConnection.OpenAsync();

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            sqlDataAdapter.Fill(dataTable);

            await sqlConnection.CloseAsync();

            mensagem = dataTable.Rows[0].Field<string>(0);

            return mensagem;
        }
    }
}
