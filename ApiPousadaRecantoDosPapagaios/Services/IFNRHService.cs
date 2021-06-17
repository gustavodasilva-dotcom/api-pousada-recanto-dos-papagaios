using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IFNRHService
    {
        Task<FNRHViewModel> Obter(string cpfHospede);
        Task<FNRHViewModel> Inserir(string cpfHospede, FNRHInputModel fnrhInputModel);
    }
}
