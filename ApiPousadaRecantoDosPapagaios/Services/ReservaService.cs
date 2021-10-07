using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.ReservaViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
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

        public async Task<RetornoViewModel> Inserir(ReservaInputModel reservaInputModel)
        {
            var reservaInsert = new Reserva
            {
                DataCheckIn = reservaInputModel.DataCheckIn,
                DataCheckOut = reservaInputModel.DataCheckOut,
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

            var json = _json.ConverterModelParaJson(reservaInputModel);

            var reserva = await _reservaRepository.Inserir(reservaInsert, json);

            return new RetornoViewModel
            {
                StatusCode = reserva.StatusCode,
                Mensagem = reserva.Mensagem
            };
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
            RetornoViewModel retorno;
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
