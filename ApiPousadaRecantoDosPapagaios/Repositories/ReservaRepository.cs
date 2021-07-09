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
                    Hospede = new Hospede
                    {
                        Id = (int)sqlDataReader["HSP_ID_INT"],
                        NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                        Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                        DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                        Email = (string)sqlDataReader["HSP_EMAIL_STR"],
                        Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
                        Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
                        Celular = (string)sqlDataReader["HSP_CELULAR_STR"],
                        Endereco = new Endereco
                        {
                            Cep = (string)sqlDataReader["END_CEP_CHAR"],
                            Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                            Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                            Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                            Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                            Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                            Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                            Pais = (string)sqlDataReader["END_PAIS_STR"]
                        }
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
                    Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"],
                    Excluido = (bool)sqlDataReader["RES_EXCLUIDO_BIT"]
                });
            }

            await sqlConnection.CloseAsync();

            return reservas;
        }

        public async Task<Reserva> Obter(int idReserva)
        {
            Reserva reserva = null;

            var procedure = @"dbo.[ObterReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

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
                    PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
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
                        Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                        DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                        Email = (string)sqlDataReader["HSP_EMAIL_STR"],
                        Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
                        Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
                        Celular = (string)sqlDataReader["HSP_CELULAR_STR"],
                        Endereco = new Endereco
                        {
                            Cep = (string)sqlDataReader["END_CEP_CHAR"],
                            Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                            Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                            Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                            Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                            Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                            Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                            Pais = (string)sqlDataReader["END_PAIS_STR"]
                        }
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
                    Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"],
                    Excluido = (bool)sqlDataReader["RES_EXCLUIDO_BIT"]
                };
            }

            await sqlConnection.CloseAsync();

            return reserva;
        }

        public async Task<Reserva> ObterUltimaReserva()
        {
            Reserva reserva = null;

            var procedure = @"dbo.[ObterUltimaReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

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
                    PrecoUnitario = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"],
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
                        Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                        DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                        Email = (string)sqlDataReader["HSP_EMAIL_STR"],
                        Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
                        Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
                        Celular = (string)sqlDataReader["HSP_CELULAR_STR"],
                        Endereco = new Endereco
                        {
                            Cep = (string)sqlDataReader["END_CEP_CHAR"],
                            Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                            Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                            Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                            Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                            Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                            Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                            Pais = (string)sqlDataReader["END_PAIS_STR"]
                        }
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
                    Acompanhantes = (int)sqlDataReader["RES_ACOMPANHANTES_ID_INT"],
                    Excluido = (bool)sqlDataReader["RES_EXCLUIDO_BIT"]
                };
            }

            await sqlConnection.CloseAsync();

            return reserva;
        }

        public async Task Inserir(Reserva reserva)
        {
            var procedure = @"dbo.[InserirReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@DataCheckIn", SqlDbType.DateTime).Value = reserva.DataCheckIn;
            sqlCommand.Parameters.Add("@DataCheckOut", SqlDbType.DateTime).Value = reserva.DataCheckOut;
            sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NVarChar).Value = reserva.Hospede.Cpf;
            sqlCommand.Parameters.Add("@Acomodacao", SqlDbType.Int).Value = reserva.Acomodacao.Id;
            sqlCommand.Parameters.Add("@Pagamento", SqlDbType.Int).Value = reserva.Pagamento.Id;
            sqlCommand.Parameters.Add("@Acompanhantes", SqlDbType.Int).Value = reserva.Acompanhantes;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(int idReserva, Reserva reserva)
        {
            var procedure = @"[RECPAPAGAIOS].[dbo].[AtualizarReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;
            sqlCommand.Parameters.Add("@DataCheckIn", SqlDbType.DateTime).Value = reserva.DataCheckIn;
            sqlCommand.Parameters.Add("@DataCheckOut", SqlDbType.DateTime).Value = reserva.DataCheckOut;
            sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = reserva.Hospede.Cpf;
            sqlCommand.Parameters.Add("@AcomodacaoId", SqlDbType.Int).Value = reserva.Acomodacao.Id;
            sqlCommand.Parameters.Add("@PagamentoId", SqlDbType.Int).Value = reserva.Pagamento.Id;
            sqlCommand.Parameters.Add("@Acompanhantes", SqlDbType.Int).Value = reserva.Acompanhantes;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Deletar(int idReserva)
        {
            var procedure = @"dbo.[RemoverReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

    }
}
