using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class ReservaService : IReservaService
    {
        private readonly IReservaRepository _reservaRepository;

        public ReservaService(IReservaRepository reservaRepository)
        {
            _reservaRepository = reservaRepository;
        }

        public async Task<List<ReservaViewModel>> Obter(int pagina, int quantidade)
        {
            var reservas = await _reservaRepository.Obter(pagina, quantidade);

            return reservas.Select(r => new ReservaViewModel
            {
                Id = r.Id,
                DataReserva = r.DataReserva,
                DataCheckIn = r.DataCheckIn,
                DataCheckOut = r.DataCheckOut,
                PrecoUnitario = r.PrecoUnitario,
                PrecoTotal = r.PrecoTotal,
                StatusReserva = new StatusReservaViewModel
                {
                    Id = r.StatusReserva.Id,
                    Descricao = r.StatusReserva.Descricao
                },
                Acomodacao = new AcomodacaoViewModel
                {
                    Id = r.Acomodacao.Id,
                    Nome = r.Acomodacao.Nome,
                    StatusAcomodacao = new StatusAcomodacaoViewModel
                    {
                        Id = r.Acomodacao.StatusAcomodacao.Id,
                        Descricao = r.Acomodacao.StatusAcomodacao.Descricao
                    },
                    InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                    {
                        Id = r.Acomodacao.InformacoesAcomodacao.Id,
                        MetrosQuadrados = r.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
                        Capacidade = r.Acomodacao.InformacoesAcomodacao.Capacidade,
                        TipoDeCama = r.Acomodacao.InformacoesAcomodacao.TipoDeCama,
                        Preco = r.Acomodacao.InformacoesAcomodacao.Preco
                    },
                    CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                    {
                        Id = r.Acomodacao.CategoriaAcomodacao.Id,
                        Descricao = r.Acomodacao.CategoriaAcomodacao.Descricao
                    }
                },
                Pagamento = new PagamentoViewModel
                {
                    Id = r.Pagamento.Id,
                    TipoPagamento = new TipoPagamentoViewModel
                    {
                        Id = r.Pagamento.TipoPagamento.Id,
                        Descricao = r.Pagamento.TipoPagamento.Descricao
                    },
                    StatusPagamento = new StatusPagamentoViewModel
                    {
                        Id = r.Pagamento.StatusPagamento.Id,
                        Descricao = r.Pagamento.StatusPagamento.Descricao
                    }
                },
                Excluido = r.Excluido
            }).ToList();
        }
    }
}
