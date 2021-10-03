using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ICheckOutRepository : IDisposable
    {
        Task<CheckOut> Obter(int idReserva);

        Task<Retorno> Inserir(CheckOut checkOut, int ValoresAdicionais, string json);
    }
}
