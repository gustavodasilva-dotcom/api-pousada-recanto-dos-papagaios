using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
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

        public async Task<List<ReservaViewModel>> Obter(int pagina, int quantidade)
        {
            var reservas = await _reservaRepository.Obter(pagina, quantidade);

            return reservas.Select(r => new ReservaViewModel
            {
                Id = r.Id,
                DataReserva = r.DataReserva,
                DataCheckIn = r.DataCheckIn,
                DataCheckOut = r.DataCheckOut,
                PrecoUnitario = r.PrecoUnitario,
                PrecoTotal = r.PrecoTotal,
                StatusReserva = new StatusReservaViewModel
                {
                    Id = r.StatusReserva.Id,
                    Descricao = r.StatusReserva.Descricao
                },
                Hospede = new HospedeViewModel
                {
                    NomeCompleto = r.Hospede.NomeCompleto,
                    Cpf = r.Hospede.Cpf,
                    DataDeNascimento = r.Hospede.DataDeNascimento,
                    Email = r.Hospede.Email,
                    Login = r.Hospede.Login,
                    Senha = r.Hospede.Senha,
                    Celular = r.Hospede.Celular,
                    Endereco = new EnderecoViewModel
                    {
                        Cep = r.Hospede.Endereco.Cep,
                        Logradouro = r.Hospede.Endereco.Logradouro,
                        Numero = r.Hospede.Endereco.Numero,
                        Complemento = r.Hospede.Endereco.Complemento,
                        Bairro = r.Hospede.Endereco.Bairro,
                        Cidade = r.Hospede.Endereco.Cidade,
                        Estado = r.Hospede.Endereco.Estado,
                        Pais = r.Hospede.Endereco.Pais
                    }
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
                        Id = r.Acomodacao.InformacoesAcomodacao.Id,
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
                    Id = r.Pagamento.Id,
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
                },
                Acompanhantes = r.Acompanhantes,
                Excluido = r.Excluido
            }).ToList();
        }

        public async Task<ReservaViewModel> Obter(int idReserva)
        {
            var reserva = await _reservaRepository.Obter(idReserva);

            if (reserva == null)
                throw new Exception();

            return new ReservaViewModel
            {
                Id = reserva.Id,
                DataReserva = reserva.DataReserva,
                DataCheckIn = reserva.DataCheckIn,
                DataCheckOut = reserva.DataCheckOut,
                PrecoUnitario = reserva.PrecoUnitario,
                PrecoTotal = reserva.PrecoTotal,
                StatusReserva = new StatusReservaViewModel
                {
                    Id = reserva.StatusReserva.Id,
                    Descricao = reserva.StatusReserva.Descricao
                },
                Hospede = new HospedeViewModel
                {
                    NomeCompleto = reserva.Hospede.NomeCompleto,
                    Cpf = reserva.Hospede.Cpf,
                    DataDeNascimento = reserva.Hospede.DataDeNascimento,
                    Email = reserva.Hospede.Email,
                    Login = reserva.Hospede.Login,
                    Senha = reserva.Hospede.Senha,
                    Celular = reserva.Hospede.Celular,
                    Endereco = new EnderecoViewModel
                    {
                        Cep = reserva.Hospede.Endereco.Cep,
                        Logradouro = reserva.Hospede.Endereco.Logradouro,
                        Numero = reserva.Hospede.Endereco.Numero,
                        Complemento = reserva.Hospede.Endereco.Complemento,
                        Bairro = reserva.Hospede.Endereco.Bairro,
                        Cidade = reserva.Hospede.Endereco.Cidade,
                        Estado = reserva.Hospede.Endereco.Estado,
                        Pais = reserva.Hospede.Endereco.Pais
                    }
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
                        Id = reserva.Acomodacao.InformacoesAcomodacao.Id,
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
                    Id = reserva.Pagamento.Id,
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
                },
                Acompanhantes = reserva.Acompanhantes,
                Excluido = reserva.Excluido
            };
        }

        public async Task Deletar(int idReserva)
        {
            var reserva = await _reservaRepository.Obter(idReserva);

            if (reserva == null)
                throw new Exception();

            await _reservaRepository.Deletar(idReserva);
        }

    }
}
