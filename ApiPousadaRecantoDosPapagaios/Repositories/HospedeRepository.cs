using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class HospedeRepository : IHospedeRepository
    {
        private readonly SqlConnection sqlConnection;

        public HospedeRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<List<Hospede>> Obter()
        {
            var hospedes = new List<Hospede>();

            var comando = $"SELECT * FROM dbo.HOSPEDE AS H, dbo.ENDERECO AS E WHERE H.HSP_ID_INT = E.END_ID_HOSPEDE_INT";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                hospedes.Add(new Hospede
                {
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
                        Numero = (int)sqlDataReader["END_NUMERO_INT"],
                        Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                        Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                        Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                        Estado = (string)sqlDataReader["END_ESTADO_STR"],
                        Pais = (string)sqlDataReader["END_PAIS_STR"]
                    },
                });
            }

            await sqlConnection.CloseAsync();

            return hospedes;
        }

        public async Task Inserir(Hospede hospede)
        {
            var comando = $"INSERT INTO dbo.HOSPEDE VALUES ('{hospede.NomeCompleto}', '{hospede.Cpf}', '{hospede.DataDeNascimento}', '{hospede.Email}', '{hospede.Login}', '{hospede.Senha}', '{hospede.Celular}', {hospede.Excluido})";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task<Hospede> ObterUltimoHospede()
        {
            Hospede hospede = null;

            var comando = $"SELECT TOP 1 * FROM dbo.HOSPEDE ORDER BY HSP_ID_INT DESC";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                hospede = new Hospede
                {
                    Id = (int)sqlDataReader["HSP_ID_INT"],
                    NomeCompleto = (string)sqlDataReader["HSP_NOME_STR"],
                    Cpf = (string)sqlDataReader["HSP_CPF_CHAR"],
                    DataDeNascimento = (DateTime)sqlDataReader["HSP_DTNASC_DATE"],
                    Email = (string)sqlDataReader["HSP_EMAIL_STR"],
                    Login = (string)sqlDataReader["HSP_LOGIN_CPF_CHAR"],
                    Senha = (string)sqlDataReader["HSP_LOGIN_SENHA_STR"],
                    Celular = (string)sqlDataReader["HSP_CELULAR_STR"]
                };
            }

            await sqlConnection.CloseAsync();

            return hospede;
        }
    }
}
