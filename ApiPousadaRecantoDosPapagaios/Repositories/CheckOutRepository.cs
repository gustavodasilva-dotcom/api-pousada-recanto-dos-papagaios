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
    public class CheckOutRepository : ICheckOutRepository
    {
        private readonly SqlConnection sqlConnection;

        private readonly Json _json;

        public CheckOutRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));

            _json = new Json();
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<CheckOut> Obter(int idReserva)
        {
            CheckOut c = null;
            
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterCheckOut]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                c = new CheckOut
                {
                    Id = (int)sqlDataReader["CHECKOUT_ID_INT"],
                    ValoresAdicionais = (float)sqlDataReader["CHECKOUT_VALORES_ADICIONAIS_FLOAT"],
                    ValorTotal = (float)sqlDataReader["CHECKOUT_VALOR_TOTAL_FLOAT"],
                    CheckIn = new CheckIn
                    {
                        Id = (int)sqlDataReader["CHECKIN_ID_INT"],
                        Reserva = new Reserva
                        {
                            Id = (int)sqlDataReader["RES_ID_INT"],
                            DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
                            DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
                            DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
                            PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
                            PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
                            Hospede = new Hospede
                            {
                                NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                                Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                            },
                            Acomodacao = new Acomodacao
                            {
                                Id = (int)sqlDataReader["ACO_ID_INT"],
                                Nome = (string)sqlDataReader["ACO_NOME_STR"],
                            },
                            Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"]
                        },
                    },
                    Funcionario = new Funcionario
                    {
                        NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                        Usuario = new Usuario
                        {
                            NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"]
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

            return c;
        }

        public async Task<CheckOut> Inserir(CheckOut checkOut, int ValoresAdicional, CheckOutInputModel checkOutInputModel)
        {
            CheckOut c = null;

            var json = _json.ConverterModelParaJson(checkOutInputModel);

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarCheckOut]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = checkOut.CheckIn.Reserva.Id;
            sqlCommand.Parameters.Add("@IdFuncionario", SqlDbType.Int).Value = checkOut.Funcionario.Id;
            sqlCommand.Parameters.Add("@PagamentoAdicional", SqlDbType.Int).Value = ValoresAdicional;

            if (ValoresAdicional.Equals(1))
            {
                sqlCommand.Parameters.Add("@TipoPagamento", SqlDbType.Int).Value = checkOut.Pagamento.Id;
                sqlCommand.Parameters.Add("@ValorAdicional", SqlDbType.Float).Value = checkOut.ValoresAdicionais;
            }

            sqlCommand.Parameters.Add("@CheckOutJson", SqlDbType.NVarChar).Value = json;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();

            procedure = @"[RECPAPAGAIOS].[dbo].[uspObterCheckOut]";

            sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = checkOut.CheckIn.Reserva.Id;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                c = new CheckOut
                {
                    Id = (int)sqlDataReader["CHECKOUT_ID_INT"],
                    ValoresAdicionais = (float)sqlDataReader["CHECKOUT_VALORES_ADICIONAIS_FLOAT"],
                    ValorTotal = (float)sqlDataReader["CHECKOUT_VALOR_TOTAL_FLOAT"],
                    CheckIn = new CheckIn
                    {
                        Id = (int)sqlDataReader["CHECKIN_ID_INT"],
                        Reserva = new Reserva
                        {
                            Id = (int)sqlDataReader["RES_ID_INT"],
                            DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
                            DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
                            DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
                            PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
                            PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
                            Hospede = new Hospede
                            {
                                NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                                Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                            },
                            Acomodacao = new Acomodacao
                            {
                                Id = (int)sqlDataReader["ACO_ID_INT"],
                                Nome = (string)sqlDataReader["ACO_NOME_STR"],
                            },
                            Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"]
                        },
                    },
                    Funcionario = new Funcionario
                    {
                        NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                        Usuario = new Usuario
                        {
                            NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"]
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

            return c;
        }
    }
}
