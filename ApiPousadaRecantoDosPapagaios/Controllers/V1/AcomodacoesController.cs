using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
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
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
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
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<AcomodacaoUnitariaViewModel>> Obter([FromRoute] int idAcomodacao)
        {
            try
            {
                var acomodacao = await _acomodacaoService.Obter(idAcomodacao);

                return Ok(acomodacao);
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

        [HttpPut]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status422UnprocessableEntity)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromBody] AcomodacaoInputModel acomodacao)
        {
            try
            {
                var atualizar = await _acomodacaoService.Atualizar(acomodacao);

                return Ok(atualizar);
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
