using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFNRHRepository : IDisposable
    {
        Task<List<FNRH>> ObterFNRHsPorHospede(int idHospede);

        //Task<FNRH> ObterUltimoRegistroPorHospede(string cpfHospede);
        //Task<FNRH> ObterPorId(int idFNRH);
        //Task Inserir(string cpfHospede, FNRH fnrh);
        //Task Atualizar(int idFNRH, FNRH fnrh);
        //Task Deletar(int idFNRH);
    }
}
