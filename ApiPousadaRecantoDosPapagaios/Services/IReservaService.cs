using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IReservaService
    {
        Task<ReservaViewModel> Obter(int idReserva);

        Task<ReservaViewModel> Inserir(ReservaInputModel reservaInputModel);

        Task<ReservaViewModel> Atualizar(int idReserva, ReservaUpdateInputModel reservaInputModel);

        Task Deletar(int idReserva);
    }
}
