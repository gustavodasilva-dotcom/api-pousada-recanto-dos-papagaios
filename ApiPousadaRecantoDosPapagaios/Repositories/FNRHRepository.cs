using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
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

        public async Task<List<FNRH>> ObterFNRHsPorHospede(int idHospede)
        {
            var fnrhs = new List<FNRH>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterFNRH]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;

            await sqlConnection.OpenAsync();

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
                    DataCadastro = (DateTime)sqlDataReader["FNRH_DATA_CADASTRO_DATETIME"]
                });
            }

            await sqlConnection.CloseAsync();

            return fnrhs;
        }

        public async Task<FNRH> Inserir(int idHospede, FNRH fnrh, FNRHInputModel fnrhJson)
        {
            FNRH fnrhRetorno = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarNovaFNRH]";

            var json = ConverterModelParaJson(fnrhJson);

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;
            sqlCommand.Parameters.Add("@Profissao", SqlDbType.NVarChar).Value = fnrh.Profissao;
            sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = fnrh.Nacionalidade;
            sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = fnrh.Sexo;
            sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = fnrh.Rg;
            sqlCommand.Parameters.Add("@ProximoDestino", SqlDbType.NVarChar).Value = fnrh.ProximoDestino;
            sqlCommand.Parameters.Add("@UltimoDestino", SqlDbType.NVarChar).Value = fnrh.UltimoDestino;
            sqlCommand.Parameters.Add("@MotivoViagem", SqlDbType.NVarChar).Value = fnrh.MotivoViagem;
            sqlCommand.Parameters.Add("@MeioDeTransporte", SqlDbType.NVarChar).Value = fnrh.MeioDeTransporte;
            sqlCommand.Parameters.Add("@PlacaAutomovel", SqlDbType.NVarChar).Value = fnrh.PlacaAutomovel;
            sqlCommand.Parameters.Add("@NumAcompanhantes", SqlDbType.Int).Value = fnrh.NumAcompanhantes;
            sqlCommand.Parameters.Add("@FNRHJson", SqlDbType.NVarChar).Value = json;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();

            procedure = @"[RECPAPAGAIOS].[dbo].[uspObterUltimaFNRHPorHospedeId]";

            sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                fnrhRetorno = new FNRH
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
                    DataCadastro = (DateTime)sqlDataReader["FNRH_DATA_CADASTRO_DATETIME"]
                };
            }

            await sqlConnection.CloseAsync();

            return fnrhRetorno;
        }

        //public async Task Atualizar(int idFNRH, FNRH fnrh)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[AtualizarFNRH]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@IdFNRH", SqlDbType.Int).Value = idFNRH;
        //    sqlCommand.Parameters.Add("@Profissao", SqlDbType.NVarChar).Value = fnrh.Profissao;
        //    sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = fnrh.Nacionalidade;
        //    sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = fnrh.Sexo;
        //    sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = fnrh.Rg;
        //    sqlCommand.Parameters.Add("@ProximoDestino", SqlDbType.NVarChar).Value = fnrh.ProximoDestino;
        //    sqlCommand.Parameters.Add("@UltimoDestino", SqlDbType.NVarChar).Value = fnrh.UltimoDestino;
        //    sqlCommand.Parameters.Add("@MotivoViagem", SqlDbType.NVarChar).Value = fnrh.MotivoViagem;
        //    sqlCommand.Parameters.Add("@MeioDeTransporte", SqlDbType.NVarChar).Value = fnrh.MeioDeTransporte;
        //    sqlCommand.Parameters.Add("@PlacaAutomovel", SqlDbType.NVarChar).Value = fnrh.PlacaAutomovel;
        //    sqlCommand.Parameters.Add("@NumAcompanhantes", SqlDbType.Int).Value = fnrh.NumAcompanhantes;
        //    sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NVarChar).Value = fnrh.CpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task Deletar(int idFNRH)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[RemoverFNRH]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@IdFNRH", SqlDbType.Int).Value = idFNRH;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        public string ConverterModelParaJson(FNRHInputModel fnrh)
        {
            var json = JsonConvert.SerializeObject(fnrh);

            return json;
        }
    }
}
