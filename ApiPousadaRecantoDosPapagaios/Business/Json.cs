using ApiPousadaRecantoDosPapagaios.Entities;
using Newtonsoft.Json;
using System.Data;

namespace ApiPousadaRecantoDosPapagaios.Business
{
    public class Json
    {
        public string ConverterModelParaJson(object reservaJson)
        {
            var json = JsonConvert.SerializeObject(reservaJson);

            return json;
        }

        public Retorno SerializarJsonDeRetorno(DataTable dataTable)
        {
            var retornoJson = new Retorno
            {
                StatusCode = (int)dataTable.Rows[0]["Codigo"],
                Mensagem = dataTable.Rows[0]["Mensagem"].ToString()
            };

            return retornoJson;
        }

        public Retorno SerializarJsonDeRetorno(int statusCode, string mensagem)
        {
            var retornoJson = new Retorno
            {
                StatusCode = statusCode,
                Mensagem = mensagem
            };

            return retornoJson;
        }
    }
}
