using ApiPousadaRecantoDosPapagaios.Entities;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public class AcomodacaoRepository /*: IAcomodacaoRepository*/
    {
        //private readonly SqlConnection sqlConnection;

        //public AcomodacaoRepository(IConfiguration configuration)
        //{
        //    sqlConnection = new SqlConnection(configuration.GetConnectionString("Default"));
        //}

        //public void Dispose()
        //{
        //    sqlConnection?.Close();
        //    sqlConnection?.Dispose();
        //}

        //public async Task<List<Acomodacao>> Obter()
        //{
        //    var acomodacoes = new List<Acomodacao>();

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterAcomodacoes]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        acomodacoes.Add(new Acomodacao
        //        {
        //            Id = (int)sqlDataReader["ACO_ID_INT"],
        //            Nome = (string)sqlDataReader["ACO_NOME_STR"],
        //            StatusAcomodacao = new StatusAcomodacao
        //            {
        //                Id = (int)sqlDataReader["ST_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["ST_ACOMOD_DESCRICAO_STR"]
        //            },
        //            InformacoesAcomodacao = new InformacoesAcomodacao
        //            {
        //                Id = (int)sqlDataReader["INFO_ACOMOD_ID_INT"],
        //                MetrosQuadrados = (float)sqlDataReader["INFO_ACOMOD_METROS_QUADRADOS_FLOAT"],
        //                Capacidade = (int)sqlDataReader["INFO_ACOMOD_CAPACIDADE_INT"],
        //                TipoDeCama = (string)sqlDataReader["INFO_ACOMOD_TIPO_DE_CAMA_STR"],
        //                Preco = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"]
        //            },
        //            CategoriaAcomodacao = new CategoriaAcomodacao
        //            {
        //                Id = (int)sqlDataReader["CAT_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["CAT_ACOMOD_DESCRICAO_STR"]
        //            }
        //        });
        //    }

        //    await sqlConnection.CloseAsync();

        //    return acomodacoes;
        //}

        //public async Task<Acomodacao> Obter(int idAcomodacao)
        //{
        //    Acomodacao acomodacao = null;

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterAcomodacao]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@idAcomodacao", SqlDbType.Int).Value = idAcomodacao;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        acomodacao = new Acomodacao
        //        {
        //            Id = (int)sqlDataReader["ACO_ID_INT"],
        //            Nome = (string)sqlDataReader["ACO_NOME_STR"],
        //            StatusAcomodacao = new StatusAcomodacao
        //            {
        //                Id = (int)sqlDataReader["ST_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["ST_ACOMOD_DESCRICAO_STR"]
        //            },
        //            InformacoesAcomodacao = new InformacoesAcomodacao
        //            {
        //                Id = (int)sqlDataReader["INFO_ACOMOD_ID_INT"],
        //                MetrosQuadrados = (float)sqlDataReader["INFO_ACOMOD_METROS_QUADRADOS_FLOAT"],
        //                Capacidade = (int)sqlDataReader["INFO_ACOMOD_CAPACIDADE_INT"],
        //                TipoDeCama = (string)sqlDataReader["INFO_ACOMOD_TIPO_DE_CAMA_STR"],
        //                Preco = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"]
        //            },
        //            CategoriaAcomodacao = new CategoriaAcomodacao
        //            {
        //                Id = (int)sqlDataReader["CAT_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["CAT_ACOMOD_DESCRICAO_STR"]
        //            }
        //        };
        //    }

        //    await sqlConnection.CloseAsync();

        //    return acomodacao;
        //}

        //public async Task<Acomodacao> ObterUltimoRegistro()
        //{
        //    Acomodacao acomodacao = null;

        //    var procedure = @"[RECPAPAGAIOS].[dbo].[ObterUltimaAcomodacao]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    await sqlConnection.OpenAsync();

        //    SqlDataReader sqlDataReader = await sqlCommand.ExecuteReaderAsync();

        //    while (sqlDataReader.Read())
        //    {
        //        acomodacao = new Acomodacao
        //        {
        //            Id = (int)sqlDataReader["ACO_ID_INT"],
        //            Nome = (string)sqlDataReader["ACO_NOME_STR"],
        //            StatusAcomodacao = new StatusAcomodacao
        //            {
        //                Id = (int)sqlDataReader["ST_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["ST_ACOMOD_DESCRICAO_STR"]
        //            },
        //            InformacoesAcomodacao = new InformacoesAcomodacao
        //            {
        //                Id = (int)sqlDataReader["INFO_ACOMOD_ID_INT"],
        //                MetrosQuadrados = (float)sqlDataReader["INFO_ACOMOD_METROS_QUADRADOS_FLOAT"],
        //                Capacidade = (int)sqlDataReader["INFO_ACOMOD_CAPACIDADE_INT"],
        //                TipoDeCama = (string)sqlDataReader["INFO_ACOMOD_TIPO_DE_CAMA_STR"],
        //                Preco = (float)sqlDataReader["INFO_ACOMOD_PRECO_FLOAT"]
        //            },
        //            CategoriaAcomodacao = new CategoriaAcomodacao
        //            {
        //                Id = (int)sqlDataReader["CAT_ACOMOD_ID_INT"],
        //                Descricao = (string)sqlDataReader["CAT_ACOMOD_DESCRICAO_STR"]
        //            }
        //        };
        //    }

        //    await sqlConnection.CloseAsync();

        //    return acomodacao;
        //}

        //public async Task Inserir(Acomodacao acomodacao)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[InserirAcomodacao]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@NomeAcomodacao", SqlDbType.NVarChar).Value = acomodacao.Nome;
        //    sqlCommand.Parameters.Add("@StatusAcomodacao", SqlDbType.Int).Value = acomodacao.StatusAcomodacao.Id;
        //    sqlCommand.Parameters.Add("@InformacoesAcomodacao", SqlDbType.Int).Value = acomodacao.InformacoesAcomodacao.Id;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}

        //public async Task Deletar(int idAcomodacao)
        //{
        //    var procedure = @"[RECPAPAGAIOS].[dbo].[RemoverAcomodacao]";

        //    SqlCommand sqlCommand = new SqlCommand(procedure, sqlConnection);

        //    sqlCommand.CommandType = CommandType.StoredProcedure;

        //    sqlCommand.Parameters.Add("@idAcomodacao", SqlDbType.Int).Value = idAcomodacao;

        //    await sqlConnection.OpenAsync();

        //    sqlCommand.ExecuteNonQuery();

        //    await sqlConnection.CloseAsync();
        //}
    }
}
