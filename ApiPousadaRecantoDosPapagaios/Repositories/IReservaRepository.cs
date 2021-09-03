using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IReservaRepository : IDisposable
    {
        Task<Reserva> Obter(int idReserva);

        Task<Reserva> Inserir(Reserva reserva, ReservaInputModel reservaJson);
        
        //Task Atualizar(int idReserva, Reserva reserva);
        
        //Task Deletar(int idReserva);
    }
}
