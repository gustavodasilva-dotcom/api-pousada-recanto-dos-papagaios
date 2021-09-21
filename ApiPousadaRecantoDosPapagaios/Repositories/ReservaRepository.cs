using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class ReservaRepository : IReservaRepository
    {
        private readonly SqlConnection sqlConnection;

        private readonly Json _json;

        public ReservaRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));

            _json = new Json();
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<Reserva> Obter(int idReserva)
        {
            Reserva reserva = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

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

            await sqlConnection.CloseAsync();

            return reserva;
        }

        public async Task<Reserva> Inserir(Reserva reserva, ReservaInputModel reservaJson)
        {
            Reserva r = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarReserva]";

            var json = _json.ConverterModelParaJson(reservaJson);

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = reserva.Hospede.Id;
            sqlCommand.Parameters.Add("@Chale", SqlDbType.Int).Value = reserva.Acomodacao.Id;
            sqlCommand.Parameters.Add("@Pagamento", SqlDbType.Int).Value = reserva.Pagamento.Id;
            sqlCommand.Parameters.Add("@DataCheckIn", SqlDbType.DateTime).Value = reserva.DataCheckIn;
            sqlCommand.Parameters.Add("@DataCheckOut", SqlDbType.DateTime).Value = reserva.DataCheckOut;
            sqlCommand.Parameters.Add("@Acompanhantes", SqlDbType.Int).Value = reserva.Acompanhantes;
            sqlCommand.Parameters.Add("@ReservaJson", SqlDbType.NVarChar).Value = json;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();

            procedure = @"[RECPAPAGAIOS].[dbo].[uspObterReserva]";

            sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = reserva.Hospede.Id;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 2;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                r = new Reserva
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

            return r;
        }

        public async Task<Reserva> Atualizar(Reserva reserva, ReservaUpdateInputModel reservaJson)
        {
            var json = _json.ConverterModelParaJson(reservaJson);

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

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();

            var r = await Obter(reserva.Id);

            return r;
        }

        //public async Task Deletar(int idReserva)
        //{
        //    var procedure = @"dbo.[RemoverReserva]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}
    }
}
