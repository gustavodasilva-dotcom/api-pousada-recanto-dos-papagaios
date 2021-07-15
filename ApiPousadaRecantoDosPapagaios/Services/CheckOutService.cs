using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class CheckOutService : ICheckOutService
    {
        private readonly ICheckOutRepository _checkOutRepository;

        private readonly ICheckInRepository _checkInRepository;

        public CheckOutService(ICheckOutRepository checkOutRepository, ICheckInRepository checkInRepository)
        {
            _checkOutRepository = checkOutRepository;

            _checkInRepository = checkInRepository;
        }

        public async Task<CheckOutViewModel> Inserir(CheckOutInputModel checkOutInputModel)
        {
            // TODO: Mesmo quando o check-in não existe, está retornando um objecto. Verificar.
            // Deve retornar um valor nulo para funcionar corretamente.
            var checkIn = await _checkInRepository.ObterCheckInPorReserva(checkOutInputModel.ReservaId);

            if (checkIn == null)
                throw new Exception();

            var checkOut = new CheckOut
            {
                ValoresAdicionais = checkOutInputModel.ValoresAdicionais,
                CheckIn = new CheckIn
                {
                    Reserva = new Reserva
                    {
                        Id = checkOutInputModel.ReservaId,
                    },
                },
                Funcionario = new Funcionario
                {
                    Login = checkOutInputModel.LoginFuncionario
                },
                Pagamento = new Pagamento
                {
                    Id = checkOutInputModel.PagamentoId
                }
            };

            await _checkOutRepository.Inserir(checkOut);

            var ultimoCheckOut = await _checkOutRepository.ObterUltimoCheckOut();

            return new CheckOutViewModel
            {
                Id = ultimoCheckOut.Id,
                ValoresAdicionais = ultimoCheckOut.ValoresAdicionais,
                ValorTotal = ultimoCheckOut.ValorTotal,
                CheckIn = new CheckInCheckOutViewModel
                {
                    Id = ultimoCheckOut.CheckIn.Id,
                    Reserva = new ReservaCheckOutViewModel
                    {
                        Id = ultimoCheckOut.CheckIn.Reserva.Id,
                        DataReserva = ultimoCheckOut.CheckIn.Reserva.DataReserva,
                        DataCheckIn = ultimoCheckOut.CheckIn.Reserva.DataCheckIn,
                        DataCheckOut = ultimoCheckOut.CheckIn.Reserva.DataCheckOut,
                        PrecoUnitario = ultimoCheckOut.CheckIn.Reserva.PrecoUnitario,
                        PrecoTotal = ultimoCheckOut.CheckIn.Reserva.PrecoTotal,
                        Hospede = new HospedeCheckOutViewModel
                        {
                            NomeCompleto = ultimoCheckOut.CheckIn.Reserva.Hospede.NomeCompleto,
                            Cpf = ultimoCheckOut.CheckIn.Reserva.Hospede.Cpf,
                            Email = ultimoCheckOut.CheckIn.Reserva.Hospede.Email
                        },
                        Acomodacao = new AcomodacaoCheckOutViewModel
                        {
                            Id = ultimoCheckOut.CheckIn.Reserva.Acomodacao.Id,
                            Nome = ultimoCheckOut.CheckIn.Reserva.Acomodacao.Nome
                        },
                        Acompanhantes = ultimoCheckOut.CheckIn.Reserva.Acompanhantes
                    }
                },
                Funcionario = new FuncionarioCheckOutViewModel
                {
                    Id = ultimoCheckOut.Funcionario.Id,
                    Login = ultimoCheckOut.Funcionario.Login,
                    Email = ultimoCheckOut.Funcionario.Email,
                    Setor = ultimoCheckOut.Funcionario.Setor
                },
                Pagamento = new PagamentoViewModel
                {
                    Id = ultimoCheckOut.Pagamento.Id,
                    TipoPagamento = new TipoPagamentoViewModel
                    {
                        Id = ultimoCheckOut.Pagamento.TipoPagamento.Id,
                        Descricao = ultimoCheckOut.Pagamento.TipoPagamento.Descricao
                    },
                    StatusPagamento = new StatusPagamentoViewModel
                    {
                        Id = ultimoCheckOut.Pagamento.StatusPagamento.Id,
                        Descricao = ultimoCheckOut.Pagamento.StatusPagamento.Descricao
                    }
                },
                Excluido = ultimoCheckOut.Excluido
            };
        }

    }
}
