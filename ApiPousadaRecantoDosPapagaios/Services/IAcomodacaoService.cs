using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IAcomodacaoService
    {
        public Task<List<AcomodacaoViewModel>> Obter();
    }
}
