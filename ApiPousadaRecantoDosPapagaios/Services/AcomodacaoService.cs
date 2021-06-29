using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class AcomodacaoService : IAcomodacaoService
    {
        private readonly IAcomodacaoRepository _acomodacaoRepository;

        public AcomodacaoService(IAcomodacaoRepository acomodacaoRepository)
        {
            _acomodacaoRepository = acomodacaoRepository;
        }

        public async Task<List<AcomodacaoViewModel>> Obter()
        {
            var acomodacoes = await _acomodacaoRepository.Obter();

            return acomodacoes.Select(a => new AcomodacaoViewModel
            {
                Id = a.Id,
                Nome = a.Nome,
                StatusAcomodacao = new StatusAcomodacaoViewModel
                {
                    Id = a.StatusAcomodacao.Id,
                    Descricao = a.StatusAcomodacao.Descricao
                },
                InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                {
                    Id = a.InformacoesAcomodacao.Id,
                    MetrosQuadrados = a.InformacoesAcomodacao.MetrosQuadrados,
                    Capacidade = a.InformacoesAcomodacao.Capacidade,
                    TipoDeCama = a.InformacoesAcomodacao.TipoDeCama,
                    Preco = a.InformacoesAcomodacao.Preco
                },
                CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                {
                    Id = a.CategoriaAcomodacao.Id,
                    Descricao = a.CategoriaAcomodacao.Descricao
                }
            }).ToList();
        }
    }
}
