using System.Threading.Tasks;

namespace VerificarReservas.Repository
{
    public interface IReservaRepository
    {
        Task VerificarReservasSemCheckIn();

        Task<string> VerificarAcomodacoesOcupadas();
    }
}
