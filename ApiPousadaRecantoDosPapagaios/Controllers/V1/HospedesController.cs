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
        public async Task<ActionResult<IEnumerable<HospedeViewModel>>> Obter()
        {
            var hospedes = await _hospedeService.Obter();

            if (hospedes.Count == 0)
                return NoContent();
            
            return Ok(hospedes);
        }

        [HttpGet("{cpfHospede}")]
        public async Task<ActionResult<HospedeViewModel>> Obter([FromRoute] string cpfHospede)
        {
            try
            {
                var hospede = await _hospedeService.Obter(cpfHospede);

                return Ok(hospede);
            }
            catch (Exception ex)
            {
                return NoContent();
            }
        }

        [HttpPost]
        public async Task<ActionResult<HospedeViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            var hospede = await _hospedeService.Inserir(hospedeInputModel);

            return Ok(hospede);
        }

        [HttpPut("{cpfHospede}")]
        public async Task<ActionResult<HospedeViewModel>> Atualizar([FromRoute] string cpfHospede, [FromBody] HospedeInputModel hospedeInputModel)
        {
            // TODO: Verificar o funcionamento incorreto deste código comentado.
            //try
            //{
            var hospede = await _hospedeService.Atualizar(cpfHospede, hospedeInputModel);

                return Ok(hospede);
            //}
            //catch (Exception ex)
            //{
            //    return NoContent();
            //}
        }

        [HttpDelete("{cpfHospede}")]
        public async Task<ActionResult> Remover([FromRoute] string cpfHospede)
        {
            // TODO: Verificar o funcionamento incorreto deste código comentado.
            //try
            //{
                await _hospedeService.Remover(cpfHospede);

                return Ok();
            //}
            //catch (Exception ex)
            //{
            //    return NoContent();
            //}
        }
    }
}
