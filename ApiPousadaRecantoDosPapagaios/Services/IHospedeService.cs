using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IHospedeService
    {
        Task<List<HospedeViewModel>> Obter();
        Task<HospedeViewModel> Obter(string cpfHospede);
        Task<HospedeViewModel> Inserir(HospedeInputModel hospedeInputModel);
        Task<HospedeViewModel> Atualizar(string cpfHospede, HospedeInputModel hospedeInputModel);
        Task Remover(string cpfHospede);
    }
}
