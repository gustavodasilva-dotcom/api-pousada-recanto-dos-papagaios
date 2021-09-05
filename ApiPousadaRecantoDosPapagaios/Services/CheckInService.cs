using ApiPousadaRecantoDosPapagaios.Entities;
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
    public class CheckInService : ICheckInService
    {
        private readonly ICheckInRepository _checkInRepository;

        public CheckInService(ICheckInRepository checkInRepository)
        {
            _checkInRepository = checkInRepository;
        }

        //public async Task<List<CheckInViewModel>> Obter(int pagina, int quantidade)
        //{
        //    var checkIns = await _checkInRepository.Obter(pagina, quantidade);

        //    return checkIns.Select(c => new CheckInViewModel
        //    {
        //        Id = c.Id,
        //        Reserva = new ReservaViewModel
        //        {
        //            Id = c.Reserva.Id,
        //            DataReserva = c.Reserva.DataReserva,
        //            DataCheckIn = c.Reserva.DataCheckIn,
        //            DataCheckOut = c.Reserva.DataCheckOut,
        //            PrecoUnitario = c.Reserva.PrecoUnitario,
        //            PrecoTotal = c.Reserva.PrecoTotal,
        //            StatusReserva = new StatusReservaViewModel
        //            {
        //                Id = c.Reserva.StatusReserva.Id,
        //                Descricao = c.Reserva.StatusReserva.Descricao
        //            },
        //            Hospede = new HospedeViewModel
        //            {
        //                NomeCompleto = c.Reserva.Hospede.NomeCompleto,
        //                Cpf = c.Reserva.Hospede.Cpf,
        //                DataDeNascimento = c.Reserva.Hospede.DataDeNascimento,
        //                Email = c.Reserva.Hospede.Email,
        //                Login = c.Reserva.Hospede.Login,
        //                Senha = c.Reserva.Hospede.Senha,
        //                Celular = c.Reserva.Hospede.Celular,
        //                Endereco = new EnderecoViewModel
        //                {
        //                    Cep = c.Reserva.Hospede.Endereco.Cep,
        //                    Logradouro = c.Reserva.Hospede.Endereco.Logradouro,
        //                    Numero = c.Reserva.Hospede.Endereco.Numero,
        //                    Complemento = c.Reserva.Hospede.Endereco.Complemento,
        //                    Bairro = c.Reserva.Hospede.Endereco.Bairro,
        //                    Cidade = c.Reserva.Hospede.Endereco.Cidade,
        //                    Estado = c.Reserva.Hospede.Endereco.Estado,
        //                    Pais = c.Reserva.Hospede.Endereco.Pais
        //                }
        //            },
        //            Acomodacao = new AcomodacaoViewModel
        //            {
        //                Id = c.Reserva.Acomodacao.Id,
        //                Nome = c.Reserva.Acomodacao.Nome,
        //                StatusAcomodacao = new StatusAcomodacaoViewModel
        //                {
        //                    Id = c.Reserva.Acomodacao.StatusAcomodacao.Id,
        //                    Descricao = c.Reserva.Acomodacao.StatusAcomodacao.Descricao
        //                },
        //                InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //                {
        //                    Id = c.Reserva.Acomodacao.InformacoesAcomodacao.Id,
        //                    MetrosQuadrados = c.Reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
        //                    Capacidade = c.Reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
        //                    TipoDeCama = c.Reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
        //                    Preco = c.Reserva.Acomodacao.InformacoesAcomodacao.Preco
        //                },
        //                CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //                {
        //                    Id = c.Reserva.Acomodacao.CategoriaAcomodacao.Id,
        //                    Descricao = c.Reserva.Acomodacao.CategoriaAcomodacao.Descricao
        //                }
        //            },
        //            Pagamento = new PagamentoViewModel
        //            {
        //                Id = c.Reserva.Pagamento.Id,
        //                TipoPagamento = new TipoPagamentoViewModel
        //                {
        //                    Id = c.Reserva.Pagamento.TipoPagamento.Id,
        //                    Descricao = c.Reserva.Pagamento.TipoPagamento.Descricao
        //                },
        //                StatusPagamento = new StatusPagamentoViewModel
        //                {
        //                    Id = c.Reserva.Pagamento.StatusPagamento.Id,
        //                    Descricao = c.Reserva.Pagamento.StatusPagamento.Descricao
        //                }
        //            },
        //            Acompanhantes = c.Reserva.Acompanhantes,
        //            Excluido = c.Reserva.Excluido
        //        },
        //        UsuarioFuncionario = c.Funcionario.Login,
        //        Excluido = c.Excluido
        //    }).ToList();
        //}

        //public async Task<CheckInViewModel> Obter(int idCheckIn)
        //{
        //    var checkIn = await _checkInRepository.Obter(idCheckIn);

        //    if (checkIn == null)
        //        throw new Exception();

        //    return new CheckInViewModel
        //    {
        //        Id = checkIn.Id,
        //        Reserva = new ReservaViewModel
        //        {
        //            Id = checkIn.Reserva.Id,
        //            DataReserva = checkIn.Reserva.DataReserva,
        //            DataCheckIn = checkIn.Reserva.DataCheckIn,
        //            DataCheckOut = checkIn.Reserva.DataCheckOut,
        //            PrecoUnitario = checkIn.Reserva.PrecoUnitario,
        //            PrecoTotal = checkIn.Reserva.PrecoTotal,
        //            StatusReserva = new StatusReservaViewModel
        //            {
        //                Id = checkIn.Reserva.StatusReserva.Id,
        //                Descricao = checkIn.Reserva.StatusReserva.Descricao
        //            },
        //            Hospede = new HospedeViewModel
        //            {
        //                NomeCompleto = checkIn.Reserva.Hospede.NomeCompleto,
        //                Cpf = checkIn.Reserva.Hospede.Cpf,
        //                DataDeNascimento = checkIn.Reserva.Hospede.DataDeNascimento,
        //                Email = checkIn.Reserva.Hospede.Email,
        //                Login = checkIn.Reserva.Hospede.Login,
        //                Senha = checkIn.Reserva.Hospede.Senha,
        //                Celular = checkIn.Reserva.Hospede.Celular,
        //                Endereco = new EnderecoViewModel
        //                {
        //                    Cep = checkIn.Reserva.Hospede.Endereco.Cep,
        //                    Logradouro = checkIn.Reserva.Hospede.Endereco.Logradouro,
        //                    Numero = checkIn.Reserva.Hospede.Endereco.Numero,
        //                    Complemento = checkIn.Reserva.Hospede.Endereco.Complemento,
        //                    Bairro = checkIn.Reserva.Hospede.Endereco.Bairro,
        //                    Cidade = checkIn.Reserva.Hospede.Endereco.Cidade,
        //                    Estado = checkIn.Reserva.Hospede.Endereco.Estado,
        //                    Pais = checkIn.Reserva.Hospede.Endereco.Pais
        //                }
        //            },
        //            Acomodacao = new AcomodacaoViewModel
        //            {
        //                Id = checkIn.Reserva.Acomodacao.Id,
        //                Nome = checkIn.Reserva.Acomodacao.Nome,
        //                StatusAcomodacao = new StatusAcomodacaoViewModel
        //                {
        //                    Id = checkIn.Reserva.Acomodacao.StatusAcomodacao.Id,
        //                    Descricao = checkIn.Reserva.Acomodacao.StatusAcomodacao.Descricao
        //                },
        //                InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //                {
        //                    Id = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.Id,
        //                    MetrosQuadrados = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
        //                    Capacidade = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
        //                    TipoDeCama = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
        //                    Preco = checkIn.Reserva.Acomodacao.InformacoesAcomodacao.Preco
        //                },
        //                CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //                {
        //                    Id = checkIn.Reserva.Acomodacao.CategoriaAcomodacao.Id,
        //                    Descricao = checkIn.Reserva.Acomodacao.CategoriaAcomodacao.Descricao
        //                }
        //            },
        //            Pagamento = new PagamentoViewModel
        //            {
        //                Id = checkIn.Reserva.Pagamento.Id,
        //                TipoPagamento = new TipoPagamentoViewModel
        //                {
        //                    Id = checkIn.Reserva.Pagamento.TipoPagamento.Id,
        //                    Descricao = checkIn.Reserva.Pagamento.TipoPagamento.Descricao
        //                },
        //                StatusPagamento = new StatusPagamentoViewModel
        //                {
        //                    Id = checkIn.Reserva.Pagamento.StatusPagamento.Id,
        //                    Descricao = checkIn.Reserva.Pagamento.StatusPagamento.Descricao
        //                }
        //            },
        //            Acompanhantes = checkIn.Reserva.Acompanhantes,
        //            Excluido = checkIn.Reserva.Excluido
        //        },
        //        UsuarioFuncionario = checkIn.Funcionario.Login,
        //        Excluido = checkIn.Excluido
        //    };
        //}

        public async Task<CheckInViewModel> Inserir(CheckInInputModel checkInInputModel)
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

            var checkIn = await _checkInRepository.Inserir(checkInInsert, checkInInputModel);

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

    }
}
