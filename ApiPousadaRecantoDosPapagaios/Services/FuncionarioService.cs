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

        public FuncionarioService(IFuncionarioRepository funcionarioRepository)
        {
            _funcionarioRepository = funcionarioRepository;
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
                    IdFuncionario = f.DadosBancarios.IdFuncionario,
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
                    IdFuncionario = funcionario.DadosBancarios.IdFuncionario,
                    CpfFuncionario = funcionario.DadosBancarios.CpfFuncionario
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Id = funcionario.CategoriaAcesso.Id
                }
            };
        }

    }
}
