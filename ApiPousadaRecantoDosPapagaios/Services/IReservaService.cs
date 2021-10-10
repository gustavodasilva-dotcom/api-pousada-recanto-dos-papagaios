using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IReservaService
    {
        Task<ReservaViewModel> Obter(int idReserva);

        Task<List<ReservaViewModel>> Obter(string cpf);

        Task<RetornoViewModel> Inserir(ReservaInputModel reservaInputModel);

        Task<RetornoViewModel> Atualizar(int idReserva, ReservaUpdateInputModel reservaInputModel);

        Task<RetornoViewModel> Deletar(int idReserva);
    }
}
