using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using Newtonsoft.Json;

namespace ApiPousadaRecantoDosPapagaios.Business
{
    public class Json
    {
        public string ConverterModelParaJson(object reservaJson)
        {
            var json = JsonConvert.SerializeObject(reservaJson);

            return json;
        }

        public ErroViewModel SerializarJsonDeErro(int statusCode, string mensagem)
        {
            var erroJson = new ErroViewModel
            {
                StatusCode = statusCode,
                Mensagem = mensagem
            };

            return erroJson;
        }
    }
}
