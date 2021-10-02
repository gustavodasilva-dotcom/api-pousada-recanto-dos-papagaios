using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class AcomodacoesController : ControllerBase
    {
        private readonly IAcomodacaoService _acomodacaoService;

        private readonly Json _erro;

        public AcomodacoesController(IAcomodacaoService acomodacaoService)
        {
            _acomodacaoService = acomodacaoService;

            _erro = new Json();
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AcomodacaoViewModel>>> Obter()
        {
            int statusCode;
            string mensagem;

            try
            {
                var acomodacoes = await _acomodacaoService.Obter();

                statusCode = 200;

                if (acomodacoes.Count == 0)
                {
                    statusCode = 404;
                    mensagem = "Não há acomodações cadastradas.";

                    var retornoErro = _erro.SerializarJsonDeRetorno(statusCode, mensagem);

                    return StatusCode(statusCode, retornoErro);
                }

                return StatusCode(statusCode, acomodacoes);
            }
            catch (Exception)
            {
                statusCode = 500;
                mensagem = "Um erro inesperado aconteceu. Por favor, tente mais tarde.";

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpGet("{idAcomodacao:int}")]
        public async Task<ActionResult<AcomodacaoViewModel>> Obter([FromRoute] int idAcomodacao)
        {
            int statusCode;
            string mensagem;

            try
            {
                var acomodacao = await _acomodacaoService.Obter(idAcomodacao);

                return StatusCode(200, acomodacao);
            }
            catch (NaoEncontradoException)
            {
                statusCode = 404;
                mensagem = "Chalé inválido.";

                return StatusCode(statusCode, mensagem);
            }
            catch (Exception)
            {
                statusCode = 500;
                mensagem = "Um erro inesperado aconteceu. Por favor, tente mais tarde.";

                return StatusCode(statusCode, mensagem);
            }
        }
    }
}
