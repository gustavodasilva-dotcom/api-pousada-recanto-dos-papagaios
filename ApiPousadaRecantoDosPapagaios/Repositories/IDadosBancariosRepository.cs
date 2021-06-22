using ApiPousadaRecantoDosPapagaios.Entities;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IDadosBancariosRepository : IDisposable
    {
        Task Inserir(DadosBancarios dadosBancarios, string cpfFuncionario);
    }
}
