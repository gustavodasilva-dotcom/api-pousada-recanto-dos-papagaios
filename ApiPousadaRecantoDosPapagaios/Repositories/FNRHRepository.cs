using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
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
            #region SQL

            var fnrhs = new List<FNRH>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterFNRH]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Id", SqlDbType.Int).Value = idHospede;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

            try
            {
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

            return fnrhs;
        }

        public async Task<Retorno> Inserir(int idHospede, FNRH fnrh, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarFNRH]";

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

            try
            {
                await sqlConnection.OpenAsync();

                var sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                sqlDataAdapter.Fill(dataTable);

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

        public async Task<Retorno> Atualizar(int idFNRH, FNRH fnrh, string json)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspAtualizarFNRH]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdFNRH", SqlDbType.Int).Value = idFNRH;
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

            try
            {
                await sqlConnection.OpenAsync();

                var sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                sqlDataAdapter.Fill(dataTable);

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
