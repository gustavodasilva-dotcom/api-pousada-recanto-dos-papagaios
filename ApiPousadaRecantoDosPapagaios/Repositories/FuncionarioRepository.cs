using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class FuncionarioRepository : IFuncionarioRepository
    {
        private readonly SqlConnection sqlConnection;

        public FuncionarioRepository(IConfiguration configuration)
        {
            sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        }

        public void Dispose()
        {
            sqlConnection?.Close();
            sqlConnection?.Dispose();
        }

        public async Task<List<Funcionario>> Obter()
        {
            var funcionarios = new List<Funcionario>();

            var procedure = @"dbo.[ObterFuncionarios]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            await sqlConnection.OpenAsync();
            
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                funcionarios.Add(new Funcionario
                {
                    Id = (int)sqlDataReader["FUNC_ID_INT"],
                    NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                    Cpf = (string)sqlDataReader["FUNC_CPF_CHAR"],
                    DataDeNascimento = (DateTime)sqlDataReader["FUNC_DTNASC_DATE"],
                    Email = (string)sqlDataReader["FUNC_EMAIL_STR"],
                    Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"],
                    Senha = (string)sqlDataReader["FUNC_SENHA_USUARIO_STR"],
                    Celular = (string)sqlDataReader["FUNC_CELULAR_CHAR"],
                    Endereco = new Endereco
                    {
                        Id = (int)sqlDataReader["END_FUNC_ID_ENDERECO_INT"],
                        Cep = (string)sqlDataReader["END_FUNC_CEP_CHAR"],
                        Logradouro = (string)sqlDataReader["END_FUNC_LOGRADOURO_STR"],
                        Numero = (string)sqlDataReader["END_FUNC_NUMERO_CHAR"],
                        Complemento = (string)sqlDataReader["END_FUNC_COMPLEMENTO_STR"],
                        Bairro = (string)sqlDataReader["END_FUNC_BAIRRO_STR"],
                        Cidade = (string)sqlDataReader["END_FUNC_CIDADE_STR"],
                        Estado = (string)sqlDataReader["END_FUNC_ESTADO_CHAR"],
                        Pais = (string)sqlDataReader["END_FUNC_PAIS_STR"],
                        CpfPessoa = (string)sqlDataReader["END_FUNC_CPF_HOSPEDE_STR"]
                    },
                    Nacionalidade = (string)sqlDataReader["FUNC_NACIONALIDADE_STR"],
                    Sexo = (string)sqlDataReader["FUNC_SEXO_CHAR"],
                    Rg = (string)sqlDataReader["FUNC_RG_CHAR"],
                    Cargo = (string)sqlDataReader["FUNC_CARGO_STR"],
                    Setor = (string)sqlDataReader["FUNC_SETOR_STR"],
                    Salario = (float)sqlDataReader["FUNC_SALARIO_FLOAT"],
                    DadosBancarios = new DadosBancarios
                    {
                        Id = (int)sqlDataReader["DADOSBC_ID_INT"],
                        Banco = (string)sqlDataReader["DADOSBC_BANCO_STR"],
                        Agencia = (string)sqlDataReader["DADOSBC_AGENCIA_STR"],
                        NumeroDaConta = (string)sqlDataReader["DADOSBC_NUMERO_CONTA_STR"],
                        CpfFuncionario = (string)sqlDataReader["DADOSBC_FUNCIONARIO_CPF_CHAR"]
                    },
                    CategoriaAcesso = new CategoriaAcesso
                    {
                        Id = (int)sqlDataReader["FUNC_CATACESSO_ID_INT"]
                    }
                });
            }

            await sqlConnection.CloseAsync();

            return funcionarios;
        }

        public async Task<Funcionario> Obter(string cpfFuncionario)
        {
            Funcionario funcionario = null;

            var procedure = @"ObterFuncionario";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@CpfFuncionario", SqlDbType.NChar).Value = cpfFuncionario;

            await sqlConnection.OpenAsync();
            
            SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

            while (sqlDataReader.Read())
            {
                funcionario = new Funcionario
                {
                    Id = (int)sqlDataReader["FUNC_ID_INT"],
                    NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                    Cpf = (string)sqlDataReader["FUNC_CPF_CHAR"],
                    DataDeNascimento = (DateTime)sqlDataReader["FUNC_DTNASC_DATE"],
                    Email = (string)sqlDataReader["FUNC_EMAIL_STR"],
                    Login = (string)sqlDataReader["FUNC_NOME_USUARIO_STR"],
                    Senha = (string)sqlDataReader["FUNC_SENHA_USUARIO_STR"],
                    Celular = (string)sqlDataReader["FUNC_CELULAR_CHAR"],
                    Endereco = new Endereco
                    {
                        Id = (int)sqlDataReader["END_FUNC_ID_ENDERECO_INT"],
                        Cep = (string)sqlDataReader["END_FUNC_CEP_CHAR"],
                        Logradouro = (string)sqlDataReader["END_FUNC_LOGRADOURO_STR"],
                        Numero = (string)sqlDataReader["END_FUNC_NUMERO_CHAR"],
                        Complemento = (string)sqlDataReader["END_FUNC_COMPLEMENTO_STR"],
                        Bairro = (string)sqlDataReader["END_FUNC_BAIRRO_STR"],
                        Cidade = (string)sqlDataReader["END_FUNC_CIDADE_STR"],
                        Estado = (string)sqlDataReader["END_FUNC_ESTADO_CHAR"],
                        Pais = (string)sqlDataReader["END_FUNC_PAIS_STR"],
                        CpfPessoa = (string)sqlDataReader["END_FUNC_CPF_HOSPEDE_STR"]
                    },
                    Nacionalidade = (string)sqlDataReader["FUNC_NACIONALIDADE_STR"],
                    Sexo = (string)sqlDataReader["FUNC_SEXO_CHAR"],
                    Rg = (string)sqlDataReader["FUNC_RG_CHAR"],
                    Cargo = (string)sqlDataReader["FUNC_CARGO_STR"],
                    Setor = (string)sqlDataReader["FUNC_SETOR_STR"],
                    Salario = (float)sqlDataReader["FUNC_SALARIO_FLOAT"],
                    DadosBancarios = new DadosBancarios
                    {
                        Id = (int)sqlDataReader["DADOSBC_ID_INT"],
                        Banco = (string)sqlDataReader["DADOSBC_BANCO_STR"],
                        Agencia = (string)sqlDataReader["DADOSBC_AGENCIA_STR"],
                        NumeroDaConta = (string)sqlDataReader["DADOSBC_NUMERO_CONTA_STR"],
                        CpfFuncionario = (string)sqlDataReader["DADOSBC_FUNCIONARIO_CPF_CHAR"]
                    },
                    CategoriaAcesso = new CategoriaAcesso
                    {
                        Id = (int)sqlDataReader["FUNC_CATACESSO_ID_INT"]
                    }
                };
            }

            await sqlConnection.CloseAsync();

            return funcionario;
        }

        public async Task Inserir(Funcionario funcionario)
        {
            var procedure = @"dbo.[InserirFuncionario]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = funcionario.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = funcionario.Cpf;
            sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = funcionario.Nacionalidade;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = funcionario.DataDeNascimento;
            sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = funcionario.Sexo;
            sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = funcionario.Rg;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NChar).Value = funcionario.Celular;
            sqlCommand.Parameters.Add("@Cargo", SqlDbType.NVarChar).Value = funcionario.Cargo;
            sqlCommand.Parameters.Add("@Setor", SqlDbType.NVarChar).Value = funcionario.Setor;
            sqlCommand.Parameters.Add("@Salario", SqlDbType.Float).Value = funcionario.Salario;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = funcionario.Email;
            sqlCommand.Parameters.Add("@Login", SqlDbType.NVarChar).Value = funcionario.Login;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = funcionario.Senha;
            sqlCommand.Parameters.Add("@IdCategoriaAcesso", SqlDbType.Int).Value = funcionario.CategoriaAcesso.Id;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }

        public async Task Atualizar(string cpfFuncionario, Funcionario funcionario)
        {
            var procedure = @"dbo.[AtualizarFuncionario]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            // TODO: Verificar ordem.
            sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = funcionario.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = funcionario.Cpf;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = funcionario.DataDeNascimento;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = funcionario.Email;
            sqlCommand.Parameters.Add("@Login", SqlDbType.NVarChar).Value = funcionario.Login;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = funcionario.Senha;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NChar).Value = funcionario.Celular;
            sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = funcionario.Nacionalidade;
            sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = funcionario.Sexo;
            sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = funcionario.Rg;
            sqlCommand.Parameters.Add("@Cargo", SqlDbType.NVarChar).Value = funcionario.Cargo;
            sqlCommand.Parameters.Add("@Setor", SqlDbType.NVarChar).Value = funcionario.Setor;
            sqlCommand.Parameters.Add("@Salario", SqlDbType.Float).Value = funcionario.Salario;
            sqlCommand.Parameters.Add("@Catacesso", SqlDbType.Int).Value = funcionario.CategoriaAcesso.Id;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();
        }
    }
}
