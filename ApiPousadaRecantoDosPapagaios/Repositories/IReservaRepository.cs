using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<List<Reserva>> Obter(int pagina, int quantidade);
        Task<Reserva> Obter(int idReserva);
        Task<Reserva> ObterUltimaReserva();
        Task Inserir(Reserva reserva);
        Task Deletar(int idReserva);
    }
}
