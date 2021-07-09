using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface ICheckInService
    {
        Task<List<CheckInViewModel>> Obter(int pagina, int quantidade);
    }
}
