using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
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

            var comando = $"EXEC ObterFuncionarios";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
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
                        Id = (int)sqlDataReader["END_ID_ENDERECO_INT"],
                        Cep = (string)sqlDataReader["END_CEP_CHAR"],
                        Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                        Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                        Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                        Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                        Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                        Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                        Pais = (string)sqlDataReader["END_PAIS_STR"],
                        PessoaId = (int)sqlDataReader["END_ID_HOSPEDE_INT"],
                        CpfPessoa = (string)sqlDataReader["END_CPF_HOSPEDE_STR"]
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
                        IdFuncionario = (int)sqlDataReader["DADOSBC_FUNCIONARIO_ID_INT"],
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

            var comando = $"EXEC ObterFuncionario '{cpfFuncionario}'";

            await sqlConnection.OpenAsync();
            SqlCommand sqlCommand = new SqlCommand(comando, sqlConnection);
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
                        Id = (int)sqlDataReader["END_ID_ENDERECO_INT"],
                        Cep = (string)sqlDataReader["END_CEP_CHAR"],
                        Logradouro = (string)sqlDataReader["END_LOGRADOURO_STR"],
                        Numero = (string)sqlDataReader["END_NUMERO_CHAR"],
                        Complemento = (string)sqlDataReader["END_COMPLEMENTO_STR"],
                        Bairro = (string)sqlDataReader["END_BAIRRO_STR"],
                        Cidade = (string)sqlDataReader["END_CIDADE_STR"],
                        Estado = (string)sqlDataReader["END_ESTADO_CHAR"],
                        Pais = (string)sqlDataReader["END_PAIS_STR"],
                        PessoaId = (int)sqlDataReader["END_ID_HOSPEDE_INT"],
                        CpfPessoa = (string)sqlDataReader["END_CPF_HOSPEDE_STR"]
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
                        IdFuncionario = (int)sqlDataReader["DADOSBC_FUNCIONARIO_ID_INT"],
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
    }
}
