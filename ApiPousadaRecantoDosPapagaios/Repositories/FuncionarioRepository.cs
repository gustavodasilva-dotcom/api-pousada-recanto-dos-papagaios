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

        public async Task<List<Funcionario>> Obter(int pagina, int quantidade)
        {
            #region SQL

            var funcionarios = new List<Funcionario>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterFuncionarios]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;
            sqlCommand.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
            sqlCommand.Parameters.Add("@Quantidade", SqlDbType.Int).Value = quantidade;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

                while (sqlDataReader.Read())
                {
                    funcionarios.Add(new Funcionario
                    {
                        Id = (int)sqlDataReader["FUNC_ID_INT"],
                        NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                        Cpf = (string)sqlDataReader["FUNC_CPF_CHAR"],
                        Nacionalidade = (string)sqlDataReader["FUNC_NACIONALIDADE_STR"],
                        DataDeNascimento = (DateTime)sqlDataReader["FUNC_DTNASC_DATE"],
                        Sexo = (string)sqlDataReader["FUNC_SEXO_CHAR"],
                        Rg = (string)sqlDataReader["FUNC_RG_CHAR"],
                        Cargo = (string)sqlDataReader["FUNC_CARGO_STR"],
                        Setor = (string)sqlDataReader["FUNC_SETOR_STR"],
                        Salario = (float)sqlDataReader["FUNC_SALARIO_FLOAT"],
                        Usuario = new Usuario
                        {
                            NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"]
                        },
                        CategoriaAcesso = new CategoriaAcesso
                        {
                            Descricao = (string)sqlDataReader["CATACESSO_DESCRICAO_STR"]
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
                        },
                        DadosBancarios = new DadosBancarios
                        {
                            Banco = (string)sqlDataReader["DADOSBC_BANCO_STR"],
                            Agencia = (string)sqlDataReader["DADOSBC_AGENCIA_STR"],
                            NumeroDaConta = (string)sqlDataReader["DADOSBC_NUMERO_CONTA_STR"]
                        }
                    });
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return funcionarios;
        }

        public async Task<Funcionario> Obter(int idFuncionario)
        {
            #region SQL

            Funcionario funcionario = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterFuncionarios]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;
            sqlCommand.Parameters.Add("@IdFuncionario", SqlDbType.Int).Value = idFuncionario;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

                while (sqlDataReader.Read())
                {
                    funcionario = new Funcionario
                    {
                        Id = (int)sqlDataReader["FUNC_ID_INT"],
                        NomeCompleto = (string)sqlDataReader["FUNC_NOME_STR"],
                        Cpf = (string)sqlDataReader["FUNC_CPF_CHAR"],
                        Nacionalidade = (string)sqlDataReader["FUNC_NACIONALIDADE_STR"],
                        DataDeNascimento = (DateTime)sqlDataReader["FUNC_DTNASC_DATE"],
                        Sexo = (string)sqlDataReader["FUNC_SEXO_CHAR"],
                        Rg = (string)sqlDataReader["FUNC_RG_CHAR"],
                        Cargo = (string)sqlDataReader["FUNC_CARGO_STR"],
                        Setor = (string)sqlDataReader["FUNC_SETOR_STR"],
                        Salario = (float)sqlDataReader["FUNC_SALARIO_FLOAT"],
                        Usuario = new Usuario
                        {
                            NomeUsuario = (string)sqlDataReader["USU_NOME_USUARIO_STR"]
                        },
                        CategoriaAcesso = new CategoriaAcesso
                        {
                            Descricao = (string)sqlDataReader["CATACESSO_DESCRICAO_STR"]
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
                        },
                        DadosBancarios = new DadosBancarios
                        {
                            Banco = (string)sqlDataReader["DADOSBC_BANCO_STR"],
                            Agencia = (string)sqlDataReader["DADOSBC_AGENCIA_STR"],
                            NumeroDaConta = (string)sqlDataReader["DADOSBC_NUMERO_CONTA_STR"]
                        }
                    };
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return funcionario;
        }

        public async Task<Retorno> Inserir(Funcionario funcionario, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();
            
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspCadastrarFuncionario]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Nome", SqlDbType.NVarChar).Value = funcionario.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = funcionario.Cpf;
            sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = funcionario.Nacionalidade;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = funcionario.DataDeNascimento;
            sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = funcionario.Sexo;
            sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = funcionario.Rg;
            sqlCommand.Parameters.Add("@Cargo", SqlDbType.NVarChar).Value = funcionario.Cargo;
            sqlCommand.Parameters.Add("@Setor", SqlDbType.NVarChar).Value = funcionario.Setor;
            sqlCommand.Parameters.Add("@Salario", SqlDbType.Float).Value = funcionario.Salario;
            sqlCommand.Parameters.Add("@Cep", SqlDbType.NVarChar).Value = funcionario.Endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = funcionario.Endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NVarChar).Value = funcionario.Endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = funcionario.Endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = funcionario.Endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = funcionario.Endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = funcionario.Endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = funcionario.Endereco.Pais;
            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = funcionario.Usuario.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = funcionario.Usuario.SenhaUsuario;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = funcionario.Contatos.Email;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = funcionario.Contatos.Celular;
            sqlCommand.Parameters.Add("@Telefone", SqlDbType.NVarChar).Value = funcionario.Contatos.Telefone;
            sqlCommand.Parameters.Add("@CategoriaAcesso", SqlDbType.Int).Value = funcionario.CategoriaAcesso.Id;
            sqlCommand.Parameters.Add("@Banco", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.Banco;
            sqlCommand.Parameters.Add("@Agencia", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.Agencia;
            sqlCommand.Parameters.Add("@NumeroConta", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.NumeroDaConta;
            sqlCommand.Parameters.Add("@PerguntaSeguranca", SqlDbType.NVarChar).Value = funcionario.PerguntaDeSeguranca.PerguntaSeguranca;
            sqlCommand.Parameters.Add("@RespostaSeguranca", SqlDbType.NVarChar).Value = funcionario.PerguntaDeSeguranca.RespostaSeguranca;
            sqlCommand.Parameters.Add("@Json", SqlDbType.NVarChar).Value = json;

            try
            {
                await sqlConnection.OpenAsync();

                var sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                sqlDataAdapter.Fill(dataTable);

                retorno.StatusCode = (int)dataTable.Rows[0]["Codigo"];
                retorno.Mensagem = dataTable.Rows[0]["Mensagem"].ToString();
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }

            #endregion SQL

            return retorno;
        }

        public async Task<Retorno> Atualizar(int idFuncionario, Funcionario funcionario, string json)
        {
            #region SQL

            var retorno = new Retorno();

            var dataTable = new DataTable();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspAtualizarFuncionario]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdFuncionarioRota", SqlDbType.Int).Value = idFuncionario;
            sqlCommand.Parameters.Add("@Nome", SqlDbType.NVarChar).Value = funcionario.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NChar).Value = funcionario.Cpf;
            sqlCommand.Parameters.Add("@Nacionalidade", SqlDbType.NVarChar).Value = funcionario.Nacionalidade;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = funcionario.DataDeNascimento;
            sqlCommand.Parameters.Add("@Sexo", SqlDbType.NChar).Value = funcionario.Sexo;
            sqlCommand.Parameters.Add("@Rg", SqlDbType.NChar).Value = funcionario.Rg;
            sqlCommand.Parameters.Add("@Cargo", SqlDbType.NVarChar).Value = funcionario.Cargo;
            sqlCommand.Parameters.Add("@Setor", SqlDbType.NVarChar).Value = funcionario.Setor;
            sqlCommand.Parameters.Add("@Salario", SqlDbType.Float).Value = funcionario.Salario;
            sqlCommand.Parameters.Add("@Cep", SqlDbType.NVarChar).Value = funcionario.Endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = funcionario.Endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NVarChar).Value = funcionario.Endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = funcionario.Endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = funcionario.Endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = funcionario.Endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = funcionario.Endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = funcionario.Endereco.Pais;
            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = funcionario.Usuario.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = funcionario.Usuario.SenhaUsuario;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = funcionario.Contatos.Email;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = funcionario.Contatos.Celular;
            sqlCommand.Parameters.Add("@Telefone", SqlDbType.NVarChar).Value = funcionario.Contatos.Telefone;
            sqlCommand.Parameters.Add("@CategoriaAcesso", SqlDbType.Int).Value = funcionario.CategoriaAcesso.Id;
            sqlCommand.Parameters.Add("@Banco", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.Banco;
            sqlCommand.Parameters.Add("@Agencia", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.Agencia;
            sqlCommand.Parameters.Add("@NumeroConta", SqlDbType.NVarChar).Value = funcionario.DadosBancarios.NumeroDaConta;
            sqlCommand.Parameters.Add("@PerguntaSeguranca", SqlDbType.NVarChar).Value = funcionario.PerguntaDeSeguranca.PerguntaSeguranca;
            sqlCommand.Parameters.Add("@RespostaSeguranca", SqlDbType.NVarChar).Value = funcionario.PerguntaDeSeguranca.RespostaSeguranca;
            sqlCommand.Parameters.Add("@Json", SqlDbType.NVarChar).Value = json;

            try
            {
                await sqlConnection.OpenAsync();

                var sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                sqlDataAdapter.Fill(dataTable);

                retorno.StatusCode = (int)dataTable.Rows[0]["Codigo"];
                retorno.Mensagem = dataTable.Rows[0]["Mensagem"].ToString();
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                await sqlConnection.CloseAsync();
            }
            
            #endregion SQL

            return retorno;
        }
    }
}
