using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public interface IAlertaService
    {
        Task<List<AlertaViewModel>> Obter(int pagina, int quantidade);

        Task<RetornoViewModel> Inserir(AlertaInputModel alertaInput);

        Task<RetornoViewModel> Deletar(int idAlerta);
    }
}
