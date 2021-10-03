using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<Reserva> Obter(int idReserva);

        Task<Retorno> Inserir(Reserva reserva, string json);

        Task<Reserva> Atualizar(Reserva reserva);

        Task Deletar(int idReserva);
    }
}
