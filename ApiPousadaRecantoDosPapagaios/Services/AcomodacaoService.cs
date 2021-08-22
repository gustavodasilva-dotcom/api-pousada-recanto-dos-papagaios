using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
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

        //public async Task<List<AcomodacaoViewModel>> Obter()
        //{
        //    var acomodacoes = await _acomodacaoRepository.Obter();

        //    return acomodacoes.Select(a => new AcomodacaoViewModel
        //    {
        //        Id = a.Id,
        //        Nome = a.Nome,
        //        StatusAcomodacao = new StatusAcomodacaoViewModel
        //        {
        //            Id = a.StatusAcomodacao.Id,
        //            Descricao = a.StatusAcomodacao.Descricao
        //        },
        //        InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //        {
        //            Id = a.InformacoesAcomodacao.Id,
        //            MetrosQuadrados = a.InformacoesAcomodacao.MetrosQuadrados,
        //            Capacidade = a.InformacoesAcomodacao.Capacidade,
        //            TipoDeCama = a.InformacoesAcomodacao.TipoDeCama,
        //            Preco = a.InformacoesAcomodacao.Preco
        //        },
        //        CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //        {
        //            Id = a.CategoriaAcomodacao.Id,
        //            Descricao = a.CategoriaAcomodacao.Descricao
        //        }
        //    }).ToList();
        //}

        //public async Task<AcomodacaoViewModel> Obter(int idAcomodacao)
        //{
        //    var acomodacao = await _acomodacaoRepository.Obter(idAcomodacao);

        //    if (acomodacao == null)
        //        throw new Exception();

        //    return new AcomodacaoViewModel
        //    {
        //        Id = acomodacao.Id,
        //        Nome = acomodacao.Nome,
        //        StatusAcomodacao = new StatusAcomodacaoViewModel
        //        {
        //            Id = acomodacao.StatusAcomodacao.Id,
        //            Descricao = acomodacao.StatusAcomodacao.Descricao
        //        },
        //        InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //        {
        //            Id = acomodacao.InformacoesAcomodacao.Id,
        //            MetrosQuadrados = acomodacao.InformacoesAcomodacao.MetrosQuadrados,
        //            Capacidade = acomodacao.InformacoesAcomodacao.Capacidade,
        //            TipoDeCama = acomodacao.InformacoesAcomodacao.TipoDeCama,
        //            Preco = acomodacao.InformacoesAcomodacao.Preco
        //        },
        //        CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //        {
        //            Id = acomodacao.CategoriaAcomodacao.Id,
        //            Descricao = acomodacao.CategoriaAcomodacao.Descricao
        //        }
        //    };
        //}

        //public async Task<AcomodacaoViewModel> Inserir(AcomodacaoInputModel acomodacaoInputModel)
        //{
        //    var obterAcomodacao = await _acomodacaoRepository.Obter();

        //    var verificarAcomodacao = obterAcomodacao.Where(a => a.Nome == acomodacaoInputModel.Nome);

        //    if (verificarAcomodacao == null)
        //        throw new Exception();

        //    var acomodacaoInsert = new Acomodacao
        //    {
        //        Nome = acomodacaoInputModel.Nome,
        //        StatusAcomodacao = new StatusAcomodacao
        //        {
        //            Id = acomodacaoInputModel.StatusAcomodacao.Id
        //        },
        //        InformacoesAcomodacao = new InformacoesAcomodacao
        //        {
        //            Id = acomodacaoInputModel.InformacoesAcomodacao.Id
        //        }
        //    };

        //    await _acomodacaoRepository.Inserir(acomodacaoInsert);

        //    var acomodacao = await _acomodacaoRepository.ObterUltimoRegistro();

        //    return new AcomodacaoViewModel
        //    {
        //        Id = acomodacao.Id,
        //        Nome = acomodacao.Nome,
        //        StatusAcomodacao = new StatusAcomodacaoViewModel
        //        {
        //            Id = acomodacao.StatusAcomodacao.Id,
        //            Descricao = acomodacao.StatusAcomodacao.Descricao
        //        },
        //        InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //        {
        //            Id = acomodacao.InformacoesAcomodacao.Id,
        //            MetrosQuadrados = acomodacao.InformacoesAcomodacao.MetrosQuadrados,
        //            Capacidade = acomodacao.InformacoesAcomodacao.Capacidade,
        //            TipoDeCama = acomodacao.InformacoesAcomodacao.TipoDeCama,
        //            Preco = acomodacao.InformacoesAcomodacao.Preco
        //        },
        //        CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //        {
        //            Id = acomodacao.CategoriaAcomodacao.Id,
        //            Descricao = acomodacao.CategoriaAcomodacao.Descricao
        //        }
        //    };
        //}

        //public async Task Deletar(int idAcomodacao)
        //{
        //    var acomodacao = await _acomodacaoRepository.Obter(idAcomodacao);

        //    if (acomodacao == null)
        //        throw new Exception();

        //    await _acomodacaoRepository.Deletar(idAcomodacao);
        //}
    }
}
