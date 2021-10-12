using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IAcomodacaoRepository : IDisposable
    {
        Task<List<Acomodacao>> Obter();

        Task<AcomodacaoUnitaria> Obter(int idAcomodacao);

        Task<List<ReservaResumida>> ObterProximasReservas(int idAcomodacao);
    }
}
