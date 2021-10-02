using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
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

        public async Task<AcomodacaoViewModel> Obter(int idAcomodacao)
        {
            var acomodacao = await _acomodacaoRepository.Obter(idAcomodacao);

            if (acomodacao == null)
                throw new NaoEncontradoException();

            return new AcomodacaoViewModel
            {
                Id = acomodacao.Id,
                Nome = acomodacao.Nome,
                StatusAcomodacao = new StatusAcomodacaoViewModel
                {
                    Id = acomodacao.StatusAcomodacao.Id,
                    Descricao = acomodacao.StatusAcomodacao.Descricao
                },
                InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                {
                    MetrosQuadrados = acomodacao.InformacoesAcomodacao.MetrosQuadrados,
                    Capacidade = acomodacao.InformacoesAcomodacao.Capacidade,
                    TipoDeCama = acomodacao.InformacoesAcomodacao.TipoDeCama,
                    Preco = acomodacao.InformacoesAcomodacao.Preco
                },
                CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                {
                    Id = acomodacao.CategoriaAcomodacao.Id,
                    Descricao = acomodacao.CategoriaAcomodacao.Descricao
                }
            };
        }
    }
}
