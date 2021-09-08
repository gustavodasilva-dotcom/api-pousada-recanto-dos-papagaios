using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface ICheckInService
    {
        Task<CheckInViewModel> Obter(int idCheckIn);

        Task<CheckInViewModel> Inserir(CheckInInputModel checkInInputModel);
    }
}
