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

        public async Task<List<Reserva>> Obter(int pagina, int quantidade)
        {
            var reservas = new List<Reserva>();

            var procedure = @"dbo.[ObterReservas]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
            sqlCommand.Parameters.Add("@Quantidade", SqlDbType.Int).Value = quantidade;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                reservas.Add(new Reserva
                {
                    Id = (int)sqlDataReader["RES_ID_INT"],
                    DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
                    DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
                    DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
                    PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
                    PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
                    StatusReserva = new StatusReserva
                    {
                        Id = (int)sqlDataReader["ST_RES_ID_INT"],
                        Descricao = (string)sqlDataReader["ST_RES_DESCRICAO_STR"]
                    },
                    Acomodacao = new Acomodacao
                    {
                        Id = (int)sqlDataReader["ACO_ID_INT"],
                        Nome = (string)sqlDataReader["ACO_NOME_STR"],
                        StatusAcomodacao = new StatusAcomodacao
                        {
                            Id = (int)sqlDataReader["ST_RES_ID_INT"],
                            Descricao = (string)sqlDataReader["ST_RES_DESCRICAO_STR"]
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
                    },
                    Pagamento = new Pagamento
                    {
                        Id = (int)sqlDataReader["PGTO_ID_INT"],
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
                    },
                    Excluido = (bool)sqlDataReader["RES_EXCLUIDO_BIT"]
                });
            }

            return reservas;
        }
    }
}
