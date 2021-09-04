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
    }
}
