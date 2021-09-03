using ApiPousadaRecantoDosPapagaios.Models.ViewModels;

namespace ApiPousadaRecantoDosPapagaios.Business
{
    public class Erro
    {
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
