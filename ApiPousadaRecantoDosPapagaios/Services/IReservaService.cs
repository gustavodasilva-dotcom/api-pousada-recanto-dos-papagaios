using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IReservaService
    {
        Task<List<ReservaViewModel>> Obter(int pagina, int quantidade);
    }
}
