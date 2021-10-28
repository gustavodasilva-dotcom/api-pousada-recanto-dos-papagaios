using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IAcomodacaoService
    {
        Task<List<AcomodacaoViewModel>> Obter();

        Task<AcomodacaoUnitariaViewModel> Obter(int idAcomodacao);

        Task<RetornoViewModel> Atualizar(AcomodacaoInputModel acomodacao);
    }
}
