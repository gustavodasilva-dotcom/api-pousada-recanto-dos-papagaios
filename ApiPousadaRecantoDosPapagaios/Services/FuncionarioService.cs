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

        public FuncionarioService(IFuncionarioRepository funcionarioRepository)
        {
            _funcionarioRepository = funcionarioRepository;
        }

        //public async Task<List<FuncionarioViewModel>> Obter()
        //{
        //    var funcionarios = await _funcionarioRepository.Obter();

        //    return funcionarios.Select(f => new FuncionarioViewModel
        //    {
        //        NomeCompleto = f.NomeCompleto,
        //        Cpf = f.Cpf,
        //        DataDeNascimento = f.DataDeNascimento,
        //        Email = f.Email,
        //        Login = f.Login,
        //        Senha = f.Senha,
        //        Celular = f.Celular,
        //        Nacionalidade = f.Nacionalidade,
        //        Sexo = f.Sexo,
        //        Rg = f.Rg,
        //        Cargo = f.Cargo,
        //        Setor = f.Setor,
        //        Salario = f.Salario,
        //        Endereco = new EnderecoViewModel {
        //            Cep = f.Endereco.Cep,
        //            Logradouro = f.Endereco.Logradouro,
        //            Numero = f.Endereco.Numero,
        //            Complemento = f.Endereco.Complemento,
        //            Bairro = f.Endereco.Bairro,
        //            Cidade = f.Endereco.Cidade,
        //            Estado = f.Endereco.Estado,
        //            Pais = f.Endereco.Pais
        //        },
        //        DadosBancarios = new DadosBancariosViewModel
        //        {
        //            Banco = f.DadosBancarios.Banco,
        //            Agencia = f.DadosBancarios.Agencia,
        //            NumeroDaConta = f.DadosBancarios.NumeroDaConta
        //        },
        //        CategoriaAcesso = new CategoriaAcessoViewModel
        //        {
        //            Id = f.CategoriaAcesso.Id
        //        }
        //    }).ToList();
        //}

        //public async Task<FuncionarioViewModel> Obter(string cpfFuncionario)
        //{
        //    var funcionario = await _funcionarioRepository.Obter(cpfFuncionario);

        //    if (funcionario == null)
        //        throw new Exception();

        //    return new FuncionarioViewModel
        //    {
        //        NomeCompleto = funcionario.NomeCompleto,
        //        Cpf = funcionario.Cpf,
        //        DataDeNascimento = funcionario.DataDeNascimento,
        //        Email = funcionario.Email,
        //        Login = funcionario.Login,
        //        Senha = funcionario.Senha,
        //        Celular = funcionario.Celular,
        //        Nacionalidade = funcionario.Nacionalidade,
        //        Sexo = funcionario.Sexo,
        //        Rg = funcionario.Rg,
        //        Cargo = funcionario.Cargo,
        //        Setor = funcionario.Setor,
        //        Salario = funcionario.Salario,
        //        Endereco = new EnderecoViewModel
        //        {
        //            Cep = funcionario.Endereco.Cep,
        //            Logradouro = funcionario.Endereco.Logradouro,
        //            Numero = funcionario.Endereco.Numero,
        //            Complemento = funcionario.Endereco.Complemento,
        //            Bairro = funcionario.Endereco.Bairro,
        //            Cidade = funcionario.Endereco.Cidade,
        //            Estado = funcionario.Endereco.Estado,
        //            Pais = funcionario.Endereco.Pais
        //        },
        //        DadosBancarios = new DadosBancariosViewModel
        //        {
        //            Banco = funcionario.DadosBancarios.Banco,
        //            Agencia = funcionario.DadosBancarios.Agencia,
        //            NumeroDaConta = funcionario.DadosBancarios.NumeroDaConta
        //        },
        //        CategoriaAcesso = new CategoriaAcessoViewModel
        //        {
        //            Id = funcionario.CategoriaAcesso.Id
        //        }
        //    };
        //}

        public async Task<FuncionarioViewModel> Inserir(FuncionarioInputModel funcionarioInputModel)
        {
            var funcionarioInsert = new Funcionario
            {
                NomeCompleto = funcionarioInputModel.NomeCompleto,
                Cpf = funcionarioInputModel.Cpf,
                Nacionalidade = funcionarioInputModel.Nacionalidade,
                DataDeNascimento = funcionarioInputModel.DataDeNascimento,
                Sexo = funcionarioInputModel.Sexo,
                Rg = funcionarioInputModel.Rg,
                Cargo = funcionarioInputModel.Cargo,
                Setor = funcionarioInputModel.Setor,
                Salario = funcionarioInputModel.Salario,
                Endereco = new Endereco
                {
                    Cep = funcionarioInputModel.Endereco.Cep,
                    Logradouro = funcionarioInputModel.Endereco.Logradouro,
                    Numero = funcionarioInputModel.Endereco.Numero,
                    Complemento = funcionarioInputModel.Endereco.Complemento,
                    Bairro = funcionarioInputModel.Endereco.Bairro,
                    Cidade = funcionarioInputModel.Endereco.Cidade,
                    Estado = funcionarioInputModel.Endereco.Estado,
                    Pais = funcionarioInputModel.Endereco.Pais,
                },
                Usuario = new Usuario
                {
                    NomeUsuario = funcionarioInputModel.Usuario.NomeUsuario,
                    SenhaUsuario = funcionarioInputModel.Usuario.SenhaUsuario
                },
                Contatos = new Contatos
                {
                    Email = funcionarioInputModel.Contatos.Email,
                    Celular = funcionarioInputModel.Contatos.Celular,
                    Telefone = funcionarioInputModel.Contatos.Telefone
                },                
                CategoriaAcesso = new CategoriaAcesso
                {
                    Id = funcionarioInputModel.CategoriaAcesso.Id
                },
                DadosBancarios = new DadosBancarios
                {
                    Banco = funcionarioInputModel.DadosBancarios.Banco,
                    Agencia = funcionarioInputModel.DadosBancarios.Agencia,
                    NumeroDaConta = funcionarioInputModel.DadosBancarios.NumeroDaConta
                }
            };

            await _funcionarioRepository.Inserir(funcionarioInsert);

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
                    NumeroDaConta = dadosBancariosInsert.NumeroDaConta
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Id = funcionarioInsert.CategoriaAcesso.Id
                }
            };
        }

        //public async Task<FuncionarioViewModel> Atualizar(string cpfFuncionario, FuncionarioInputModel funcionarioInputModel)
        //{
        //    var funcionario = await _funcionarioRepository.Obter(cpfFuncionario);

        //    if (funcionario == null)
        //        throw new Exception();

        //    var funcionarioUpdate = new Funcionario
        //    {
        //        NomeCompleto = funcionarioInputModel.NomeCompleto,
        //        Cpf = funcionarioInputModel.Cpf,
        //        DataDeNascimento = funcionarioInputModel.DataDeNascimento,
        //        Email = funcionarioInputModel.Email,
        //        Login = funcionarioInputModel.Login,
        //        Senha = funcionarioInputModel.Senha,
        //        Celular = funcionarioInputModel.Celular,
        //        Nacionalidade = funcionarioInputModel.Nacionalidade,
        //        Sexo = funcionarioInputModel.Sexo,
        //        Rg = funcionarioInputModel.Rg,
        //        Cargo = funcionarioInputModel.Cargo,
        //        Setor = funcionarioInputModel.Setor,
        //        Salario = funcionarioInputModel.Salario,
        //        CategoriaAcesso = new CategoriaAcesso
        //        {
        //            Id = funcionarioInputModel.CategoriaAcesso.Id
        //        }
        //    };

        //    await _funcionarioRepository.Atualizar(cpfFuncionario, funcionarioUpdate);

        //    var enderecoUpdate = new Endereco
        //    {
        //        Cep = funcionarioInputModel.Endereco.Cep,
        //        Logradouro = funcionarioInputModel.Endereco.Logradouro,
        //        Numero = funcionarioInputModel.Endereco.Numero,
        //        Complemento = funcionarioInputModel.Endereco.Complemento,
        //        Bairro = funcionarioInputModel.Endereco.Bairro,
        //        Cidade = funcionarioInputModel.Endereco.Cidade,
        //        Estado = funcionarioInputModel.Endereco.Estado,
        //        Pais = funcionarioInputModel.Endereco.Pais,
        //        CpfPessoa = funcionarioInputModel.Cpf,
        //    };

        //    await _enderecoRepository.AtualizarEnderecoFuncionario(cpfFuncionario, enderecoUpdate);

        //    var dadosBancariosUpdate = new DadosBancarios
        //    {
        //        Banco = funcionarioInputModel.DadosBancarios.Banco,
        //        Agencia = funcionarioInputModel.DadosBancarios.Agencia,
        //        NumeroDaConta = funcionarioInputModel.DadosBancarios.NumeroDaConta,
        //        CpfFuncionario = funcionarioInputModel.Cpf,
        //    };

        //    await _dadosBancariosRepository.Atualizar(cpfFuncionario, dadosBancariosUpdate);

        //    return new FuncionarioViewModel
        //    {
        //        NomeCompleto = funcionarioUpdate.NomeCompleto,
        //        Cpf = funcionarioUpdate.Cpf,
        //        DataDeNascimento = funcionarioUpdate.DataDeNascimento,
        //        Email = funcionarioUpdate.Email,
        //        Login = funcionarioUpdate.Login,
        //        Senha = funcionarioUpdate.Senha,
        //        Celular = funcionarioUpdate.Celular,
        //        Nacionalidade = funcionarioUpdate.Nacionalidade,
        //        Sexo = funcionarioUpdate.Sexo,
        //        Rg = funcionarioUpdate.Rg,
        //        Cargo = funcionarioUpdate.Cargo,
        //        Setor = funcionarioUpdate.Setor,
        //        Salario = funcionarioUpdate.Salario,
        //        Endereco = new EnderecoViewModel
        //        {
        //            Cep = enderecoUpdate.Cep,
        //            Logradouro = enderecoUpdate.Logradouro,
        //            Numero = enderecoUpdate.Numero,
        //            Complemento = enderecoUpdate.Complemento,
        //            Bairro = enderecoUpdate.Bairro,
        //            Cidade = enderecoUpdate.Cidade,
        //            Estado = enderecoUpdate.Estado,
        //            Pais = enderecoUpdate.Pais
        //        },
        //        DadosBancarios = new DadosBancariosViewModel
        //        {
        //            Banco = dadosBancariosUpdate.Banco,
        //            Agencia = dadosBancariosUpdate.Agencia,
        //            NumeroDaConta = dadosBancariosUpdate.NumeroDaConta
        //        },
        //        CategoriaAcesso = new CategoriaAcessoViewModel
        //        {
        //            Id = funcionarioUpdate.CategoriaAcesso.Id
        //        }
        //    };
        //}

    }
}
