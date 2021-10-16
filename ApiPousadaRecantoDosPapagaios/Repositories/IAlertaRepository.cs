using ApiPousadaRecantoDosPapagaios.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IAlertaRepository
    {
        Task<List<Alerta>> Obter(int pagina, int quantidade);

        Task<Retorno> Inserir(Alerta alerta, string json);

        Task<Retorno> Deletar(int idAlerta);
    }
}
