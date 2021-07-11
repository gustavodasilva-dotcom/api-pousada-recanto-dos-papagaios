using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class CheckInRepository : ICheckInRepository
    {
        private readonly SqlConnection sqlConnection;

        public CheckInRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<List<CheckIn>> Obter(int pagina, int quantidade)
        {
            var checkIns = new List<CheckIn>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[ObterCheckIns]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
            sqlCommand.Parameters.Add("@Quantidade", SqlDbType.Int).Value = quantidade;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                checkIns.Add(new CheckIn
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
                    },
                    Funcionario = new Funcionario
                    {
                        Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"]
                    },
                    Excluido = (bool)sqlDataReader["CHECKIN_EXCLUIDO_BIT"]
                });
            }

            await sqlConnection.CloseAsync();

            return checkIns;
        }

        public async Task<CheckIn> Obter(int idCheckIn)
        {
            CheckIn checkIn = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[ObterCheckIn]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdCheckIn", SqlDbType.Int).Value = idCheckIn;

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
                    },
                    Funcionario = new Funcionario
                    {
                        Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"]
                    },
                    Excluido = (bool)sqlDataReader["CHECKIN_EXCLUIDO_BIT"]
                };
            }

            await sqlConnection.CloseAsync();

            return checkIn;
        }

        public async Task<CheckIn> ObterCheckInPorReserva(int idReserva)
        {
            CheckIn checkIn = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[ObterCheckInPorReserva]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = idReserva;

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
                    },
                    Funcionario = new Funcionario
                    {
                        Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"]
                    },
                    Excluido = (bool)sqlDataReader["CHECKIN_EXCLUIDO_BIT"]
                };
            }

            await sqlConnection.CloseAsync();

            return checkIn;
        }

        public async Task Inserir(CheckIn checkIn)
        {
            var procedure = @"[RECPAPAGAIOS].[dbo].[InserirCheckIn]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdReserva", SqlDbType.Int).Value = checkIn.Reserva.Id;
            sqlCommand.Parameters.Add("@LoginFuncionario", SqlDbType.NVarChar).Value = checkIn.Funcionario.Login;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

    }
}
