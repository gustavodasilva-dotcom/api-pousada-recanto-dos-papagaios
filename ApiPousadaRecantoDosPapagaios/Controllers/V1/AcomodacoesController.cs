using ApiPousadaRecantoDosPapagaios.Business;
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

        private readonly Erro _erro;

        public AcomodacoesController(IAcomodacaoService acomodacaoService)
        {
            _acomodacaoService = acomodacaoService;

            _erro = new Erro();
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AcomodacaoViewModel>>> Obter()
        {
            int statusCode;
            string mensagem;

            var acomodacoes = await _acomodacaoService.Obter();

            statusCode = 200;

            if (acomodacoes.Count == 0)
            {
                statusCode = 404;
                mensagem = "Não há acomodações cadastradas.";

                var retornoErro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }

            return StatusCode(statusCode, acomodacoes);
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

                var retornoErro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }
        }
    }
}
