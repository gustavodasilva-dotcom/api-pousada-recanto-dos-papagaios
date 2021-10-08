using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
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

        public async Task<RetornoViewModel> FazerLogin(LoginInputModel loginInput)
        {
            Retorno retorno;

            try
            {
                var login = new Login
                {
                    NomeUsuario = loginInput.NomeUsuario,
                    SenhaUsuario = loginInput.SenhaUsuario
                };

                var json = _json.ConverterModelParaJson(loginInput);

                retorno = await _loginRepository.FazerLogin(login, json);
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
    }
}
