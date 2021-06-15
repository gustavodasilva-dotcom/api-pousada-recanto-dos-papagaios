using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IHospedeRepository : IDisposable
    {
        Task<List<Hospede>> Obter();
        Task Inserir(Hospede hospede);
        Task<Hospede> ObterUltimoHospede();
    }
}
