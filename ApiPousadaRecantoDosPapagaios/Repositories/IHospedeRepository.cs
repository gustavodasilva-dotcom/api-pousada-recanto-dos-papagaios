using ApiPousadaRecantoDosPapagaios.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IHospedeRepository
    {
        Task<List<Hospede>> Obter(int pagina, int quantidade);

        Task<Hospede> Obter(int idHospede);

        Task<Hospede> Inserir(Hospede hospede);

        Task<Hospede> Atualizar(int idHospede, Hospede hospede);

        Task Remover(int idHospede);
    }
}
