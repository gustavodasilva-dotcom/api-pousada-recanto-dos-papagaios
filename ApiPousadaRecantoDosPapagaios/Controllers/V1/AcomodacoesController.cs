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
    public class AcomodacoesController : ControllerBase
    {
        private readonly IAcomodacaoService _acomodacaoService;

        public AcomodacoesController(IAcomodacaoService acomodacaoService)
        {
            _acomodacaoService = acomodacaoService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AcomodacaoViewModel>>> Obter()
        {
            var acomodacoes = await _acomodacaoService.Obter();

            if (acomodacoes.Count == 0)
                return NoContent();

            return Ok(acomodacoes);
        }

        [HttpGet("{idAcomodacao:int}")]
        public async Task<ActionResult<AcomodacaoViewModel>> Obter([FromRoute] int idAcomodacao)
        {
            var acomodacao = await _acomodacaoService.Obter(idAcomodacao);

            return Ok(acomodacao);
        }

        [HttpPost]
        public async Task<ActionResult<AcomodacaoViewModel>> Inserir([FromBody] AcomodacaoInputModel acomodacaoInputModel)
        {
            try
            {
                var acomodacao = await _acomodacaoService.Inserir(acomodacaoInputModel);

                return Ok(acomodacao);
            }
            catch (Exception ex)
            {
                return Conflict();
            }
        }

        [HttpDelete("{idAcomodacao:int}")]
        public async Task<ActionResult> Deletar([FromRoute] int idAcomodacao)
        {
            try
            {
                await _acomodacaoService.Deletar(idAcomodacao);

                return Ok();
            }
            catch (Exception ex)
            {
                return NoContent();
            }
        }
    }
}
