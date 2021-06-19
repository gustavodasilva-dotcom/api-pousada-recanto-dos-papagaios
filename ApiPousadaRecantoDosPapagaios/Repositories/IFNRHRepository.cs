using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFNRHRepository : IDisposable
    {
        Task<List<FNRH>> ObterFNRHsPorHospede(string cpfHospede);
        Task<FNRH> ObterUltimoRegistroPorHospede(string cpfHospede);
        Task Inserir(string cpfHospede, FNRH fnrh);
    }
}
