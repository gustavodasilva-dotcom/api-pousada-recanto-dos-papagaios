using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class HospedeRepository : IHospedeRepository
    {
        private readonly SqlConnection sqlConnection;

        public HospedeRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public async Task<List<Hospede>> Obter(int pagina, int quantidade)
        {
            var hospedes = new List<Hospede>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterHospedes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
            sqlCommand.Parameters.Add("Quantidade", SqlDbType.Int).Value = quantidade;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                hospedes.Add(new Hospede
                {
                    Id = (int)sqlDataReader["HSP_ID_INT"],
                    NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                    Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                    DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                    Usuario = new Usuario
                    {
                        NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"],
                    },
                    Contatos = new Contatos
                    {
                        Email = (string)sqlDataReader["CONT_EMAIL_STR"],
                        Celular = (string)sqlDataReader["CONT_CELULAR_CHAR"],
                        Telefone = (string)sqlDataReader["CONT_TELEFONE_CHAR"]
                    },
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
                });
            }

            await sqlConnection.CloseAsync();

            return hospedes;
        }

        public async Task<Hospede> Obter(int idHospede)
        {
            Hospede hospede = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterHospedes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;

            await sqlConnection.OpenAsync();

            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                hospede = new Hospede
                {
                    Id = (int)sqlDataReader["HSP_ID_INT"],
                    NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                    Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                    DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                    Usuario = new Usuario
                    {
                        NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"],
                    },
                    Contatos = new Contatos
                    {
                        Email = (string)sqlDataReader["CONT_EMAIL_STR"],
                        Celular = (string)sqlDataReader["CONT_CELULAR_CHAR"],
                        Telefone = (string)sqlDataReader["CONT_TELEFONE_CHAR"]
                    },
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
                };
            }

            await sqlConnection.CloseAsync();

            return hospede;
        }

        //public async Task Inserir(Hospede hospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[InserirHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = hospede.NomeCompleto;
        //    sqlCommand.Parameters.Add("@Cpf", SqlDbType.NVarChar).Value = hospede.Cpf;
        //    sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = hospede.DataDeNascimento;
        //    sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = hospede.Email;
        //    sqlCommand.Parameters.Add("@Login", SqlDbType.NVarChar).Value = hospede.Login;
        //    sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = hospede.Senha;
        //    sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = hospede.Celular;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task<Hospede> ObterUltimoHospede()
        //{
        //    Hospede hospede = null;

        //    var procedure = $"[RECPAPAGAIOS].[dbo].[ObterUltimoHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        hospede = new Hospede
        //        {
        //            Id = (int)sqlDataReader["HSP_ID_INT"],
        //            NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
        //            Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
        //            DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
        //            Email = (string)sqlDataReader["HSP_EMAIL_STR"],
        //            Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
        //            Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
        //            Celular = (string)sqlDataReader["HSP_CELULAR_STR"]
        //        };
        //    }

        //    await sqlConnection.CloseAsync();

        //    return hospede;
        //}

        //public async Task<Hospede> ObterPorCpf(string cpfHospede)
        //{
        //    Hospede hospede = null;

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterPorCpf]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@cpfHospede", SqlDbType.NVarChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        hospede = new Hospede
        //        {
        //            Id = (int)sqlDataReader["HSP_ID_INT"],
        //            NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
        //            Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
        //            DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
        //            Email = (string)sqlDataReader["HSP_EMAIL_STR"],
        //            Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
        //            Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
        //            Celular = (string)sqlDataReader["HSP_CELULAR_STR"]
        //        };
        //    }

        //    await sqlConnection.CloseAsync();

        //    return hospede;
        //}

        //public async Task Atualizar(string cpfHospede, Hospede hospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[AtualizarHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = hospede.NomeCompleto;
        //    sqlCommand.Parameters.Add("@Cpf", SqlDbType.NVarChar).Value = hospede.Cpf;
        //    sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = hospede.DataDeNascimento;
        //    sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = hospede.Email;
        //    sqlCommand.Parameters.Add("@Login", SqlDbType.NVarChar).Value = hospede.Login;
        //    sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = hospede.Senha;
        //    sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = hospede.Celular;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task Remover(string cpfHospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[RemoverHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@cpfHospede", SqlDbType.NVarChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

    }
}
