using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IEnderecoRepository : IDisposable
    {
        Task<List<Endereco>> Obter();
        Task InserirEnderecoFuncionario(Endereco endereco, string cpfHospede);
        Task InserirEnderecoHospede(Endereco endereco, string cpfHospede);
        Task Inserir(Endereco endereco, string cpfHospede);
        Task AtualizarEnderecoFuncionario(string cpfHospede, Endereco endereco);
        Task AtualizarEnderecoHospede(string cpfHospede, Endereco endereco);
        Task RemoverEnderecoHospede(string cpfHospede);
        Task RemoverEnderecoFuncionario(string cpfHospede);
    }
}
