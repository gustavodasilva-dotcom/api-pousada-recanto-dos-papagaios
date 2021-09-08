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

        public CheckOutService(ICheckOutRepository checkOutRepository, ICheckInRepository checkInRepository)
        {
            _checkOutRepository = checkOutRepository;
        }

        public async Task<CheckOutViewModel> Obter(int idReserva)
        {
            var c = await _checkOutRepository.Obter(idReserva);

            return new CheckOutViewModel
            {
                Id = c.Id,
                ValoresAdicionais = c.ValoresAdicionais,
                ValorTotal = c.ValorTotal,
                CheckIn = new CheckInCheckOutViewModel
                {
                    Id = c.CheckIn.Id,
                    Reserva = new ReservaCheckOutViewModel
                    {
                        Id = c.CheckIn.Reserva.Id,
                        DataReserva = c.CheckIn.Reserva.DataReserva,
                        DataCheckIn = c.CheckIn.Reserva.DataCheckIn,
                        DataCheckOut = c.CheckIn.Reserva.DataCheckOut,
                        PrecoUnitario = c.CheckIn.Reserva.PrecoUnitario,
                        PrecoTotal = c.CheckIn.Reserva.PrecoTotal,
                        Hospede = new HospedeCheckOutViewModel
                        {
                            NomeCompleto = c.CheckIn.Reserva.Hospede.NomeCompleto,
                            Cpf = c.CheckIn.Reserva.Hospede.Cpf
                        },
                        Acomodacao = new AcomodacaoCheckOutViewModel
                        {
                            Id = c.CheckIn.Reserva.Acomodacao.Id,
                            Nome = c.CheckIn.Reserva.Acomodacao.Nome
                        },
                        Acompanhantes = c.CheckIn.Reserva.Acompanhantes
                    }
                },
                Funcionario = new FuncionarioCheckOutViewModel
                {
                    NomeCompleto = c.Funcionario.NomeCompleto,
                    Usuario = new UsuarioViewModel
                    {
                        NomeUsuario = c.Funcionario.Usuario.NomeUsuario
                    }
                },
                Pagamento = new PagamentoViewModel
                {
                    TipoPagamento = new TipoPagamentoViewModel
                    {
                        Id = c.Pagamento.TipoPagamento.Id,
                        Descricao = c.Pagamento.TipoPagamento.Descricao
                    },
                    StatusPagamento = new StatusPagamentoViewModel
                    {
                        Id = c.Pagamento.StatusPagamento.Id,
                        Descricao = c.Pagamento.StatusPagamento.Descricao
                    }
                }
            };
        }

        public async Task<CheckOutViewModel> Inserir(CheckOutInputModel checkOutInputModel)
        {
            var checkOut = new CheckOut
            {
                ValoresAdicionais = checkOutInputModel.ValorAdicional,
                CheckIn = new CheckIn
                {
                    Reserva = new Reserva
                    {
                        Id = checkOutInputModel.IdReserva,
                    },
                },
                Funcionario = new Funcionario
                {
                    Id = checkOutInputModel.IdFuncionario
                },
                Pagamento = new Pagamento
                {
                    Id = checkOutInputModel.TipoPagamento
                }
            };

            var c = await _checkOutRepository.Inserir(checkOut, checkOutInputModel.ValoresAdicionais, checkOutInputModel);

            return new CheckOutViewModel
            {
                Id = c.Id,
                ValoresAdicionais = c.ValoresAdicionais,
                ValorTotal = c.ValorTotal,
                CheckIn = new CheckInCheckOutViewModel
                {
                    Id = c.CheckIn.Id,
                    Reserva = new ReservaCheckOutViewModel
                    {
                        Id = c.CheckIn.Reserva.Id,
                        DataReserva = c.CheckIn.Reserva.DataReserva,
                        DataCheckIn = c.CheckIn.Reserva.DataCheckIn,
                        DataCheckOut = c.CheckIn.Reserva.DataCheckOut,
                        PrecoUnitario = c.CheckIn.Reserva.PrecoUnitario,
                        PrecoTotal = c.CheckIn.Reserva.PrecoTotal,
                        Hospede = new HospedeCheckOutViewModel
                        {
                            NomeCompleto = c.CheckIn.Reserva.Hospede.NomeCompleto,
                            Cpf = c.CheckIn.Reserva.Hospede.Cpf
                        },
                        Acomodacao = new AcomodacaoCheckOutViewModel
                        {
                            Id = c.CheckIn.Reserva.Acomodacao.Id,
                            Nome = c.CheckIn.Reserva.Acomodacao.Nome
                        },
                        Acompanhantes = c.CheckIn.Reserva.Acompanhantes
                    }
                },
                Funcionario = new FuncionarioCheckOutViewModel
                {
                    NomeCompleto = c.Funcionario.NomeCompleto,
                    Usuario = new UsuarioViewModel
                    {
                        NomeUsuario = c.Funcionario.Usuario.NomeUsuario
                    }
                },
                Pagamento = new PagamentoViewModel
                {
                    TipoPagamento = new TipoPagamentoViewModel
                    {
                        Id = c.Pagamento.TipoPagamento.Id,
                        Descricao = c.Pagamento.TipoPagamento.Descricao
                    },
                    StatusPagamento = new StatusPagamentoViewModel
                    {
                        Id = c.Pagamento.StatusPagamento.Id,
                        Descricao = c.Pagamento.StatusPagamento.Descricao
                    }
                }
            };
        }
    }
}
