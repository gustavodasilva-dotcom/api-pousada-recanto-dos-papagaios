using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface ICheckOutService
    {
        Task<CheckOutViewModel> Inserir(CheckOutInputModel checkOutInputModel);
    }
}
