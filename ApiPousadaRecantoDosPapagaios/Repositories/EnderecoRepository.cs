using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class EnderecoRepository /*: IEnderecoRepository*/
    {
        //private readonly SqlConnection sqlConnection;

        //public EnderecoRepository(IConfiguration configuration)
        //{
        //    sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        //}

        //public void Dispose()
        //{
        //    sqlConnection?.Close();
        //    sqlConnection?.Dispose();
        //}

        //public async Task<List<Endereco>> Obter()
        //{
        //    var enderecos = new List<Endereco>();

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterEnderecos]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        enderecos.Add(new Endereco
        //        {
        //            Cep = (string)sqlDataReader["END_CEP_CHAR"],
        //            Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
        //            Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
        //            Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
        //            Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
        //            Cidade = (string)sqlDataReader["END_CIDADE_STR"],
        //            Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
        //            Pais = (string)sqlDataReader["END_PAIS_STR"],
        //            PessoaId = (int)sqlDataReader["END_ID_HOSPEDE_INT"]
        //        });
        //    }

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();

        //    return enderecos;
        //}

        //public async Task InserirEnderecoFuncionario(Endereco endereco, string cpfHospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[InserirEnderecoFuncionario]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
        //    sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
        //    sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
        //    sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
        //    sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
        //    sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
        //    sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
        //    sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
        //    sqlCommand.Parameters.Add("@CpfFuncionario", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task InserirEnderecoHospede(Endereco endereco, string cpfHospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[InserirEnderecoHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
        //    sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
        //    sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
        //    sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
        //    sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
        //    sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
        //    sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
        //    sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
        //    sqlCommand.Parameters.Add("@CpfFuncionario", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task AtualizarEnderecoFuncionario(string cpfHospede, Endereco endereco)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[AtualizarEnderecoFuncionario]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
        //    sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
        //    sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
        //    sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
        //    sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
        //    sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
        //    sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
        //    sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
        //    sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task AtualizarEnderecoHospede(string cpfHospede, Endereco endereco)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[AtualizarEnderecoHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@Cep", SqlDbType.NChar).Value = endereco.Cep;
        //    sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = endereco.Logradouro;
        //    sqlCommand.Parameters.Add("@Numero", SqlDbType.NChar).Value = endereco.Numero;
        //    sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = endereco.Complemento;
        //    sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = endereco.Bairro;
        //    sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = endereco.Cidade;
        //    sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = endereco.Estado;
        //    sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = endereco.Pais;
        //    sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task RemoverEnderecoFuncionario(string cpfHospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[RemoverEnderecoFuncionario]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task RemoverEnderecoHospede(string cpfHospede)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[RemoverEnderecoHospede]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@CpfHospede", SqlDbType.NChar).Value = cpfHospede;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}
    }
}
