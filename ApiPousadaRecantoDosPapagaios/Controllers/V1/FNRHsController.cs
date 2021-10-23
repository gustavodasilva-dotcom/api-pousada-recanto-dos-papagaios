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
    public class FNRHsController : ControllerBase
    {
        private readonly IFNRHService _FNRHService;

        public FNRHsController(IFNRHService FNRHService)
        {
            _FNRHService = FNRHService;
        }

        [HttpGet("{idHospede:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<IEnumerable<FNRHViewModel>>> Obter([FromRoute] int idHospede)
        {
            if (idHospede == 0)
                return BadRequest();

            try
            {
                var fnrh = await _FNRHService.Obter(idHospede);

                return Ok(fnrh);
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

        [HttpPost("{idHospede:int}")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<FNRHViewModel>> Inserir([FromRoute] int idHospede, [FromBody] FNRHInputModel fnrhInputModel)
        {
            if (idHospede == 0)
                return BadRequest();

            try
            {
                var retorno = await _FNRHService.Inserir(idHospede, fnrhInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpPut("{idFNRH:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<FNRHViewModel>> Atualizar([FromRoute] int idFNRH, [FromBody] FNRHInputModel fnrhInputModel)
        {
            if (idFNRH == 0)
                return BadRequest();

            try
            {
                var fnrh = await _FNRHService.Atualizar(idFNRH, fnrhInputModel);

                return StatusCode(fnrh.StatusCode, fnrh);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
