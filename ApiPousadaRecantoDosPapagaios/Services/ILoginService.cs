using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface ILoginService
    {
        Task<RetornoViewModel> FazerLogin(LoginInputModel loginInput);
    }
}
