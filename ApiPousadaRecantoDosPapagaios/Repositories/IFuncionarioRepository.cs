using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFuncionarioRepository : IDisposable
    {
        Task<List<Funcionario>> Obter(int pagina, int quantidade);

        Task<Funcionario> Obter(int idFuncionario);

        Task<Funcionario> Inserir(Funcionario funcionario, FuncionarioInputModel funcionarioJson);

        Task<Funcionario> Atualizar(int idFuncionario, Funcionario funcionario, FuncionarioInputModel funcionarioJson);
    }
}
