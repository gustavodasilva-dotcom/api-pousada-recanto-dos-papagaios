using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IReservaService
    {
        Task<List<ReservaViewModel>> Obter(int pagina, int quantidade);
        Task<ReservaViewModel> Obter(int idReserva);
        Task<ReservaViewModel> Inserir(ReservaInputModel reservaInputModel);
        Task Deletar(int idReserva);
    }
}
