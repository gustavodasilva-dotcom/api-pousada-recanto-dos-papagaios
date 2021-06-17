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
    public class FNRHsController : ControllerBase
    {
        private readonly IFNRHService _FNRHService;

        public FNRHsController(IFNRHService FNRHService)
        {
            _FNRHService = FNRHService;
        }

        [HttpGet("{cpfHospede}")]
        public async Task<ActionResult<FNRHViewModel>> Obter([FromRoute] string cpfHospede)
        {
            try
            {
                var fnrh = await _FNRHService.Obter(cpfHospede);

                return Ok(fnrh);
            }
            catch (Exception ex)
            {
                return NoContent();
            }
        }

        [HttpPost("{cpfHospede}")]
        public async Task<ActionResult<FNRHViewModel>> Inserir([FromRoute] string cpfHospede, [FromBody] FNRHInputModel fnrhInputModel)
        {
            try
            {
                var fnrh = await _FNRHService.Inserir(cpfHospede, fnrhInputModel);

                return Ok(fnrh);
            }
            catch (Exception ex)
            {
                return NoContent();
            }
        }
    }
}
