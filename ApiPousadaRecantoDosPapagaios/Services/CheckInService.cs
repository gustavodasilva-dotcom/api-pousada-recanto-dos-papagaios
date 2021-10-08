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
    public class CheckInService : ICheckInService
    {
        private readonly ICheckInRepository _checkInRepository;

        private readonly Json _json;

        public CheckInService(ICheckInRepository checkInRepository)
        {
            _checkInRepository = checkInRepository;

            _json = new Json();
        }

        public async Task<CheckInViewModel> Obter(int idCheckIn)
        {
            var checkIn = await _checkInRepository.Obter(idCheckIn);

            if (checkIn == null)
                throw new NaoEncontradoException();

            return new CheckInViewModel
            {
                Id = checkIn.Id,
                Reserva = new ReservaViewModel
                {
                    Id = checkIn.Reserva.Id,
                    DataReserva = checkIn.Reserva.DataReserva,
                    DataCheckIn = checkIn.Reserva.DataCheckIn,
                    DataCheckOut = checkIn.Reserva.DataCheckOut,
                    PrecoUnitario = checkIn.Reserva.PrecoUnitario,
                    PrecoTotal = checkIn.Reserva.PrecoTotal,
                    StatusReserva = new StatusReservaViewModel
                    {
                        Id = checkIn.Reserva.StatusReserva.Id,
                        Descricao = checkIn.Reserva.StatusReserva.Descricao
                    },
                    Hospede = new HospedeReservaViewModel
                    {
                        Id = checkIn.Reserva.Hospede.Id,
                        NomeCompleto = checkIn.Reserva.Hospede.NomeCompleto,
                        Cpf = checkIn.Reserva.Hospede.Cpf
                    },
                    Acomodacao = new AcomodacaoViewModel
                    {
                        Id = checkIn.Reserva.Acomodacao.Id,
                        Nome = checkIn.Reserva.Acomodacao.Nome,
                        StatusAcomodacao = new StatusAcomodacaoViewModel
                        {
                            Id = checkIn.Reserva.Acomodacao.StatusAcomodacao.Id,
                            Descricao = checkIn.Reserva.Acomodacao.StatusAcomodacao.Descricao
                        },
                        InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                        {
                            MetrosQuadrados = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
                            Capacidade = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
                            TipoDeCama = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
                            Preco = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.Preco
                        },
                        CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                        {
                            Id = checkIn.Reserva.Acomodacao.CategoriaAcomodacao.Id,
                            Descricao = checkIn.Reserva.Acomodacao.CategoriaAcomodacao.Descricao
                        }
                    },
                    Pagamento = new PagamentoViewModel
                    {
                        TipoPagamento = new TipoPagamentoViewModel
                        {
                            Id = checkIn.Reserva.Pagamento.TipoPagamento.Id,
                            Descricao = checkIn.Reserva.Pagamento.TipoPagamento.Descricao
                        },
                        StatusPagamento = new StatusPagamentoViewModel
                        {
                            Id = checkIn.Reserva.Pagamento.StatusPagamento.Id,
                            Descricao = checkIn.Reserva.Pagamento.StatusPagamento.Descricao
                        }
                    },
                    Acompanhantes = checkIn.Reserva.Acompanhantes
                },
                UsuarioFuncionario = checkIn.Funcionario.Usuario.NomeUsuario
            };
        }

        public async Task<RetornoViewModel> Inserir(CheckInInputModel checkInInputModel)
        {
            var checkInInsert = new CheckIn
            {
                Reserva = new Reserva
                {
                    Id = checkInInputModel.IdReserva
                },
                Funcionario = new Funcionario
                {
                    Id = checkInInputModel.IdFuncionario
                }
            };

            var json = _json.ConverterModelParaJson(checkInInputModel);

            var r = await _checkInRepository.Inserir(checkInInsert, json);

            return new RetornoViewModel
            {
                StatusCode = r.StatusCode,
                Mensagem = r.Mensagem
            };
        }

    }
}
