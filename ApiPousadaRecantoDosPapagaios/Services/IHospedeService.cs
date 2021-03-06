using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IHospedeService
    {
        Task<List<HospedeViewModel>> Obter(int pagina, int quantidade);

        Task<HospedeViewModel> Obter(int idHospede);

        Task<HospedeViewModel> Obter(string cpf);

        Task<RetornoViewModel> Inserir(HospedeInputModel hospede);

        Task<RetornoViewModel> Atualizar(int idHospede, HospedeInputModel hospede);

        Task<RetornoViewModel> Remover(int idHospede);
    }
}
