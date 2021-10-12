using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class LoginsController : ControllerBase
    {
        private readonly ILoginService _loginService;

        public LoginsController(ILoginService loginService)
        {
            _loginService = loginService;
        }

        [HttpPost]
        public async Task<ActionResult<LoginViewModel>> Inserir([FromBody] LoginInputModel login) 
        {
            try
            {
                var retorno = await _loginService.FazerLogin(login);

                return StatusCode(retorno.Retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPut]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromBody] DefinicaoSenhaInputModel definicaoSenha)
        {
            try
            {
                var retorno = await _loginService.DenificaoSenha(definicaoSenha);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpGet("{cpf}")]
        public async Task<ActionResult<PerguntaDeSegurancaViewModel>> Obter([FromRoute] string cpf)
        {
            if (cpf.Length != 11)
                return BadRequest();

            try
            {
                var retorno = await _loginService.PerguntaSeguranca(cpf);

                return Ok(retorno);
            }
            catch (NaoEncontradoException)
            {
                return NotFound();
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }
    }
}
