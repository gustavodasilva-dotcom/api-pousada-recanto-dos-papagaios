using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
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

        public async Task<List<FNRH>> ObterFNRHsPorHospede(string cpfHospede)
        {
            var fnrhs = new List<FNRH>();

            var comando = $"EXEC ObterFNRHsPorHospede {cpfHospede}";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();
            
            while (sqlDataReader.Read())
            {
                fnrhs.Add(new FNRH
                {
                    Id = (int)sqlDataReader["FNRH_ID_INT"],
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
                });
            }

            await sqlConnection.CloseAsync();

            return fnrhs;
        }

        public async Task<FNRH> ObterUltimoRegistroPorHospede(string cpfHospede)
        {
            FNRH fnrh = null;

            var comando = $"EXEC ObterUltimaFNRHRegistroPorHospede {cpfHospede}";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                fnrh = new FNRH
                {
                    Id = (int)sqlDataReader["FNRH_ID_INT"],
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

        public async Task<FNRH> ObterPorId(int idFNRH)
        {
            FNRH fnrh = null;

            var comando = $"EXEC ObterFNRHPorId {idFNRH}";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                fnrh = new FNRH
                {
                    Id = (int)sqlDataReader["FNRH_ID_INT"],
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
            var comando = $"EXEC InserirFNRH '{fnrh.Profissao}', '{fnrh.Nacionalidade}', '{fnrh.Sexo}', '{fnrh.Rg}', '{fnrh.ProximoDestino}', '{fnrh.UltimoDestino}', '{fnrh.MotivoViagem}', '{fnrh.MeioDeTransporte}', '{fnrh.PlacaAutomovel}', {fnrh.NumAcompanhantes}, {fnrh.HospedeId}, '{fnrh.CpfHospede}', {fnrh.Excluido}";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(int idFNRH, FNRH fnrh)
        {
            var comando = $"EXEC AtualizarFNRH {idFNRH}, '{fnrh.Profissao}', '{fnrh.Nacionalidade}', '{fnrh.Sexo}', '{fnrh.Rg}', '{fnrh.ProximoDestino}', '{fnrh.UltimoDestino}', '{fnrh.MotivoViagem}', '{fnrh.MeioDeTransporte}', '{fnrh.PlacaAutomovel}', {fnrh.NumAcompanhantes}, '{fnrh.CpfHospede}'";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }
    }
}
