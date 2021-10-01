using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ICheckInRepository : IDisposable
    {
        Task<CheckIn> Obter(int idCheckIn);

        Task<Retorno> Inserir(CheckIn checkIn);
    }
}
