using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
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
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpGet("{idHospede:int}")]
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
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPost]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            try
            {
                var retorno = await _hospedeService.Inserir(hospedeInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPut("{idHospede:int}")]
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
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpDelete("{idHospede:int}")]
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
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

    }
}
