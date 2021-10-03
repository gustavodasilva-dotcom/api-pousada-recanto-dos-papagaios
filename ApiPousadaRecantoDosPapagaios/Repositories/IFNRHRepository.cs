using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFNRHRepository : IDisposable
    {
        Task<List<FNRH>> ObterFNRHsPorHospede(int idHospede);

        Task<Retorno> Inserir(int idHospede, FNRH fnrh, string json);

        Task<Retorno> Atualizar(int idFNRH, FNRH fnrh, string json);
    }
}
