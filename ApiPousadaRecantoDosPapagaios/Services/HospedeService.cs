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
        private readonly IEnderecoRepository _enderecoRepository;

        public HospedeService(IHospedeRepository hospedeRepository, IEnderecoRepository enderecoRepository)
        {
            _hospedeRepository = hospedeRepository;
            _enderecoRepository = enderecoRepository;
        }

        public async Task<List<HospedeViewModel>> Obter()
        {
            var hospedes = await _hospedeRepository.Obter();

            return hospedes.Select(h => new HospedeViewModel
            {
                NomeCompleto = h.NomeCompleto,
                Cpf = h.Cpf,
                DataDeNascimento = h.DataDeNascimento,
                Email = h.Email,
                Login = h.Login,
                Senha = h.Senha,
                Celular = h.Celular,
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

        public async Task<HospedeViewModel> Inserir(HospedeInputModel hospedeInputModel)
        {
            var hospedeInsert = new Hospede
            {
                NomeCompleto = hospedeInputModel.NomeCompleto,
                Cpf = hospedeInputModel.Cpf,
                DataDeNascimento = hospedeInputModel.DataDeNascimento,
                Email = hospedeInputModel.Email,
                Login = hospedeInputModel.Login,
                Senha = hospedeInputModel.Senha,
                Celular = hospedeInputModel.Celular,
                Excluido = 0
            };

            await _hospedeRepository.Inserir(hospedeInsert);

            var ultimoHospede = await _hospedeRepository.ObterUltimoHospede();

            var enderecoInsert = new Endereco
            {
                Cep = hospedeInputModel.Endereco.Cep,
                Logradouro = hospedeInputModel.Endereco.Logradouro,
                Numero = hospedeInputModel.Endereco.Numero,
                Complemento = hospedeInputModel.Endereco.Complemento,
                Bairro = hospedeInputModel.Endereco.Bairro,
                Cidade = hospedeInputModel.Endereco.Cidade,
                Estado = hospedeInputModel.Endereco.Estado,
                Pais = hospedeInputModel.Endereco.Pais,
                Excluido = 0
            };

            await _enderecoRepository.Inserir(enderecoInsert, ultimoHospede.Id);

            return new HospedeViewModel
            {
                NomeCompleto = hospedeInsert.NomeCompleto,
                Cpf = hospedeInsert.Cpf,
                DataDeNascimento = hospedeInsert.DataDeNascimento,
                Email = hospedeInsert.Email,
                Login = hospedeInsert.Login,
                Senha = hospedeInsert.Senha,
                Celular = hospedeInsert.Celular,
                Endereco = new EnderecoViewModel
                {
                    Cep = enderecoInsert.Cep,
                    Logradouro = enderecoInsert.Logradouro,
                    Numero = enderecoInsert.Numero,
                    Complemento = enderecoInsert.Complemento,
                    Bairro = enderecoInsert.Bairro,
                    Cidade = enderecoInsert.Cidade,
                    Estado = enderecoInsert.Estado,
                    Pais = enderecoInsert.Pais
                }
            };
        }
    }
}
