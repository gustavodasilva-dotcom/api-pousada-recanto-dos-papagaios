using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IFuncionarioService
    {
        Task<List<FuncionarioViewModel>> Obter();
        Task<FuncionarioViewModel> Obter(string cpfFuncionario);
    }
}
