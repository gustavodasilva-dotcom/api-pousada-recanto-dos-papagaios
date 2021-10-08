using ApiPousadaRecantoDosPapagaios.Entities;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ILoginRepository
    {
        Task<Retorno> FazerLogin(Login login, string json);
    }
}
