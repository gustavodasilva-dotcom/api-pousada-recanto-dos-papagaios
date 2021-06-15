using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IEnderecoRepository : IDisposable
    {
        Task<List<Endereco>> Obter();
        Task Inserir(Endereco endereco, int idHospede);
    }
}
