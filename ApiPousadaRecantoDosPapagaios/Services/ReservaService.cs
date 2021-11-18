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
    public class ReservaService : IReservaService
    {
        private readonly IReservaRepository _reservaRepository;

        private readonly Json _json;

        public ReservaService(IReservaRepository reservaRepository)
        {
            _reservaRepository = reservaRepository;

            _json = new Json();
        }

        public async Task<ReservaViewModel> Obter(int idReserva)
        {
            var reserva = await _reservaRepository.Obter(idReserva);

            if (reserva == null)
                throw new NaoEncontradoException();

            return new ReservaViewModel
            {
                Id = reserva.Id,
                DataReserva = reserva.DataReserva,
                DataCheckIn = reserva.DataCheckIn,
                DataCheckOut = reserva.DataCheckOut,
                Acompanhantes = reserva.Acompanhantes,
                PrecoUnitario = reserva.PrecoUnitario,
                PrecoTotal = reserva.PrecoTotal,
                StatusReserva = new StatusReservaViewModel
                {
                    Id = reserva.StatusReserva.Id,
                    Descricao = reserva.StatusReserva.Descricao
                },
                Hospede = new HospedeReservaViewModel
                {
                    Id = reserva.Hospede.Id,
                    NomeCompleto = reserva.Hospede.NomeCompleto,
                    Cpf = reserva.Hospede.Cpf
                },
                Acomodacao = new AcomodacaoViewModel
                {
                    Id = reserva.Acomodacao.Id,
                    Nome = reserva.Acomodacao.Nome,
                    StatusAcomodacao = new StatusAcomodacaoViewModel
                    {
                        Id = reserva.Acomodacao.StatusAcomodacao.Id,
                        Descricao = reserva.Acomodacao.StatusAcomodacao.Descricao
                    },
                    InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                    {
                        MetrosQuadrados = reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
                        Capacidade = reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
                        TipoDeCama = reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
                        Preco = reserva.Acomodacao.InformacoesAcomodacao.Preco
                    },
                    CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                    {
                        Id = reserva.Acomodacao.CategoriaAcomodacao.Id,
                        Descricao = reserva.Acomodacao.CategoriaAcomodacao.Descricao
                    }
                },
                Pagamento = new PagamentoViewModel
                {
                    TipoPagamento = new TipoPagamentoViewModel
                    {
                        Id = reserva.Pagamento.TipoPagamento.Id,
                        Descricao = reserva.Pagamento.TipoPagamento.Descricao
                    },
                    StatusPagamento = new StatusPagamentoViewModel
                    {
                        Id = reserva.Pagamento.StatusPagamento.Id,
                        Descricao = reserva.Pagamento.StatusPagamento.Descricao
                    }
                }
            };
        }

        public async Task<List<ReservaViewModel>> Obter(string cpf)
        {
            var reserva = await _reservaRepository.Obter(cpf);

            if (reserva.Count == 0)
                throw new NaoEncontradoException();

            return reserva.Select(r => new ReservaViewModel
            {
                Id = r.Id,
                DataReserva = r.DataReserva,
                DataCheckIn = r.DataCheckIn,
                DataCheckOut = r.DataCheckOut,
                Acompanhantes = r.Acompanhantes,
                PrecoUnitario = r.PrecoUnitario,
                PrecoTotal = r.PrecoTotal,
                StatusReserva = new StatusReservaViewModel
                {
                    Id = r.StatusReserva.Id,
                    Descricao = r.StatusReserva.Descricao
                },
                Hospede = new HospedeReservaViewModel
                {
                    Id = r.Hospede.Id,
                    NomeCompleto = r.Hospede.NomeCompleto,
                    Cpf = r.Hospede.Cpf
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
                }
            }).ToList();
        }

        public async Task<RetornoViewModel> Inserir(ReservaInputModel reservaInputModel)
        {
            try
            {
                var reservaInsert = new Reserva
                {
                    DataCheckIn = DateTime.ParseExact(reservaInputModel.DataCheckIn, "yyyy-MM-dd HH:mm:ssZ", null),
                    DataCheckOut = DateTime.ParseExact(reservaInputModel.DataCheckOut, "yyyy-MM-dd HH:mm:ssZ", null),
                    Hospede = new Hospede
                    {
                        Id = reservaInputModel.IdHospede
                    },
                    Acomodacao = new Acomodacao
                    {
                        Id = reservaInputModel.IdAcomodacao
                    },
                    Pagamento = new Pagamento
                    {
                        Id = reservaInputModel.IdPagamento
                    },
                    Acompanhantes = reservaInputModel.Acompanhantes
                };

                if (!await _reservaRepository.PeriodoDisponivel(reservaInsert))
                {
                    return new RetornoViewModel
                    {
                        StatusCode = 409,
                        Mensagem = "A acomodação está ocupada no período que você selecionou."
                    };
                }

                var json = _json.ConverterModelParaJson(reservaInputModel);

                var reserva = await _reservaRepository.Inserir(reservaInsert, json);

                return new RetornoViewModel
                {
                    StatusCode = reserva.StatusCode,
                    Mensagem = reserva.Mensagem
                };
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<RetornoViewModel> Atualizar(int idReserva, ReservaUpdateInputModel reservaInputModel)
        {
            var reservaUpdate = new Reserva
            {
                Id = idReserva,
                DataCheckIn = reservaInputModel.DataCheckIn,
                DataCheckOut = reservaInputModel.DataCheckOut,
                Acomodacao = new Acomodacao
                {
                    Id = reservaInputModel.IdAcomodacao
                },
                Pagamento = new Pagamento
                {
                    Id = reservaInputModel.IdPagamento
                },
                Acompanhantes = reservaInputModel.Acompanhantes
            };

            var json = _json.ConverterModelParaJson(reservaInputModel);

            var reserva = await _reservaRepository.Atualizar(reservaUpdate, json);

            return new RetornoViewModel
            {
                StatusCode = reserva.StatusCode,
                Mensagem = reserva.Mensagem
            };
        }

        public async Task<RetornoViewModel> Deletar(int idReserva)
        {
            Retorno resultado;

            try
            {
                resultado = await _reservaRepository.Deletar(idReserva);
            }
            catch (Exception)
            {
                throw;
            }

            return new RetornoViewModel
            {
                StatusCode = resultado.StatusCode,
                Mensagem = resultado.Mensagem
            };
        }
    }
}
