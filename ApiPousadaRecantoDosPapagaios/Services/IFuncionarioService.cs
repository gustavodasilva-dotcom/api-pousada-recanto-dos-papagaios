using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IFuncionarioService
    {
        Task<List<FuncionarioViewModel>> Obter(int pagina, int quantidade);

        Task<FuncionarioViewModel> Obter(int idFuncionario);

        Task<FuncionarioViewModel> Inserir(FuncionarioInputModel funcionarioInputModel);

        Task<FuncionarioViewModel> Atualizar(int idFuncionario, FuncionarioInputModel funcionarioInputModel);
    }
}
