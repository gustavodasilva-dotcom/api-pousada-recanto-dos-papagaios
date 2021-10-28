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

        Task<Retorno> Atualizar(Acomodacao acomodacao, string json);

        Task<List<ReservaResumida>> ObterProximasReservas(int idAcomodacao);
    }
}
