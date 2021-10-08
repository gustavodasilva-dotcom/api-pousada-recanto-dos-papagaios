using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IFNRHService
    {
        Task<List<FNRHViewModel>> Obter(int idHospede);

        Task<RetornoViewModel> Inserir(int idHospede, FNRHInputModel fnrhInputModel);

        Task<RetornoViewModel> Atualizar(int idFNRH, FNRHInputModel fnrhInputModel);
    }
}
