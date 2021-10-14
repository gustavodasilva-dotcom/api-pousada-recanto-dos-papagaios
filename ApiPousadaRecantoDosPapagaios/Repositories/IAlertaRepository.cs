using ApiPousadaRecantoDosPapagaios.Entities;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IAlertaRepository
    {
        Task<Retorno> Inserir(Alerta alerta, string json);
    }
}
