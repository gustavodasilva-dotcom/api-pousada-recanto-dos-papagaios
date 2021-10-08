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
    public class ReservasController : ControllerBase
    {
        private readonly IReservaService _reservaService;

        public ReservasController(IReservaService reservaService)
        {
            _reservaService = reservaService;
        }

        [HttpGet("{idReserva:int}")]
        public async Task<ActionResult<ReservaViewModel>> Obter([FromRoute] int idReserva)
        {
            if (idReserva == 0)
                return BadRequest();

            try
            {
                var reserva = await _reservaService.Obter(idReserva);

                return Ok(reserva);
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
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] ReservaInputModel reservaInputModel)
        {
            try
            {
                var retorno = await _reservaService.Inserir(reservaInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpPut("{idReserva:int}")]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromRoute] int idReserva, [FromBody] ReservaUpdateInputModel reservaInputModel)
        {
            if (idReserva == 0)
                return BadRequest();

            try
            {
                var reserva = await _reservaService.Atualizar(idReserva, reservaInputModel);

                return StatusCode(reserva.StatusCode, reserva);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpDelete("{idReserva:int}")]
        public async Task<ActionResult<RetornoViewModel>> Deletar([FromRoute] int idReserva)
        {
            if (idReserva == 0)
                return BadRequest();

            try
            {
                var retorno = await _reservaService.Deletar(idReserva);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }
    }
}
