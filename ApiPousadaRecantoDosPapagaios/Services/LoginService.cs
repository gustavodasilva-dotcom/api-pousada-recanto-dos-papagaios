using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class LoginService : ILoginService
    {
        private readonly ILoginRepository _loginRepository;

        private readonly Json _json;

        public LoginService(ILoginRepository loginRepository)
        {
            _loginRepository = loginRepository;

            _json = new Json();
        }

        public async Task<LoginViewModel> FazerLogin(LoginInputModel loginInput)
        {
            Login loginRetorno;

            try
            {
                var login = new Login
                {
                    NomeUsuario = loginInput.NomeUsuario,
                    SenhaUsuario = loginInput.SenhaUsuario
                };

                var json = _json.ConverterModelParaJson(loginInput);

                loginRetorno = await _loginRepository.FazerLogin(login, json);
            }
            catch (Exception)
            {
                throw;
            }

            return new LoginViewModel
            {
                Retorno = new RetornoViewModel
                {
                    StatusCode = loginRetorno.Retorno.StatusCode,
                    Mensagem = loginRetorno.Retorno.Mensagem
                },
                IdUsuario = loginRetorno.Id,
                NomeDeUsuario = loginRetorno.NomeUsuario,
                Cpf = loginRetorno.Cpf
            };
        }

        public async Task<RetornoViewModel> DenificaoSenha(DefinicaoSenhaInputModel definicaoSenha)
        {
            Retorno retorno;

            try
            {
                var definicao = new DefinicaoSenha
                {
                    Cpf = definicaoSenha.Cpf,
                    NovaSenha = definicaoSenha.NovaSenha,
                    RepeticaoSenha = definicaoSenha.RepeticaoSenha
                };

                var json = _json.ConverterModelParaJson(definicaoSenha);

                retorno = await _loginRepository.DenificaoSenha(definicao, json);
            }
            catch (Exception)
            {
                throw;
            }

            return new RetornoViewModel
            {
                StatusCode = retorno.StatusCode,
                Mensagem = retorno.Mensagem
            };
        }

        public async Task<PerguntaDeSegurancaViewModel> PerguntaSeguranca(string cpf)
        {
            PerguntaDeSeguranca retorno;

            try
            {
                retorno = await _loginRepository.PerguntaSeguranca(cpf);

                if (retorno == null)
                    throw new NaoEncontradoException();
            }
            catch (Exception)
            {
                throw;
            }

            return new PerguntaDeSegurancaViewModel
            {
                Cpf = retorno.Cpf,
                PerguntaSeguranca = retorno.PerguntaSeguranca,
                RespostaSeguranca = retorno.RespostaSeguranca
            };
        }
    }
}
