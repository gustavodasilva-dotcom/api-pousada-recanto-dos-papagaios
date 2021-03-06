using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class HospedesController : ControllerBase
    {
        private readonly IHospedeService _hospedeService;

        public HospedesController(IHospedeService hospedeService)
        {
            _hospedeService = hospedeService;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<IEnumerable<HospedeViewModel>>> Obter([FromQuery] int pagina, [FromQuery] int quantidade)
        {
            if (pagina == 0 || quantidade == 0)
                return BadRequest();

            try
            {
                var hospedes = await _hospedeService.Obter(pagina, quantidade);

                return Ok(hospedes);
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

        [HttpGet("{idHospede:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<HospedeViewModel>> Obter([FromRoute] int idHospede)
        {
            if (idHospede == 0)
                return BadRequest();

            try
            {
                var hospede = await _hospedeService.Obter(idHospede);

                return Ok(hospede);
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

        [HttpGet("{cpf}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<HospedeViewModel>> Obter([FromRoute] string cpf)
        {
            if (cpf.Length != 11)
                return BadRequest();

            if (!Regex.IsMatch(cpf, @"^\d+$"))
                return BadRequest();

            try
            {
                var hospede = await _hospedeService.Obter(cpf);

                return Ok(hospede);
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

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            try
            {
                var retorno = await _hospedeService.Inserir(hospedeInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpPut("{idHospede:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromRoute] int idHospede, [FromBody] HospedeInputModel hospedeInputModel)
        {
            if (idHospede == 0)
                return BadRequest();

            try
            {
                var hospede = await _hospedeService.Atualizar(idHospede, hospedeInputModel);

                return StatusCode(hospede.StatusCode, hospede);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpDelete("{idHospede:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Remover([FromRoute] int idHospede)
        {
            if (idHospede == 0)
                return BadRequest();
            
            try
            {
                var hospede = await _hospedeService.Remover(idHospede);

                return StatusCode(hospede.StatusCode, hospede);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
