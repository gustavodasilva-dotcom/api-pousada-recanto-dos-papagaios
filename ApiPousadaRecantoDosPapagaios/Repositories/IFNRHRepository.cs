using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFNRHRepository : IDisposable
    {
        Task<List<FNRH>> ObterFNRHsPorHospede(int idHospede);

        Task<FNRH> Inserir(int idHospede, FNRH fnrh, FNRHInputModel fnrhJson);

        Task<FNRH> Atualizar(int idFNRH, FNRH fnrh, FNRHInputModel fnrhJson);
    }
}
