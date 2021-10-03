using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IHospedeRepository : IDisposable
    {
        Task<List<Hospede>> Obter(int pagina, int quantidade);

        Task<Hospede> Obter(int idHospede);

        Task<Retorno> Inserir(Hospede hospede, string json);

        Task<Retorno> Atualizar(int idHospede, Hospede hospede, string json);

        Task<Retorno> Remover(int idHospede);
    }
}
