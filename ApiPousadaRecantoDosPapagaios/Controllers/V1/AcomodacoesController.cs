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
            try
            {
                var acomodacoes = await _acomodacaoService.Obter();

                if (acomodacoes.Count == 0)
                {
                    return NotFound();
                }

                return Ok(acomodacoes);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpGet("{idAcomodacao:int}")]
        public async Task<ActionResult<AcomodacaoViewModel>> Obter([FromRoute] int idAcomodacao)
        {
            try
            {
                var acomodacao = await _acomodacaoService.Obter(idAcomodacao);

                return StatusCode(200, acomodacao);
            }
            catch (NaoEncontradoException)
            {
                return NotFound();
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
