using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IEnderecoRepository : IDisposable
    {
        Task<List<Endereco>> Obter();
        Task Inserir(Endereco endereco, string cpfHospede, int idHospede);
        Task Inserir(Endereco endereco, string cpfHospede);
        Task Atualizar(string cpfHospede, Endereco endereco);
        Task Remover(string cpfHospede);
    }
}
