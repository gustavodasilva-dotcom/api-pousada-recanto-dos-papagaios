using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
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

        [HttpPost]
        public async Task<ActionResult<HospedeViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            var hospede = await _hospedeService.Inserir(hospedeInputModel);

            return Ok(hospede);
        }
    }
}
