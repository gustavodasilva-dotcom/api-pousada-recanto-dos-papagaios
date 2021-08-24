using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class HospedeService : IHospedeService
    {
        private readonly IHospedeRepository _hospedeRepository;

        public HospedeService(IHospedeRepository hospedeRepository)
        {
            _hospedeRepository = hospedeRepository;
        }

        public async Task<List<HospedeViewModel>> Obter(int pagina, int quantidade)
        {   
            var hospedes = await _hospedeRepository.Obter(pagina, quantidade);

            return hospedes.Select(h => new HospedeViewModel
            {
                Id = h.Id,
                NomeCompleto = h.NomeCompleto,
                Cpf = h.Cpf,
                DataDeNascimento = h.DataDeNascimento,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = h.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = h.Contatos.Email,
                    Celular = h.Contatos.Celular,
                    Telefone = h.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
                    Cep = h.Endereco.Cep,
                    Logradouro = h.Endereco.Logradouro,
                    Numero = h.Endereco.Numero,
                    Complemento = h.Endereco.Complemento,
                    Bairro = h.Endereco.Bairro,
                    Cidade = h.Endereco.Cidade,
                    Estado = h.Endereco.Estado,
                    Pais = h.Endereco.Pais
                }
            }).ToList();
        }

        public async Task<HospedeViewModel> Obter(int idHospede)
        {
            var hospede = await _hospedeRepository.Obter(idHospede);

            return new HospedeViewModel
            {
                Id = hospede.Id,
                NomeCompleto = hospede.NomeCompleto,
                Cpf = hospede.Cpf,
                DataDeNascimento = hospede.DataDeNascimento,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = hospede.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = hospede.Contatos.Email,
                    Celular = hospede.Contatos.Celular,
                    Telefone = hospede.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
                    Cep = hospede.Endereco.Cep,
                    Logradouro = hospede.Endereco.Logradouro,
                    Numero = hospede.Endereco.Numero,
                    Complemento = hospede.Endereco.Complemento,
                    Bairro = hospede.Endereco.Bairro,
                    Cidade = hospede.Endereco.Cidade,
                    Estado = hospede.Endereco.Estado,
                    Pais = hospede.Endereco.Pais
                }
            };
        }

        public async Task<HospedeViewModel> Inserir(HospedeInputModel hospede)
        {
            var hospedeInsert = new Hospede
            {
                NomeCompleto = hospede.NomeCompleto,
                Cpf = hospede.Cpf,
                DataDeNascimento = hospede.DataDeNascimento,
                Usuario = new Usuario
                {
                    NomeUsuario = hospede.Usuario.NomeUsuario,
                    SenhaUsuario = hospede.Usuario.SenhaUsuario
                },
                Contatos = new Contatos
                {
                    Email = hospede.Contatos.Email,
                    Celular = hospede.Contatos.Celular,
                    Telefone = hospede.Contatos.Telefone
                },
                Endereco = new Endereco
                {
                    Cep = hospede.Endereco.Cep,
                    Logradouro = hospede.Endereco.Logradouro,
                    Numero = hospede.Endereco.Numero,
                    Complemento = hospede.Endereco.Complemento,
                    Bairro = hospede.Endereco.Bairro,
                    Cidade = hospede.Endereco.Cidade,
                    Estado = hospede.Endereco.Estado,
                    Pais = hospede.Endereco.Pais
                }
            };

            var h = await _hospedeRepository.Inserir(hospedeInsert, hospede);

            var hospedeRetorno = new HospedeViewModel
            {
                Id = h.Id,
                NomeCompleto = h.NomeCompleto,
                Cpf = h.Cpf,
                DataDeNascimento = h.DataDeNascimento,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = h.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = h.Contatos.Email,
                    Celular = h.Contatos.Celular,
                    Telefone = h.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
                    Cep = h.Endereco.Cep,
                    Logradouro = h.Endereco.Logradouro,
                    Numero = h.Endereco.Numero,
                    Complemento = h.Endereco.Complemento,
                    Bairro = h.Endereco.Bairro,
                    Cidade = h.Endereco.Cidade,
                    Estado = h.Endereco.Estado,
                    Pais = h.Endereco.Pais
                }
            };

            return hospedeRetorno;
        }

        public async Task<HospedeViewModel> Atualizar(int idHospede, HospedeInputModel hospede)
        {
            var hospedeUpdate = new Hospede
            {
                NomeCompleto = hospede.NomeCompleto,
                Cpf = hospede.Cpf,
                DataDeNascimento = hospede.DataDeNascimento,
                Usuario = new Usuario
                {
                    NomeUsuario = hospede.Usuario.NomeUsuario,
                    SenhaUsuario = hospede.Usuario.SenhaUsuario
                },
                Contatos = new Contatos
                {
                    Email = hospede.Contatos.Email,
                    Celular = hospede.Contatos.Celular,
                    Telefone = hospede.Contatos.Telefone
                },
                Endereco = new Endereco
                {
                    Cep = hospede.Endereco.Cep,
                    Logradouro = hospede.Endereco.Logradouro,
                    Numero = hospede.Endereco.Numero,
                    Complemento = hospede.Endereco.Complemento,
                    Bairro = hospede.Endereco.Bairro,
                    Cidade = hospede.Endereco.Cidade,
                    Estado = hospede.Endereco.Estado,
                    Pais = hospede.Endereco.Pais
                }
            };

            var h = await _hospedeRepository.Atualizar(idHospede, hospedeUpdate);

            return new HospedeViewModel
            {
                Id = h.Id,
                NomeCompleto = h.NomeCompleto,
                Cpf = h.Cpf,
                DataDeNascimento = h.DataDeNascimento,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = h.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = h.Contatos.Email,
                    Celular = h.Contatos.Celular,
                    Telefone = h.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
                    Cep = h.Endereco.Cep,
                    Logradouro = h.Endereco.Logradouro,
                    Numero = h.Endereco.Numero,
                    Complemento = h.Endereco.Complemento,
                    Bairro = h.Endereco.Bairro,
                    Cidade = h.Endereco.Cidade,
                    Estado = h.Endereco.Estado,
                    Pais = h.Endereco.Pais
                }
            };
        }

        public async Task Remover(int idHospede)
        {
            await _hospedeRepository.Remover(idHospede);
        }

    }
}
