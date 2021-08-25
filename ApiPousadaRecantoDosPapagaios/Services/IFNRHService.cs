using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IFNRHService
    {
        Task<List<FNRHViewModel>> Obter(int idHospede);
        //Task<FNRHViewModel> Inserir(string cpfHospede, FNRHInputModel fnrhInputModel);
        //Task<FNRHViewModel> Atualizar(int idFNRH, FNRHInputModel fnrhInputModel);
        //Task Deletar(int idFNRH);
    }
}
