using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace VerificarReservas.Repository
{
    public class ReservaRepository : IReservaRepository
    {
        private readonly SqlConnection sqlConnection;

        public ReservaRepository()
        {
            sqlConnection = new SqlConnection(connectionString: "Data Source=DESKTOP-8J62RD3\\SQLEXPRESS;Initial Catalog=RECPAPAGAIOS;Integrated Security=True;Connect Timeout=30");
        }

        public async Task VerificarReservasSemCheckIn()
        {
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspVerificarReservasSemCheckIn]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task<string> VerificarAcomodacoesOcupadas()
        {
            DataTable dataTable = new DataTable();
            
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspTrocarAcomodacoesOcupadoParaDisponivel]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            await sqlConnection.OpenAsync();

            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            sqlDataAdapter.Fill(dataTable);

            await sqlConnection.CloseAsync();

            var mensagem = dataTable.Rows[0].Field<string>(0);

            return mensagem;
        }
    }
}
