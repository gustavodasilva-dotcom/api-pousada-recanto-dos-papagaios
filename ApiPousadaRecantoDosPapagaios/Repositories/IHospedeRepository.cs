using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IHospedeRepository : IDisposable
    {
        Task<List<Hospede>> Obter();
        Task<Hospede> Obter(string cpfHospede);
        Task Inserir(Hospede hospede);
        Task Remover(string cpfHospede);
        Task<Hospede> ObterUltimoHospede();
    }
}
