using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFNRHRepository : IDisposable
    {
        Task<FNRH> Obter(string cpfHospede);
        Task Inserir(string cpfHospede, FNRH fnrh);
    }
}
