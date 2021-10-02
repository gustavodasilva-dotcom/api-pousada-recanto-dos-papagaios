using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class CheckInRepository : ICheckInRepository
    {
        private readonly SqlConnection sqlConnection;

        private readonly Json _json;
        
        public CheckInRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));

            _json = new Json();
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<CheckIn> Obter(int idCheckIn)
        {
            #region SQL

            CheckIn checkIn = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterCheckIns]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idCheckIn;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                checkIn = new CheckIn
                {
                    Id = (int)sqlDataReader["CHECKIN_ID_INT"],
                    Reserva = new Reserva
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
                    },
                    Funcionario = new Funcionario
                    {
                        Usuario = new Usuario
                        {
                            NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"]
                        }
                    }
                };
            }

            await sqlConnection.CloseAsync();

            #endregion SQL

            return checkIn;
        }

        public async Task<Retorno> Inserir(CheckIn checkIn)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarCheckIn]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = checkIn.Reserva.Id;
            sqlCommand.Parameters.Add("@IdFuncionario", SqlDbType.Int).Value = checkIn.Funcionario.Id;

            await sqlConnection.OpenAsync();

            var sqlDataAdapter = new SqlDataAdapter(sqlCommand);

            sqlDataAdapter.Fill(dataTable);

            await sqlConnection.CloseAsync();

            retorno.StatusCode = (int)dataTable.Rows[0]["Codigo"];
            retorno.Mensagem = dataTable.Rows[0]["Mensagem"].ToString();

            #endregion SQL

            return retorno;
        }
    }
}
