using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class EnderecoRepository : IEnderecoRepository
    {
        private readonly SqlConnection sqlConnection;

        public EnderecoRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<List<Endereco>> Obter()
        {
            var enderecos = new List<Endereco>();

            var comando = $"SELECT * FROM ENDERECO";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                enderecos.Add(new Endereco
                {
                    Cep = (string)sqlDataReader["END_CEP_CHAR"],
                    Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                    Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                    Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                    Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                    Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                    Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                    Pais = (string)sqlDataReader["END_PAIS_STR"],
                    PessoaId = (int)sqlDataReader["END_ID_HOSPEDE_INT"]
                });
            }

            await sqlConnection.CloseAsync();

            return enderecos;
        }

        public async Task Inserir(Endereco endereco, string cpfHospede, int idHospede)
        {
            var comando = $"INSERT INTO dbo.ENDERECO VALUES ('{endereco.Cep}', '{endereco.Logradouro}', '{endereco.Numero}', '{endereco.Complemento}', '{endereco.Bairro}', '{endereco.Cidade}', '{endereco.Estado}', '{endereco.Pais}', {idHospede}, '{cpfHospede}', {endereco.Excluido})";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(string cpfHospede, Endereco endereco)
        {
            var comando = $"UPDATE dbo.ENDERECO SET END_CEP_CHAR = '{endereco.Cep}', END_LOGRADOURO_STR = '{endereco.Logradouro}', END_NUMERO_CHAR = '{endereco.Numero}', END_COMPLEMENTO_STR = '{endereco.Complemento}', END_BAIRRO_STR = '{endereco.Bairro}', END_CIDADE_STR = '{endereco.Cidade}', END_ESTADO_CHAR = '{endereco.Estado}', END_PAIS_STR = '{endereco.Pais}' WHERE (dbo.ENDERECO.END_CPF_HOSPEDE_STR = '{cpfHospede}') AND (dbo.ENDERECO.END_EXCLUIDO_BIT = 0)";
            
            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            await sqlCommand.ExecuteNonQueryAsync();

            await sqlConnection.CloseAsync();
        }

        public async Task Remover(string cpfHospede)
        {
            var comando = $"UPDATE dbo.ENDERECO SET dbo.ENDERECO.END_EXCLUIDO_BIT = 1 WHERE dbo.ENDERECO.END_CPF_HOSPEDE_STR = '{cpfHospede}'";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            await sqlCommand.ExecuteNonQueryAsync();

            await sqlConnection.CloseAsync();
        }

    }
}
