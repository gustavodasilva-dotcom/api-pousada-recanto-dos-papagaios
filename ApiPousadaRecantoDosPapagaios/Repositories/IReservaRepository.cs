using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<Reserva> Obter(int idReserva);

        Task<Reserva> Inserir(Reserva reserva, ReservaInputModel reservaJson);

        Task<Reserva> Atualizar(Reserva reserva, ReservaUpdateInputModel reservaJson);

        Task Deletar(int idReserva);
    }
}
