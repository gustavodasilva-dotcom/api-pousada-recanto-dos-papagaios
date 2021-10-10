using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class ReservaRepository : IReservaRepository
    {
        private readonly SqlConnection sqlConnection;

        public ReservaRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<Reserva> Obter(int idReserva)
        {
            #region SQL

            Reserva reserva = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

                while (sqlDataReader.Read())
                {
                    reserva = new Reserva
                    {
                        Id = (int)sqlDataReader["RES_ID_INT"],
                        DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
                        DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
                        DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
                        Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"],
                        PrecoUnitario = (float)sqlDataReader["RES_VALOR_UNITARIO_FLOAT"],
                        PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
                        StatusReserva = new StatusReserva
                        {
                            Id = (int)sqlDataReader["ST_RES_ID_INT"],
                            Descricao = (string)sqlDataReader["ST_RES_DESCRICAO_STR"]
                        },
                        Hospede = new Hospede
                        {
                            Id = (int)sqlDataReader["HSP_ID_INT"],
                            NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                            Cpf = (string)sqlDataReader["HSP_CPF_CHAR"]
                        },
                        Acomodacao = new Acomodacao
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
                        },
                        Pagamento = new Pagamento
                        {
                            TipoPagamento = new TipoPagamento
                            {
                                Id = (int)sqlDataReader["TPPGTO_ID_INT"],
                                Descricao = (string)sqlDataReader["TPPGTO_TIPO_PAGAMENTO_STR"]
                            },
                            StatusPagamento = new StatusPagamento
                            {
                                Id = (int)sqlDataReader["ST_PGTO_ID_INT"],
                                Descricao = (string)sqlDataReader["ST_PGTO_DESCRICAO_STR"]
                            }
                        }
                    };
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

            return reserva;
        }

        public async Task<List<Reserva>> Obter(string cpf)
        {
            #region SQL

            var reserva = new List<Reserva>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cpf", SqlDbType.Char).Value = cpf;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 3;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

                while (sqlDataReader.Read())
                {
                    reserva.Add(new Reserva
                    {
                        Id = (int)sqlDataReader["RES_ID_INT"],
                        DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
                        DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
                        DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
                        Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"],
                        PrecoUnitario = (float)sqlDataReader["RES_VALOR_UNITARIO_FLOAT"],
                        PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
                        StatusReserva = new StatusReserva
                        {
                            Id = (int)sqlDataReader["ST_RES_ID_INT"],
                            Descricao = (string)sqlDataReader["ST_RES_DESCRICAO_STR"]
                        },
                        Hospede = new Hospede
                        {
                            Id = (int)sqlDataReader["HSP_ID_INT"],
                            NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                            Cpf = (string)sqlDataReader["HSP_CPF_CHAR"]
                        },
                        Acomodacao = new Acomodacao
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
                        },
                        Pagamento = new Pagamento
                        {
                            TipoPagamento = new TipoPagamento
                            {
                                Id = (int)sqlDataReader["TPPGTO_ID_INT"],
                                Descricao = (string)sqlDataReader["TPPGTO_TIPO_PAGAMENTO_STR"]
                            },
                            StatusPagamento = new StatusPagamento
                            {
                                Id = (int)sqlDataReader["ST_PGTO_ID_INT"],
                                Descricao = (string)sqlDataReader["ST_PGTO_DESCRICAO_STR"]
                            }
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

            return reserva;
        }

        public async Task<Retorno> Inserir(Reserva reserva, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = reserva.Hospede.Id;
            sqlCommand.Parameters.Add("@Chale", SqlDbType.Int).Value = reserva.Acomodacao.Id;
            sqlCommand.Parameters.Add("@Pagamento", SqlDbType.Int).Value = reserva.Pagamento.Id;
            sqlCommand.Parameters.Add("@DataCheckIn", SqlDbType.DateTime).Value = reserva.DataCheckIn;
            sqlCommand.Parameters.Add("@DataCheckOut", SqlDbType.DateTime).Value = reserva.DataCheckOut;
            sqlCommand.Parameters.Add("@Acompanhantes", SqlDbType.Int).Value = reserva.Acompanhantes;
            sqlCommand.Parameters.Add("@Json", SqlDbType.VarChar).Value = json;

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

        public async Task<Retorno> Atualizar(Reserva reserva, string json)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspAtualizarReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = reserva.Id;
            sqlCommand.Parameters.Add("@Chale", SqlDbType.Int).Value = reserva.Acomodacao.Id;
            sqlCommand.Parameters.Add("@Pagamento", SqlDbType.Int).Value = reserva.Pagamento.Id;
            sqlCommand.Parameters.Add("@DataCheckIn", SqlDbType.DateTime).Value = reserva.DataCheckIn;
            sqlCommand.Parameters.Add("@DataCheckOut", SqlDbType.DateTime).Value = reserva.DataCheckOut;
            sqlCommand.Parameters.Add("@Acompanhantes", SqlDbType.Int).Value = reserva.Acompanhantes;
            sqlCommand.Parameters.Add("@ReservaJson", SqlDbType.NVarChar).Value = json;

            try
            {
                await sqlConnection.OpenAsync();

                var adapter = new SqlDataAdapter(sqlCommand);

                adapter.Fill(dataTable);

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

        public async Task<Retorno> Deletar(int idReserva)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspDeletarReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

            try
            {
                await sqlConnection.OpenAsync();

                var adapter = new SqlDataAdapter(sqlCommand);

                adapter.Fill(dataTable);

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
