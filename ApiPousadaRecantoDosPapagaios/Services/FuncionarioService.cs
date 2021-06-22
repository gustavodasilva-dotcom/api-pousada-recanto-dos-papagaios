using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class FuncionarioService : IFuncionarioService
    {
        private readonly IFuncionarioRepository _funcionarioRepository;

        private readonly IEnderecoRepository _enderecoRepository;

        private readonly IDadosBancariosRepository _dadosBancariosRepository;

        public FuncionarioService(IFuncionarioRepository funcionarioRepository, IEnderecoRepository enderecoRepository, IDadosBancariosRepository dadosBancariosRepository)
        {
            _funcionarioRepository = funcionarioRepository;

            _enderecoRepository = enderecoRepository;

            _dadosBancariosRepository = dadosBancariosRepository;
        }

        public async Task<List<FuncionarioViewModel>> Obter()
        {
            var funcionarios = await _funcionarioRepository.Obter();

            return funcionarios.Select(f => new FuncionarioViewModel
            {
                NomeCompleto = f.NomeCompleto,
                Cpf = f.Cpf,
                DataDeNascimento = f.DataDeNascimento,
                Email = f.Email,
                Login = f.Login,
                Senha = f.Senha,
                Celular = f.Celular,
                Nacionalidade = f.Nacionalidade,
                Sexo = f.Sexo,
                Rg = f.Rg,
                Cargo = f.Cargo,
                Setor = f.Setor,
                Salario = f.Salario,
                Endereco = new EnderecoViewModel {
                    Cep = f.Endereco.Cep,
                    Logradouro = f.Endereco.Logradouro,
                    Numero = f.Endereco.Numero,
                    Complemento = f.Endereco.Complemento,
                    Bairro = f.Endereco.Bairro,
                    Cidade = f.Endereco.Cidade,
                    Estado = f.Endereco.Estado,
                    Pais = f.Endereco.Pais
                },
                DadosBancarios = new DadosBancariosViewModel
                {
                    Banco = f.DadosBancarios.Banco,
                    Agencia = f.DadosBancarios.Agencia,
                    NumeroDaConta = f.DadosBancarios.NumeroDaConta,
                    CpfFuncionario = f.DadosBancarios.CpfFuncionario
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Id = f.CategoriaAcesso.Id
                }
            }).ToList();
        }

        public async Task<FuncionarioViewModel> Obter(string cpfFuncionario)
        {
            var funcionario = await _funcionarioRepository.Obter(cpfFuncionario);

            if (funcionario == null)
                throw new Exception();

            return new FuncionarioViewModel
            {
                NomeCompleto = funcionario.NomeCompleto,
                Cpf = funcionario.Cpf,
                DataDeNascimento = funcionario.DataDeNascimento,
                Email = funcionario.Email,
                Login = funcionario.Login,
                Senha = funcionario.Senha,
                Celular = funcionario.Celular,
                Nacionalidade = funcionario.Nacionalidade,
                Sexo = funcionario.Sexo,
                Rg = funcionario.Rg,
                Cargo = funcionario.Cargo,
                Setor = funcionario.Setor,
                Salario = funcionario.Salario,
                Endereco = new EnderecoViewModel
                {
                    Cep = funcionario.Endereco.Cep,
                    Logradouro = funcionario.Endereco.Logradouro,
                    Numero = funcionario.Endereco.Numero,
                    Complemento = funcionario.Endereco.Complemento,
                    Bairro = funcionario.Endereco.Bairro,
                    Cidade = funcionario.Endereco.Cidade,
                    Estado = funcionario.Endereco.Estado,
                    Pais = funcionario.Endereco.Pais
                },
                DadosBancarios = new DadosBancariosViewModel
                {
                    Banco = funcionario.DadosBancarios.Banco,
                    Agencia = funcionario.DadosBancarios.Agencia,
                    NumeroDaConta = funcionario.DadosBancarios.NumeroDaConta,
                    CpfFuncionario = funcionario.DadosBancarios.CpfFuncionario
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Id = funcionario.CategoriaAcesso.Id
                }
            };
        }

        public async Task<FuncionarioViewModel> Inserir(FuncionarioInputModel funcionarioInputModel)
        {
            var funcionario = await _funcionarioRepository.Obter(funcionarioInputModel.Cpf);

            if (!(funcionario == null))
                throw new Exception();

            var funcionarioInsert = new Funcionario
            {
                NomeCompleto = funcionarioInputModel.NomeCompleto,
                Cpf = funcionarioInputModel.Cpf,
                DataDeNascimento = funcionarioInputModel.DataDeNascimento,
                Email = funcionarioInputModel.Email,
                Login = funcionarioInputModel.Login,
                Senha = funcionarioInputModel.Senha,
                Celular = funcionarioInputModel.Celular,
                Nacionalidade = funcionarioInputModel.Nacionalidade,
                Sexo = funcionarioInputModel.Sexo,
                Rg = funcionarioInputModel.Rg,
                Cargo = funcionarioInputModel.Cargo,
                Setor = funcionarioInputModel.Setor,
                Salario = funcionarioInputModel.Salario,
                Excluido = 0,
                CategoriaAcesso = new CategoriaAcesso
                {
                    Id = funcionarioInputModel.CategoriaAcesso.Id
                }  
            };

            await _funcionarioRepository.Inserir(funcionarioInsert);

            var enderecoInsert = new Endereco
            {
                Cep = funcionarioInputModel.Endereco.Cep,
                Logradouro = funcionarioInputModel.Endereco.Logradouro,
                Numero = funcionarioInputModel.Endereco.Numero,
                Complemento = funcionarioInputModel.Endereco.Complemento,
                Bairro = funcionarioInputModel.Endereco.Bairro,
                Cidade = funcionarioInputModel.Endereco.Cidade,
                Estado = funcionarioInputModel.Endereco.Estado,
                Pais = funcionarioInputModel.Endereco.Pais,
                CpfPessoa = funcionarioInputModel.Cpf,
                Excluido = 0,
            };

            await _enderecoRepository.Inserir(enderecoInsert, funcionarioInsert.Cpf);

            var dadosBancariosInsert = new DadosBancarios
            {
                Banco = funcionarioInputModel.DadosBancarios.Banco,
                Agencia = funcionarioInputModel.DadosBancarios.Agencia,
                NumeroDaConta = funcionarioInputModel.DadosBancarios.NumeroDaConta,
                CpfFuncionario = funcionarioInputModel.Cpf,
                Excluido = 0
            };

            await _dadosBancariosRepository.Inserir(dadosBancariosInsert, funcionarioInsert.Cpf);

            return new FuncionarioViewModel
            {
                NomeCompleto = funcionarioInsert.NomeCompleto,
                Cpf = funcionarioInsert.Cpf,
                DataDeNascimento = funcionarioInsert.DataDeNascimento,
                Email = funcionarioInsert.Email,
                Login = funcionarioInsert.Login,
                Senha = funcionarioInsert.Senha,
                Celular = funcionarioInsert.Celular,
                Nacionalidade = funcionarioInsert.Nacionalidade,
                Sexo = funcionarioInsert.Sexo,
                Rg = funcionarioInsert.Rg,
                Cargo = funcionarioInsert.Cargo,
                Setor = funcionarioInsert.Setor,
                Salario = funcionarioInsert.Salario,
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
                },
                DadosBancarios = new DadosBancariosViewModel
                {
                    Banco = dadosBancariosInsert.Banco,
                    Agencia = dadosBancariosInsert.Agencia,
                    NumeroDaConta = dadosBancariosInsert.NumeroDaConta,
                    CpfFuncionario = dadosBancariosInsert.CpfFuncionario
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Id = funcionarioInsert.CategoriaAcesso.Id
                }
            };
        }

    }
}
