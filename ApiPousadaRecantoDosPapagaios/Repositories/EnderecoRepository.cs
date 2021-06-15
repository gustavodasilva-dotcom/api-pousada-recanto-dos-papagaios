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
        private readonly IHospedeRepository _hospedeRepository;

        public EnderecoRepository(IConfiguration configuration, IHospedeRepository hospedeRepository)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
            _hospedeRepository = hospedeRepository;
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
                    Numero = (int)sqlDataReader["END_NUMERO_INT"],
                    Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                    Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                    Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                    Estado = (string)sqlDataReader["END_ESTADO_STR"],
                    Pais = (string)sqlDataReader["END_PAIS_STR"],
                    PessoaId = (int)sqlDataReader["END_ID_HOSPEDE_INT"]
                });
            }

            await sqlConnection.CloseAsync();

            return enderecos;
        }

        public async Task Inserir(Endereco endereco, int idHospede)
        {
            var comando = $"INSERT INTO dbo.ENDERECO VALUES ('{endereco.Cep}', '{endereco.Logradouro}', {endereco.Numero}, '{endereco.Complemento}', '{endereco.Bairro}', '{endereco.Cidade}', '{endereco.Estado}', '{endereco.Pais}', {idHospede}, {endereco.Excluido})";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }
    }
}
