using ApiPousadaRecantoDosPapagaios.Entities;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ILoginRepository
    {
        Task<Login> FazerLogin(Login login, string json);

        Task<PerguntaDeSeguranca> PerguntaSeguranca(string cpf);

        Task<Retorno> DenificaoSenha(DefinicaoSenha definicaoSenha, string json);
    }
}
