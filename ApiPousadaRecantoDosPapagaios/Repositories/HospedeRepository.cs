using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
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

        public async Task<List<Hospede>> Obter(int pagina, int quantidade)
        {
            #region SQL

            var hospedes = new List<Hospede>();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterHospedes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@Pagina", SqlDbType.Int).Value = pagina;
            sqlCommand.Parameters.Add("Quantidade", SqlDbType.Int).Value = quantidade;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

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

            #endregion SQL

            return hospedes;
        }

        public async Task<Hospede> Obter(int idHospede)
        {
            #region SQL

            Hospede hospede = null;

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspObterHospedes]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;
            sqlCommand.Parameters.Add("@Tipo", SqlDbType.Int).Value = 1;

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

            #endregion SQL

            return hospede;
        }

        public async Task<Retorno> Inserir(Hospede hospede, string json)
        {
            #region SQL

            var retorno = new Retorno();
            
            var dataTable = new DataTable();

            var procedure = "[RECPAPAGAIOS].[dbo].[uspCadastrarHospede]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = hospede.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NVarChar).Value = hospede.Cpf;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = hospede.DataDeNascimento;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = hospede.Contatos.Email;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = hospede.Contatos.Celular;
            sqlCommand.Parameters.Add("@Telefone", SqlDbType.NVarChar).Value = hospede.Contatos.Telefone;
            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = hospede.Usuario.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = hospede.Usuario.SenhaUsuario;
            sqlCommand.Parameters.Add("@Cep", SqlDbType.NVarChar).Value = hospede.Endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = hospede.Endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NVarChar).Value = hospede.Endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = hospede.Endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = hospede.Endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = hospede.Endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = hospede.Endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = hospede.Endereco.Pais;
            sqlCommand.Parameters.Add("@Json", SqlDbType.VarChar).Value = json;

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

        public async Task<Hospede> Atualizar(int idHospede, Hospede hospede, HospedeInputModel hospedeJson)
        {
            var procedure = @"[RECPAPAGAIOS].[dbo].[uspAtualizarHospede]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospedeRota", SqlDbType.Int).Value = idHospede;
            sqlCommand.Parameters.Add("@NomeCompleto", SqlDbType.NVarChar).Value = hospede.NomeCompleto;
            sqlCommand.Parameters.Add("@Cpf", SqlDbType.NVarChar).Value = hospede.Cpf;
            sqlCommand.Parameters.Add("@DataDeNascimento", SqlDbType.Date).Value = hospede.DataDeNascimento;
            sqlCommand.Parameters.Add("@Email", SqlDbType.NVarChar).Value = hospede.Contatos.Email;
            sqlCommand.Parameters.Add("@Celular", SqlDbType.NVarChar).Value = hospede.Contatos.Celular;
            sqlCommand.Parameters.Add("@Telefone", SqlDbType.NVarChar).Value = hospede.Contatos.Telefone;
            sqlCommand.Parameters.Add("@NomeUsuario", SqlDbType.NVarChar).Value = hospede.Usuario.NomeUsuario;
            sqlCommand.Parameters.Add("@Senha", SqlDbType.NVarChar).Value = hospede.Usuario.SenhaUsuario;
            sqlCommand.Parameters.Add("@Cep", SqlDbType.NVarChar).Value = hospede.Endereco.Cep;
            sqlCommand.Parameters.Add("@Logradouro", SqlDbType.NVarChar).Value = hospede.Endereco.Logradouro;
            sqlCommand.Parameters.Add("@Numero", SqlDbType.NVarChar).Value = hospede.Endereco.Numero;
            sqlCommand.Parameters.Add("@Complemento", SqlDbType.NVarChar).Value = hospede.Endereco.Complemento;
            sqlCommand.Parameters.Add("@Bairro", SqlDbType.NVarChar).Value = hospede.Endereco.Bairro;
            sqlCommand.Parameters.Add("@Cidade", SqlDbType.NVarChar).Value = hospede.Endereco.Cidade;
            sqlCommand.Parameters.Add("@Estado", SqlDbType.NVarChar).Value = hospede.Endereco.Estado;
            sqlCommand.Parameters.Add("@Pais", SqlDbType.NVarChar).Value = hospede.Endereco.Pais;
            //sqlCommand.Parameters.Add("@HospedeJson", SqlDbType.NVarChar).Value = json;

            await sqlConnection.OpenAsync();

            sqlCommand.ExecuteNonQuery();

            await sqlConnection.CloseAsync();

            var hospedeRetorno = await Obter(idHospede);

            return hospedeRetorno;
        }

        public async Task<Retorno> Remover(int idHospede)
        {
            #region SQL

            var dataTable = new DataTable();

            var retorno = new Retorno();

            var procedure = @"[RECPAPAGAIOS].[dbo].[uspDeletarHospede]";

            SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

            sqlCommand.CommandType = CommandType.StoredProcedure;

            sqlCommand.Parameters.Add("@IdHospede", SqlDbType.Int).Value = idHospede;

            try
            {
                await sqlConnection.OpenAsync();

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

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
