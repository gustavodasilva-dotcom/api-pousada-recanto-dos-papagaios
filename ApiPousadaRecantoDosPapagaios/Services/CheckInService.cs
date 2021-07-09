using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
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

        public async Task<List<CheckInViewModel>> Obter(int pagina, int quantidade)
        {
            var checkIns = await _checkInRepository.Obter(pagina, quantidade);

            return checkIns.Select(c => new CheckInViewModel
            {
                Id = c.Id,
                Reserva = new ReservaViewModel
                {
                    Id = c.Reserva.Id,
                    DataReserva = c.Reserva.DataReserva,
                    DataCheckIn = c.Reserva.DataCheckIn,
                    DataCheckOut = c.Reserva.DataCheckOut,
                    PrecoUnitario = c.Reserva.PrecoUnitario,
                    PrecoTotal = c.Reserva.PrecoTotal,
                    StatusReserva = new StatusReservaViewModel
                    {
                        Id = c.Reserva.StatusReserva.Id,
                        Descricao = c.Reserva.StatusReserva.Descricao
                    },
                    Hospede = new HospedeViewModel
                    {
                        NomeCompleto = c.Reserva.Hospede.NomeCompleto,
                        Cpf = c.Reserva.Hospede.Cpf,
                        DataDeNascimento = c.Reserva.Hospede.DataDeNascimento,
                        Email = c.Reserva.Hospede.Email,
                        Login = c.Reserva.Hospede.Login,
                        Senha = c.Reserva.Hospede.Senha,
                        Celular = c.Reserva.Hospede.Celular,
                        Endereco = new EnderecoViewModel
                        {
                            Cep = c.Reserva.Hospede.Endereco.Cep,
                            Logradouro = c.Reserva.Hospede.Endereco.Logradouro,
                            Numero = c.Reserva.Hospede.Endereco.Numero,
                            Complemento = c.Reserva.Hospede.Endereco.Complemento,
                            Bairro = c.Reserva.Hospede.Endereco.Bairro,
                            Cidade = c.Reserva.Hospede.Endereco.Cidade,
                            Estado = c.Reserva.Hospede.Endereco.Estado,
                            Pais = c.Reserva.Hospede.Endereco.Pais
                        }
                    },
                    Acomodacao = new AcomodacaoViewModel
                    {
                        Id = c.Reserva.Acomodacao.Id,
                        Nome = c.Reserva.Acomodacao.Nome,
                        StatusAcomodacao = new StatusAcomodacaoViewModel
                        {
                            Id = c.Reserva.Acomodacao.StatusAcomodacao.Id,
                            Descricao = c.Reserva.Acomodacao.StatusAcomodacao.Descricao
                        },
                        InformacoesAcomodacao = new InformacoesAcomodacaoViewModel
                        {
                            Id = c.Reserva.Acomodacao.InformacoesAcomodacao.Id,
                            MetrosQuadrados = c.Reserva.Acomodacao.InformacoesAcomodacao.MetrosQuadrados,
                            Capacidade = c.Reserva.Acomodacao.InformacoesAcomodacao.Capacidade,
                            TipoDeCama = c.Reserva.Acomodacao.InformacoesAcomodacao.TipoDeCama,
                            Preco = c.Reserva.Acomodacao.InformacoesAcomodacao.Preco
                        },
                        CategoriaAcomodacao = new CategoriaAcomodacaoViewModel
                        {
                            Id = c.Reserva.Acomodacao.CategoriaAcomodacao.Id,
                            Descricao = c.Reserva.Acomodacao.CategoriaAcomodacao.Descricao
                        }
                    },
                    Pagamento = new PagamentoViewModel
                    {
                        Id = c.Reserva.Pagamento.Id,
                        TipoPagamento = new TipoPagamentoViewModel
                        {
                            Id = c.Reserva.Pagamento.TipoPagamento.Id,
                            Descricao = c.Reserva.Pagamento.TipoPagamento.Descricao
                        },
                        StatusPagamento = new StatusPagamentoViewModel
                        {
                            Id = c.Reserva.Pagamento.StatusPagamento.Id,
                            Descricao = c.Reserva.Pagamento.StatusPagamento.Descricao
                        }
                    },
                    Acompanhantes = c.Reserva.Acompanhantes,
                    Excluido = c.Reserva.Excluido
                },
                UsuarioFuncionario = c.Funcionario.Login,
                Excluido = c.Excluido
            }).ToList();
        }
    }
}
