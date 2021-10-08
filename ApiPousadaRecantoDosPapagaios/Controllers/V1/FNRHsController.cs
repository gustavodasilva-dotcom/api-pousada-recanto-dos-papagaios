using ApiPousadaRecantoDosPapagaios.Exceptions;
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

        [HttpGet("{idHospede:int}")]
        public async Task<ActionResult<IEnumerable<FNRHViewModel>>> Obter([FromRoute] int idHospede)
        {
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
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPost("{idHospede:int}")]
        public async Task<ActionResult<FNRHViewModel>> Inserir([FromRoute] int idHospede, [FromBody] FNRHInputModel fnrhInputModel)
        {
            try
            {
                var retorno = await _FNRHService.Inserir(idHospede, fnrhInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPut("{idFNRH:int}")]
        public async Task<ActionResult<FNRHViewModel>> Atualizar([FromRoute] int idFNRH, [FromBody] FNRHInputModel fnrhInputModel)
        {
            try
            {
                var fnrh = await _FNRHService.Atualizar(idFNRH, fnrhInputModel);

                return StatusCode(fnrh.StatusCode, fnrh);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }
    }
}
