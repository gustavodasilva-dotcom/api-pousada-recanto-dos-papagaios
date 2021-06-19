using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
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

        [HttpGet("{cpfHospede}")]
        public async Task<ActionResult<IEnumerable<FNRHViewModel>>> Obter([FromRoute] string cpfHospede)
        {
            var fnrh = await _FNRHService.Obter(cpfHospede);

            if (fnrh.Count == 0)
                return NoContent();

            return Ok(fnrh);
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
