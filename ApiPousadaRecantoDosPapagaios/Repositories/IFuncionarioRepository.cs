using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IFuncionarioRepository : IDisposable
    {
        Task<List<Funcionario>> Obter(int pagina, int quantidade);

        Task<Funcionario> Obter(int idFuncionario);

        Task<Funcionario> Obter(string cpf);

        Task<Retorno> Inserir(Funcionario funcionario, string json);

        Task<Retorno> Atualizar(int idFuncionario, Funcionario funcionario, string json);
    }
}
