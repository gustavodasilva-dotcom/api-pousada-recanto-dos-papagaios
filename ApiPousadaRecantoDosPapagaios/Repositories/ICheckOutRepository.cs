using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ICheckOutRepository : IDisposable
    {
        Task<CheckOut> Inserir(CheckOut checkOut, int ValoresAdicionais, CheckOutInputModel checkOutInputModel);
    }
}
