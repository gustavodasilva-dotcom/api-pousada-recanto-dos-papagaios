using System;
using System.Threading.Tasks;

namespace VerificarReservas.Repository
{
    public interface IPagamentoRepository : IDisposable
    {
        Task<string> CertaoDeCreditoPagamentoPendente();
    }
}
