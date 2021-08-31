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

        public async Task<List<FuncionarioViewModel>> Obter(int pagina, int quantidade)
        {
            var funcionarios = await _funcionarioRepository.Obter(pagina, quantidade);

            return funcionarios.Select(f => new FuncionarioViewModel
            {
                Id = f.Id,
                NomeCompleto = f.NomeCompleto,
                Cpf = f.Cpf,
                Nacionalidade = f.Nacionalidade,
                DataDeNascimento = f.DataDeNascimento,
                Sexo = f.Sexo,
                Rg = f.Rg,
                Cargo = f.Cargo,
                Setor = f.Setor,
                Salario = f.Salario,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = f.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = f.Contatos.Email,
                    Celular = f.Contatos.Celular,
                    Telefone = f.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
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
                    NumeroDaConta = f.DadosBancarios.NumeroDaConta
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Descricao = f.CategoriaAcesso.Descricao
                }
            }).ToList();
        }

        public async Task<FuncionarioViewModel> Obter(int idFuncionario)
        {
            var f = await _funcionarioRepository.Obter(idFuncionario);

            return new FuncionarioViewModel
            {
                Id = f.Id,
                NomeCompleto = f.NomeCompleto,
                Cpf = f.Cpf,
                Nacionalidade = f.Nacionalidade,
                DataDeNascimento = f.DataDeNascimento,
                Sexo = f.Sexo,
                Rg = f.Rg,
                Cargo = f.Cargo,
                Setor = f.Setor,
                Salario = f.Salario,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = f.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = f.Contatos.Email,
                    Celular = f.Contatos.Celular,
                    Telefone = f.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
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
                    NumeroDaConta = f.DadosBancarios.NumeroDaConta
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Descricao = f.CategoriaAcesso.Descricao
                }
            };
        }

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

            var f = await _funcionarioRepository.Inserir(funcionarioInsert, funcionarioInputModel);

            return new FuncionarioViewModel
            {
                Id = f.Id,
                NomeCompleto = f.NomeCompleto,
                Cpf = f.Cpf,
                Nacionalidade = f.Nacionalidade,
                DataDeNascimento = f.DataDeNascimento,
                Sexo = f.Sexo,
                Rg = f.Rg,
                Cargo = f.Cargo,
                Setor = f.Setor,
                Salario = f.Salario,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = f.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = f.Contatos.Email,
                    Celular = f.Contatos.Celular,
                    Telefone = f.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
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
                    NumeroDaConta = f.DadosBancarios.NumeroDaConta
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Descricao = f.CategoriaAcesso.Descricao
                }
            };
        }

        public async Task<FuncionarioViewModel> Atualizar(int idFuncionario, FuncionarioInputModel funcionarioInputModel)
        {
            var funcionarioUpdate = new Funcionario
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

            var f = await _funcionarioRepository.Atualizar(idFuncionario, funcionarioUpdate, funcionarioInputModel);

            return new FuncionarioViewModel
            {
                Id = f.Id,
                NomeCompleto = f.NomeCompleto,
                Cpf = f.Cpf,
                Nacionalidade = f.Nacionalidade,
                DataDeNascimento = f.DataDeNascimento,
                Sexo = f.Sexo,
                Rg = f.Rg,
                Cargo = f.Cargo,
                Setor = f.Setor,
                Salario = f.Salario,
                Usuario = new UsuarioViewModel
                {
                    NomeUsuario = f.Usuario.NomeUsuario
                },
                Contatos = new ContatosViewModel
                {
                    Email = f.Contatos.Email,
                    Celular = f.Contatos.Celular,
                    Telefone = f.Contatos.Telefone
                },
                Endereco = new EnderecoViewModel
                {
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
                    NumeroDaConta = f.DadosBancarios.NumeroDaConta
                },
                CategoriaAcesso = new CategoriaAcessoViewModel
                {
                    Descricao = f.CategoriaAcesso.Descricao
                }
            };
        }

    }
}
