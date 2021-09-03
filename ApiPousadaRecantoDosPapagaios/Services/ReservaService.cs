﻿using ApiPousadaRecantoDosPapagaios.Entities;
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

        public ReservaService(IReservaRepository reservaRepository)
        {
            _reservaRepository = reservaRepository;
        }

        public async Task<ReservaViewModel> Obter(int idReserva)
        {
            var reserva = await _reservaRepository.Obter(idReserva);

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

        public async Task<ReservaViewModel> Inserir(ReservaInputModel reservaInputModel)
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

            var reserva = await _reservaRepository.Inserir(reservaInsert, reservaInputModel);

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

        //public async Task<ReservaViewModel> Atualizar(int idReserva, ReservaInputModel reservaInputModel)
        //{
        //    var reserva = await _reservaRepository.Obter(idReserva);

        //    if (reserva == null)
        //        throw new Exception();

        //    var reservaUpdate = new Reserva
        //    {
        //        DataCheckIn = reservaInputModel.DataCheckIn,
        //        DataCheckOut = reservaInputModel.DataCheckOut,
        //        Hospede = new Hospede
        //        {
        //            Cpf = reservaInputModel.CpfHospede
        //        },
        //        Acomodacao = new Acomodacao
        //        {
        //            Id = reservaInputModel.AcomodacaoId
        //        },
        //        Pagamento = new Pagamento
        //        {
        //            Id = reservaInputModel.PagamentoId
        //        },
        //        Acompanhantes = reservaInputModel.Acompanhantes
        //    };

        //    await _reservaRepository.Atualizar(idReserva, reservaUpdate);

        //    reserva = await _reservaRepository.Obter(idReserva);

        //    return new ReservaViewModel
        //    {
        //        Id = reserva.Id,
        //        DataReserva = reserva.DataReserva,
        //        DataCheckIn = reserva.DataCheckIn,
        //        DataCheckOut = reserva.DataCheckOut,
        //        PrecoUnitario = reserva.PrecoUnitario,
        //        PrecoTotal = reserva.PrecoTotal,
        //        StatusReserva = new StatusReservaViewModel
        //        {
        //            Id = reserva.StatusReserva.Id,
        //            Descricao = reserva.StatusReserva.Descricao
        //        },
        //        Hospede = new HospedeViewModel
        //        {
        //            NomeCompleto = reserva.Hospede.NomeCompleto,
        //            Cpf = reserva.Hospede.Cpf,
        //            DataDeNascimento = reserva.Hospede.DataDeNascimento,
        //            Email = reserva.Hospede.Email,
        //            Login = reserva.Hospede.Login,
        //            Senha = reserva.Hospede.Senha,
        //            Celular = reserva.Hospede.Celular,
        //            Endereco = new EnderecoViewModel
        //            {
        //                Cep = reserva.Hospede.Endereco.Cep,
        //                Logradouro = reserva.Hospede.Endereco.Logradouro,
        //                Numero = reserva.Hospede.Endereco.Numero,
        //                Complemento = reserva.Hospede.Endereco.Complemento,
        //                Bairro = reserva.Hospede.Endereco.Bairro,
        //                Cidade = reserva.Hospede.Endereco.Cidade,
        //                Estado = reserva.Hospede.Endereco.Estado,
        //                Pais = reserva.Hospede.Endereco.Pais
        //            }
        //        },
        //        Acomodacao = new AcomodacaoViewModel
        //        {
        //            Id = reserva.Acomodacao.Id,
        //            Nome = reserva.Acomodacao.Nome,
        //            StatusAcomodacao = new StatusAcomodacaoViewModel
        //            {
        //                Id = reserva.Acomodacao.StatusAcomodacao.Id,
        //                Descricao = reserva.Acomodacao.StatusAcomodacao.Descricao
        //            },
        //            InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
        //            {
        //                Id = reserva.Acomodacao.InformacoesAcomodacao.Id,
        //                MetrosQuadrados = reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
        //                Capacidade = reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
        //                TipoDeCama = reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
        //                Preco = reserva.Acomodacao.InformacoesAcomodacao.Preco
        //            },
        //            CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
        //            {
        //                Id = reserva.Acomodacao.CategoriaAcomodacao.Id,
        //                Descricao = reserva.Acomodacao.CategoriaAcomodacao.Descricao
        //            }
        //        },
        //        Pagamento = new PagamentoViewModel
        //        {
        //            Id = reserva.Pagamento.Id,
        //            TipoPagamento = new TipoPagamentoViewModel
        //            {
        //                Id = reserva.Pagamento.TipoPagamento.Id,
        //                Descricao = reserva.Pagamento.TipoPagamento.Descricao
        //            },
        //            StatusPagamento = new StatusPagamentoViewModel
        //            {
        //                Id = reserva.Pagamento.StatusPagamento.Id,
        //                Descricao = reserva.Pagamento.StatusPagamento.Descricao
        //            }
        //        },
        //        Acompanhantes = reserva.Acompanhantes,
        //        Excluido = reserva.Excluido
        //    };
        //}

        //public async Task Deletar(int idReserva)
        //{
        //    var reserva = await _reservaRepository.Obter(idReserva);

        //    if (reserva == null)
        //        throw new Exception();

        //    await _reservaRepository.Deletar(idReserva);
        //}

    }
}
