using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class CheckOutRepository /*: ICheckOutRepository*/
    {
        //private readonly SqlConnection sqlConnection;

        //public CheckOutRepository(IConfiguration configuration)
        //{
        //    sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        //}

        //public void Dispose()
        //{
        //    sqlConnection?.Close();
        //    sqlConnection?.Dispose();
        //}

        //public async Task<CheckOut> ObterUltimoCheckOut()
        //{
        //    CheckOut checkOut = null;

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterUltimoCheckOut]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        checkOut = new CheckOut
        //        {
        //            Id = (int)sqlDataReader["CHECKOUT_ID_INT"],
        //            ValoresAdicionais = (float)sqlDataReader["CHECKOUT_VALORES_ADICIONAIS_FLOAT"],
        //            ValorTotal = (float)sqlDataReader["CHECKOUT_VALOR_TOTAL_FLOAT"],
        //            CheckIn = new CheckIn
        //            {
        //                Id = (int)sqlDataReader["CHECKIN_ID_INT"],
        //                Reserva = new Reserva
        //                {
        //                    Id = (int)sqlDataReader["RES_ID_INT"],
        //                    DataReserva = (DateTime)sqlDataReader["RES_DATA_RESERVA_DATE"],
        //                    DataCheckIn = (DateTime)sqlDataReader["RES_DATA_CHECKIN_DATE"],
        //                    DataCheckOut = (DateTime)sqlDataReader["RES_DATA_CHECKOUT_DATE"],
        //                    PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
        //                    PrecoTotal = (float)sqlDataReader["RES_VALOR_RESERVA_FLOAT"],
        //                    Hospede = new Hospede
        //                    {
        //                        NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
        //                        Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
        //                        Email = (string)sqlDataReader["HSP_EMAIL_STR"]
        //                    },
        //                    Acomodacao = new Acomodacao
        //                    {
        //                        Id = (int)sqlDataReader["ACO_ID_INT"],
        //                        Nome = (string)sqlDataReader["ACO_NOME_STR"],
        //                    },
        //                    Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"]
        //                },
        //            },
        //            Funcionario = new Funcionario
        //            {
        //                Id = (int)sqlDataReader["FUNC_ID_INT"],
        //                Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"],
        //                Email = (string)sqlDataReader["FUNC_EMAIL_STR"],
        //                Setor = (string)sqlDataReader["FUNC_SETOR_STR"]
        //            },
        //            Pagamento = new Pagamento
        //            {
        //                Id = (int)sqlDataReader["PGTO_COUT_ID_INT"],
        //                TipoPagamento = new TipoPagamento
        //                {
        //                    Id = (int)sqlDataReader["TPPGTO_ID_INT"],
        //                    Descricao = (string)sqlDataReader["TPPGTO_TIPO_PAGAMENTO_STR"]
        //                },
        //                StatusPagamento = new StatusPagamento
        //                {
        //                    Id = (int)sqlDataReader["ST_PGTO_ID_INT"],
        //                    Descricao = (string)sqlDataReader["ST_PGTO_DESCRICAO_STR"]
        //                }
        //            },
        //            Excluido = (bool)sqlDataReader["CHECKOUT_EXCLUIDO_BIT"]
        //        };
        //    }

        //    await sqlConnection.CloseAsync();

        //    return checkOut;
        //}

        //public async Task Inserir(CheckOut checkOut)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[InserirCheckOut]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = checkOut.CheckIn.Reserva.Id;
        //    sqlCommand.Parameters.Add("@ValoresAdicionais", SqlDbType.Float).Value = checkOut.ValoresAdicionais;
        //    sqlCommand.Parameters.Add("@LoginFuncionario", SqlDbType.NVarChar).Value = checkOut.Funcionario.Login;
        //    sqlCommand.Parameters.Add("@Pagamento", SqlDbType.Int).Value = checkOut.Pagamento.Id;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

    }
}
