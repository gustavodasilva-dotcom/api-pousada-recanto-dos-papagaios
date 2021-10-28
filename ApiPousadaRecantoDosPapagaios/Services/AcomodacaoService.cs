using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.ReservaViewModels;
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

        private readonly Json _json;

        public AcomodacaoService(IAcomodacaoRepository acomodacaoRepository)
        {
            _acomodacaoRepository = acomodacaoRepository;

            _json = new Json();
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

        public async Task<AcomodacaoUnitariaViewModel> Obter(int idAcomodacao)
        {
            var acomodacao = await _acomodacaoRepository.Obter(idAcomodacao);

            if (acomodacao == null)
                throw new NaoEncontradoException();

            var retorno = new AcomodacaoUnitariaViewModel
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
                },
            };

            var r = await _acomodacaoRepository.ObterProximasReservas(acomodacao.Id);

            if (r.Count > 0)
            {
                var proximasReservas = new List<ReservaResumidaViewModel>();

                foreach (ReservaResumida reserva in r)
                {
                    proximasReservas.Add(new ReservaResumidaViewModel
                    {
                        idReserva = reserva.idReserva,
                        DataCheckIn = reserva.DataCheckIn,
                        DataCheckOut = reserva.DataCheckOut,
                        Hospede = new HospedeReservaViewModel
                        {
                            Id = reserva.Hospede.Id,
                            NomeCompleto = reserva.Hospede.NomeCompleto,
                            Cpf = reserva.Hospede.Cpf
                        }
                    });
                }

                retorno.ProximasReservas = proximasReservas;
            }

            return retorno;
        }

        public async Task<RetornoViewModel> Atualizar(AcomodacaoInputModel acomodacao)
        {
            try
            {
                var existe = await _acomodacaoRepository.Obter(acomodacao.IdAcomodacao);

                if (existe == null)
                    throw new NaoEncontradoException();

                var update = new Acomodacao
                {
                    Id = acomodacao.IdAcomodacao,
                    Nome = acomodacao.Nome,
                    CategoriaAcomodacao = new CategoriaAcomodacao
                    {
                        Id = acomodacao.Categoria.Id
                    },
                    InformacoesAcomodacao = new InformacoesAcomodacao
                    {
                        Capacidade = acomodacao.InformacoesAcomodacao.Capacidade,
                        MetrosQuadrados = acomodacao.InformacoesAcomodacao.Tamanho,
                        TipoDeCama = acomodacao.InformacoesAcomodacao.TipoDeCama,
                        Preco = acomodacao.InformacoesAcomodacao.Preco
                    }
                };

                acomodacao.Categoria.Descricao = null;

                var json = _json.ConverterModelParaJson(acomodacao);

                var retorno = await _acomodacaoRepository.Atualizar(update, json);

                return new RetornoViewModel
                {
                    StatusCode = retorno.StatusCode,
                    Mensagem = retorno.Mensagem
                };
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
