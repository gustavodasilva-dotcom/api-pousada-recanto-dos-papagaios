using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<Reserva> Obter(int idReserva);

        Task<Retorno> Inserir(Reserva reserva);

        Task<Reserva> Atualizar(Reserva reserva, ReservaUpdateInputModel reservaJson);

        Task Deletar(int idReserva);
    }
}
