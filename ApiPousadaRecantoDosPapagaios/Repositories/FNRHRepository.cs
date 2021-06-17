using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class FNRHRepository : IFNRHRepository
    {
        private readonly SqlConnection sqlConnection;

        public FNRHRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<FNRH> Obter(string cpfHospede)
        {
            FNRH fnrh = null;

            var comando = $"SELECT F.FNRH_PROFISSAO_STR, F.FNRH_NACIONALIDADE_STR, F.FNRH_SEXO_CHAR, F.FNRH_RG_CHAR, F.FNRH_PROXIMO_DESTINO_STR, F.FNRH_ULTIMO_DESTINO_STR, F.FNRH_MOTIVO_VIAGEM_STR, F.FNRH_MEIO_DE_TRANSPORTE_STR, F.FNRH_PLACA_AUTOMOVEL_STR, F.FNRH_NUM_ACOMPANHANTES_INT, F.FNRH_HSP_ID_INT, F.FNRH_CPF_HOSPEDE_STR FROM dbo.HOSPEDE AS H, dbo.FNRH AS F WHERE (H.HSP_CPF_CHAR = '{cpfHospede}') AND (F.FNRH_CPF_HOSPEDE_STR = '{cpfHospede}') AND (H.HSP_EXCLUIDO_BIT = 0)";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();
            
            while (sqlDataReader.Read())
            {
                fnrh = new FNRH
                {
                    Profissao = (string)sqlDataReader["FNRH_PROFISSAO_STR"],
                    Nacionalidade = (string)sqlDataReader["FNRH_NACIONALIDADE_STR"],
                    Sexo = (string)sqlDataReader["FNRH_SEXO_CHAR"],
                    Rg = (string)sqlDataReader["FNRH_RG_CHAR"],
                    ProximoDestino = (string)sqlDataReader["FNRH_PROXIMO_DESTINO_STR"],
                    UltimoDestino = (string)sqlDataReader["FNRH_ULTIMO_DESTINO_STR"],
                    MotivoViagem = (string)sqlDataReader["FNRH_MOTIVO_VIAGEM_STR"],
                    MeioDeTransporte = (string)sqlDataReader["FNRH_MEIO_DE_TRANSPORTE_STR"],
                    PlacaAutomovel = (string)sqlDataReader["FNRH_PLACA_AUTOMOVEL_STR"],
                    NumAcompanhantes = (int)sqlDataReader["FNRH_NUM_ACOMPANHANTES_INT"],
                    CpfHospede = (string)sqlDataReader["FNRH_CPF_HOSPEDE_STR"]
                };
            }

            await sqlConnection.CloseAsync();

            return fnrh;
        }

        public async Task Inserir(string cpfHospede, FNRH fnrh)
        {
            var comando = $"INSERT INTO dbo.FNRH VALUES ('{fnrh.Profissao}', '{fnrh.Nacionalidade}', '{fnrh.Sexo}', '{fnrh.Rg}', '{fnrh.ProximoDestino}', '{fnrh.UltimoDestino}', '{fnrh.MotivoViagem}', '{fnrh.MeioDeTransporte}', '{fnrh.PlacaAutomovel}', {fnrh.NumAcompanhantes}, {fnrh.HospedeId}, '{cpfHospede}', {fnrh.Excluido})";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            await sqlCommand.ExecuteNonQueryAsync();

            await sqlConnection.CloseAsync();
        }
    }
}
