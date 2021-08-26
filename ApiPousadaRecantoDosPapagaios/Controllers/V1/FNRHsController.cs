using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    // TODO: Atualizei a tabela de logs de integrações. Verificar, portanto, em todos os endpoints,
    // se erros são lançados e se os logs estão sendo gravados.
    [Route("api/V1/[controller]")]
    [ApiController]
    public class FNRHsController : ControllerBase
    {
        private readonly IFNRHService _FNRHService;

        public FNRHsController(IFNRHService FNRHService)
        {
            _FNRHService = FNRHService;
        }

        // TODO: Continuar testes das exceptions lançadas pela procedure.
        [HttpGet("{idHospede:int}")]
        public async Task<ActionResult<IEnumerable<FNRHViewModel>>> Obter([FromRoute] int idHospede)
        {
            try
            {
                var fnrh = await _FNRHService.Obter(idHospede);

                return StatusCode(200, fnrh);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não há FNRHs cadastradas para o hóspede"))
                {
                    statusCode = 404;
                    mensagem = "Não há FNRHs cadastradas para o hóspede informado.";
                }
                else if (ex.Message.Contains(" não existe em sistema."))
                {
                    statusCode = 404;
                    mensagem = "Não existe, em sistema, hóspede para o id informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpPost("{idHospede:int}")]
        public async Task<ActionResult<FNRHViewModel>> Inserir([FromRoute] int idHospede, [FromBody] FNRHInputModel fnrhInputModel)
        {
            //try
            //{
                var fnrh = await _FNRHService.Inserir(idHospede, fnrhInputModel);

                return Ok(fnrh);
            //}
            //catch (SqlException ex)
            //{
            //    return NoContent();
            //}
        }

        //[HttpPut("{idFNRH:int}")]
        //public async Task<ActionResult<FNRHViewModel>> Atualizar([FromRoute] int idFNRH, [FromBody] FNRHInputModel fnrhInputModel)
        //{
        //    try
        //    {
        //        var fnrh = await _FNRHService.Atualizar(idFNRH, fnrhInputModel);

        //        return Ok(fnrh);
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}

        //[HttpDelete("{idFNRH:int}")]
        //public async Task<ActionResult> Deletar([FromRoute] int idFNRH)
        //{
        //    try
        //    {
        //        await _FNRHService.Deletar(idFNRH);

        //        return Ok();
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}
    }
}
