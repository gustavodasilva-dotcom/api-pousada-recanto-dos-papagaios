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
    public class AlertasController : ControllerBase
    {
        private readonly IAlertaService _alertaService;

        public AlertasController(IAlertaService alertaService)
        {
            _alertaService = alertaService;
        }

        [HttpGet]
        public async Task<ActionResult<AlertaViewModel>> Obter([FromQuery] int pagina = 1, [FromQuery] int quantidade = 10)
        {
            try
            {
                var alertas = await _alertaService.Obter(pagina, quantidade);

                if (alertas.Count == 0)
                    return NotFound();

                return Ok(alertas);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpPost]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] AlertaInputModel alertaInput)
        {
            try
            {
                var retorno = await _alertaService.Inserir(alertaInput);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpDelete("{idAlerta:int}")]
        public async Task<ActionResult<RetornoViewModel>> Deletar([FromRoute] int idAlerta)
        {
            if (idAlerta.ToString().Length < 8)
                return BadRequest();

            try
            {
                var retorno = await _alertaService.Deletar(idAlerta);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
