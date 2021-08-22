using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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

        //public async Task<HospedeViewModel> Inserir(HospedeInputModel hospedeInputModel)
        //{
        //    var hospede = await _hospedeRepository.ObterPorCpf(hospedeInputModel.Cpf);

        //    if (!(hospede == null))
        //        throw new Exception();

        //    var hospedeInsert = new Hospede
        //    {
        //        NomeCompleto = hospedeInputModel.NomeCompleto,
        //        Cpf = hospedeInputModel.Cpf,
        //        DataDeNascimento = hospedeInputModel.DataDeNascimento,
        //        Email = hospedeInputModel.Email,
        //        Login = hospedeInputModel.Cpf,
        //        Senha = hospedeInputModel.Senha,
        //        Celular = hospedeInputModel.Celular
        //    };

        //    await _hospedeRepository.Inserir(hospedeInsert);

        //    var ultimoHospede = await _hospedeRepository.ObterUltimoHospede();

        //    var enderecoInsert = new Endereco
        //    {
        //        Cep = hospedeInputModel.Endereco.Cep,
        //        Logradouro = hospedeInputModel.Endereco.Logradouro,
        //        Numero = hospedeInputModel.Endereco.Numero,
        //        Complemento = hospedeInputModel.Endereco.Complemento,
        //        Bairro = hospedeInputModel.Endereco.Bairro,
        //        Cidade = hospedeInputModel.Endereco.Cidade,
        //        Estado = hospedeInputModel.Endereco.Estado,
        //        Pais = hospedeInputModel.Endereco.Pais
        //    };

        //    await _enderecoRepository.InserirEnderecoHospede(enderecoInsert, ultimoHospede.Cpf);

        //    return new HospedeViewModel
        //    {
        //        NomeCompleto = hospedeInsert.NomeCompleto,
        //        Cpf = hospedeInsert.Cpf,
        //        DataDeNascimento = hospedeInsert.DataDeNascimento,
        //        Email = hospedeInsert.Email,
        //        Login = hospedeInsert.Login,
        //        Senha = hospedeInsert.Senha,
        //        Celular = hospedeInsert.Celular,
        //        Endereco = new EnderecoViewModel
        //        {
        //            Cep = enderecoInsert.Cep,
        //            Logradouro = enderecoInsert.Logradouro,
        //            Numero = enderecoInsert.Numero,
        //            Complemento = enderecoInsert.Complemento,
        //            Bairro = enderecoInsert.Bairro,
        //            Cidade = enderecoInsert.Cidade,
        //            Estado = enderecoInsert.Estado,
        //            Pais = enderecoInsert.Pais
        //        }
        //    };
        //}

        //public async Task<HospedeViewModel> Atualizar(string cpfHospede, HospedeInputModel hospedeInputModel)
        //{
        //    var hospede = await _hospedeRepository.ObterPorCpf(cpfHospede);

        //    if (hospede == null)
        //        throw new Exception();

        //    var hospedeInsert = new Hospede
        //    {
        //        NomeCompleto = hospedeInputModel.NomeCompleto,
        //        Cpf = hospedeInputModel.Cpf,
        //        DataDeNascimento = hospedeInputModel.DataDeNascimento,
        //        Email = hospedeInputModel.Email,
        //        Login = hospedeInputModel.Cpf,
        //        Senha = hospedeInputModel.Senha,
        //        Celular = hospedeInputModel.Celular
        //    };

        //    await _hospedeRepository.Atualizar(cpfHospede, hospedeInsert);

        //    var enderecoInsert = new Endereco
        //    {
        //        Cep = hospedeInputModel.Endereco.Cep,
        //        Logradouro = hospedeInputModel.Endereco.Logradouro,
        //        Numero = hospedeInputModel.Endereco.Numero,
        //        Complemento = hospedeInputModel.Endereco.Complemento,
        //        Bairro = hospedeInputModel.Endereco.Bairro,
        //        Cidade = hospedeInputModel.Endereco.Cidade,
        //        Estado = hospedeInputModel.Endereco.Estado,
        //        Pais = hospedeInputModel.Endereco.Pais
        //    };

        //    await _enderecoRepository.AtualizarEnderecoHospede(cpfHospede, enderecoInsert);

        //    return new HospedeViewModel
        //    {
        //        NomeCompleto = hospedeInsert.NomeCompleto,
        //        Cpf = hospedeInsert.Cpf,
        //        DataDeNascimento = hospedeInsert.DataDeNascimento,
        //        Email = hospedeInsert.Email,
        //        Login = hospedeInsert.Login,
        //        Senha = hospedeInsert.Senha,
        //        Celular = hospedeInsert.Celular,
        //        Endereco = new EnderecoViewModel
        //        {
        //            Cep = enderecoInsert.Cep,
        //            Logradouro = enderecoInsert.Logradouro,
        //            Numero = enderecoInsert.Numero,
        //            Complemento = enderecoInsert.Complemento,
        //            Bairro = enderecoInsert.Bairro,
        //            Cidade = enderecoInsert.Cidade,
        //            Estado = enderecoInsert.Estado,
        //            Pais = enderecoInsert.Pais
        //        }
        //    };
        //}

        //public async Task Remover(string cpfHospede)
        //{
        //    var hospede = await _hospedeRepository.ObterPorCpf(cpfHospede);

        //    if (hospede == null)
        //        throw new Exception();

        //    await _hospedeRepository.Remover(cpfHospede);

        //    await _enderecoRepository.RemoverEnderecoHospede(cpfHospede);
        //}

    }
}
