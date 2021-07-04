﻿using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFuncionarioRepository : IDisposable
    {
        Task<List<Funcionario>> Obter();
        Task<Funcionario> Obter(string cpfFuncionario);
        Task Inserir(Funcionario funcionario);
        Task Atualizar(string cpfFuncionario, Funcionario funcionario);
    }
}