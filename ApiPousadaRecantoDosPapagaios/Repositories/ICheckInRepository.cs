﻿using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface ICheckInRepository : IDisposable
    {
        Task<List<CheckIn>> Obter(int pagina, int quantidade);
        Task<CheckIn> Obter(int idCheckIn);
        Task<CheckIn> ObterCheckInPorReserva(int idReserva);
        Task Inserir(CheckIn checkIn);
    }
}
