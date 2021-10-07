using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IReservaService
    {
        Task<ReservaViewModel> Obter(int idReserva);

        Task<RetornoViewModel> Inserir(ReservaInputModel reservaInputModel);

        Task<RetornoViewModel> Atualizar(int idReserva, ReservaUpdateInputModel reservaInputModel);

        Task<RetornoViewModel> Deletar(int idReserva);
    }
}
