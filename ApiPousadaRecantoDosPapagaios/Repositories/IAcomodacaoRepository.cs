﻿using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IAcomodacaoRepository : IDisposable
    {
        Task<List<Acomodacao>> Obter();
        Task<Acomodacao> Obter(int idAcomodacao);
        Task<Acomodacao> ObterUltimoRegistro();
        Task Inserir(Acomodacao acomodacao);
        Task Deletar(int idAcomodacao);
    }
}