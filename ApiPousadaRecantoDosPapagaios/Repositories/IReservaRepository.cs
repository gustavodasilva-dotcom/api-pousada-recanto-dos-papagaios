using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<Reserva> Obter(int idReserva);

        Task<List<Reserva>> Obter(string cpf);

        Task<Retorno> Inserir(Reserva reserva, string json);

        Task<Retorno> Atualizar(Reserva reserva, string json);

        Task<Retorno> Deletar(int idReserva);

        Task<bool> PeriodoDisponivel(Reserva reservaInsert);
    }
}
