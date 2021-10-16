using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class AcomodacaoRepository : IAcomodacaoRepository
    {
        private readonly SqlConnection sqlConnection;

        public AcomodacaoRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<List<Acomodacao>> Obter()
        {
            #region SQL

            var acomodacoes = new List<Acomodacao>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterAcomodacoes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            try
            {
                while (sqlDataReader.Read())
                {
                    acomodacoes.Add(new Acomodacao
                    {
                        Id = (int)sqlDataReader["ACO_ID_INT"],
                        Nome = (string)sqlDataReader["ACO_NOME_STR"],
                        StatusAcomodacao = new StatusAcomodacao
                        {
                            Id = (int)sqlDataReader["ST_ACOMOD_ID_INT"],
                            Descricao = (string)sqlDataReader["ST_ACOMOD_DESCRICAO_STR"]
                        },
                        InformacoesAcomodacao = new InformacoesAcomodacao
                        {
                            Id = (int)sqlDataReader["INFO_ACOMOD_ID_INT"],
                            MetrosQuadrados = (float)sqlDataReader["INFO_ACOMOD_METROS_QUADRADOS_FLOAT"],
                            Capacidade = (int)sqlDataReader["INFO_ACOMOD_CAPACIDADE_INT"],
                            TipoDeCama = (string)sqlDataReader["INFO_ACOMOD_TIPO_DE_CAMA_STR"],
                            Preco = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"]
                        },
                        CategoriaAcomodacao = new CategoriaAcomodacao
                        {
                            Id = (int)sqlDataReader["CAT_ACOMOD_ID_INT"],
                            Descricao = (string)sqlDataReader["CAT_ACOMOD_DESCRICAO_STR"]
                        }
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

            return acomodacoes;
        }

        public async Task<AcomodacaoUnitaria> Obter(int idAcomodacao)
        {
            #region SQL

            AcomodacaoUnitaria acomodacao = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterAcomodacoes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 2;
            sqlCommand.Parameters.Add("@Id", SqlDbType.Int).Value = idAcomodacao;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                acomodacao = new AcomodacaoUnitaria
                {
                    Id = (int)sqlDataReader["ACO_ID_INT"],
                    Nome = (string)sqlDataReader["ACO_NOME_STR"],
                    StatusAcomodacao = new StatusAcomodacao
                    {
                        Id = (int)sqlDataReader["ST_ACOMOD_ID_INT"],
                        Descricao = (string)sqlDataReader["ST_ACOMOD_DESCRICAO_STR"]
                    },
                    InformacoesAcomodacao = new InformacoesAcomodacao
                    {
                        Id = (int)sqlDataReader["INFO_ACOMOD_ID_INT"],
                        MetrosQuadrados = (float)sqlDataReader["INFO_ACOMOD_METROS_QUADRADOS_FLOAT"],
                        Capacidade = (int)sqlDataReader["INFO_ACOMOD_CAPACIDADE_INT"],
                        TipoDeCama = (string)sqlDataReader["INFO_ACOMOD_TIPO_DE_CAMA_STR"],
                        Preco = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"]
                    },
                    CategoriaAcomodacao = new CategoriaAcomodacao
                    {
                        Id = (int)sqlDataReader["CAT_ACOMOD_ID_INT"],
                        Descricao = (string)sqlDataReader["CAT_ACOMOD_DESCRICAO_STR"]
                    }
                };
            }

            await sqlConnection.CloseAsync();

            #endregion SQL

            return acomodacao;
        }

        public async Task<List<ReservaResumida>> ObterProximasReservas(int idAcomodacao)
        {
            #region SQL

            var proximasReservas = new List<ReservaResumida>();

            var query =
            $@"SELECT    R.RES_ID_INT
            			,R.RES_DATA_CHECKIN_DATE
            			,R.RES_DATA_CHECKOUT_DATE
                        ,H.HSP_ID_INT
            			,H.HSP_NOME_STR
            			,H.HSP_CPF_CHAR
            FROM		RESERVA AS R
            INNER JOIN	HOSPEDE AS H ON R.RES_HSP_ID_INT = H.HSP_ID_INT
            WHERE		RES_DATA_CHECKIN_DATE > GETDATE() - 1
              AND		RES_ACO_ID_INT = {idAcomodacao};";

            SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader reader = await sqlCommand.ExecuteReaderAsync();

                while (reader.Read())
                {
                    proximasReservas.Add(new ReservaResumida
                    {
                        idReserva = (int)reader["RES_ID_INT"],
                        DataCheckIn = (DateTime)reader["RES_DATA_CHECKIN_DATE"],
                        DataCheckOut = (DateTime)reader["RES_DATA_CHECKOUT_DATE"],
                        Hospede = new HospedeReserva
                        {
                            Id = (int)reader["HSP_ID_INT"],
                            NomeCompleto = (string)reader["HSP_NOME_STR"],
                            Cpf = (string)reader["HSP_CPF_CHAR"]
                        }
                    });
                };
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

            return proximasReservas;
        }
    }
}
