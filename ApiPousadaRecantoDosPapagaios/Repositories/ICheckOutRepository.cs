using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ICheckOutRepository : IDisposable
    {
        Task Inserir(CheckOut checkOut);
        Task<CheckOut> ObterUltimoCheckOut();
    }
}
