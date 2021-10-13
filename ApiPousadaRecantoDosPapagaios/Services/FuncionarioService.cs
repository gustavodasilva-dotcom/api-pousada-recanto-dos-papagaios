using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Exceptions;
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

        private readonly Json _json;

        public FuncionarioService(IFuncionarioRepository funcionarioRepository)
        {
            _funcionarioRepository = funcionarioRepository;

            _json = new Json();
        }

        public async Task<List<FuncionarioViewModel>> Obter(int pagina, int quantidade)
        {
            var funcionarios = await _funcionarioRepository.Obter(pagina, quantidade);

            if (funcionarios.Count == 0)
                throw new NaoEncontradoException();

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

            if (f == null)
                throw new NaoEncontradoException();

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

        public async Task<FuncionarioViewModel> Obter(string cpf)
        {
            var f = await _funcionarioRepository.Obter(cpf);

            if (f == null)
                throw new NaoEncontradoException();

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

        public async Task<RetornoViewModel> Inserir(FuncionarioInputModel funcionarioInputModel)
        {
            #region InstanciandoObjeto

            var funcionarioInsert = new Funcionario
            {
                NomeCompleto = funcionarioInputModel.NomeCompleto,
                Cpf = funcionarioInputModel.Cpf,
                Nacionalidade = funcionarioInputModel.Nacionalidade,
                DataDeNascimento = DateTime.ParseExact(funcionarioInputModel.DataDeNascimento, "yyyy-MM-dd HH:mm:ssZ", null).AddDays(1),
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
                },
                PerguntaDeSeguranca = new PerguntaDeSeguranca
                {
                    PerguntaSeguranca = funcionarioInputModel.PerguntaDeSeguranca.PerguntaSeguranca,
                    RespostaSeguranca = funcionarioInputModel.PerguntaDeSeguranca.RespostaSeguranca
                }
            };

            #endregion InstanciandoObjeto

            var json = _json.ConverterModelParaJson(funcionarioInputModel);

            var f = await _funcionarioRepository.Inserir(funcionarioInsert, json);

            return new RetornoViewModel
            {
                StatusCode = f.StatusCode,
                Mensagem = f.Mensagem
            };
        }

        public async Task<RetornoViewModel> Atualizar(int idFuncionario, FuncionarioInputModel funcionarioInputModel)
        {
            #region InstanciandoObjeto

            var funcionarioUpdate = new Funcionario
            {
                NomeCompleto = funcionarioInputModel.NomeCompleto,
                Cpf = funcionarioInputModel.Cpf,
                Nacionalidade = funcionarioInputModel.Nacionalidade,
                DataDeNascimento = DateTime.ParseExact(funcionarioInputModel.DataDeNascimento, "yyyy-MM-dd HH:mm:ssZ", null).AddDays(1),
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
                },
                PerguntaDeSeguranca = new PerguntaDeSeguranca
                {
                    PerguntaSeguranca = funcionarioInputModel.PerguntaDeSeguranca.PerguntaSeguranca,
                    RespostaSeguranca = funcionarioInputModel.PerguntaDeSeguranca.RespostaSeguranca
                }
            };

            #endregion InstanciandoObjeto

            var json = _json.ConverterModelParaJson(funcionarioInputModel);

            var r = await _funcionarioRepository.Atualizar(idFuncionario, funcionarioUpdate, json);

            return new RetornoViewModel
            {
                StatusCode = r.StatusCode,
                Mensagem = r.Mensagem
            };
        }

    }
}
