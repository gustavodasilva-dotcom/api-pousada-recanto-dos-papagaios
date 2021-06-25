using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
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

            var comando = $"EXEC ObterEnderecos";

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
            var procedure = @"dbo.[InserirEnderecos]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;
            sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;
            sqlCommand.Parameters.Add("@Excluido", SqlDbType.Bit).Value = endereco.Excluido;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Inserir(Endereco endereco, string cpfHospede)
        {
            var procedure = @"dbo.[InserirEndereco]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
            sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;
            sqlCommand.Parameters.Add("@Excluido", SqlDbType.Bit).Value = endereco.Excluido;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(string cpfHospede, Endereco endereco)
        {
            var procedure = @"dbo.[AtualizarEndereco]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
            sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Remover(string cpfHospede)
        {
            var comando = $"EXEC RemoverEndereco '{cpfHospede}'";

            await sqlConnection.OpenAsync();

            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

    }
}
