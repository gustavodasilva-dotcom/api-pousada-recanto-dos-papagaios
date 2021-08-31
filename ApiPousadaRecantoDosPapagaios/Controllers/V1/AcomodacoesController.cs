using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
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

        public AcomodacoesController(IAcomodacaoService acomodacaoService)
        {
            _acomodacaoService = acomodacaoService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AcomodacaoViewModel>>> Obter()
        {
            var acomodacoes = await _acomodacaoService.Obter();

            if (acomodacoes.Count == 0)
                return StatusCode(404, "Não há acomodações cadastradas.");

            return StatusCode(200, acomodacoes);
        }

        [HttpGet("{idAcomodacao:int}")]
        public async Task<ActionResult<AcomodacaoViewModel>> Obter([FromRoute] int idAcomodacao)
        {
            try
            {
                var acomodacao = await _acomodacaoService.Obter(idAcomodacao);

                return StatusCode(200, acomodacao);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não existe acomodação para o id"))
                {
                    statusCode = 404;
                    mensagem = "Não existe acomodação para o id informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
            }
        }
    }
}
