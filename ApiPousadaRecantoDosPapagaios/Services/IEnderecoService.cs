using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IEnderecoService
    {
        Task<List<EnderecoViewModel>> Obter();
    }
}
