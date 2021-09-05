using ApiPousadaRecantoDosPapagaios.Business;
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
    public class CheckInsController : ControllerBase
    {
        private readonly ICheckInService _checkInService;

        private readonly Erro _erro;

        public CheckInsController(ICheckInService checkInService)
        {
            _checkInService = checkInService;

            _erro = new Erro();
        }

        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<CheckInViewModel>>> Obter([FromQuery, Range(1, int.MaxValue)] int pagina = 1, [FromQuery, Range(1, 50)] int quantidade = 5)
        //{
        //    var checkIns = await _checkInService.Obter(pagina, quantidade);

        //    if (checkIns.Count == 0)
        //        return NoContent();

        //    return Ok(checkIns);
        //}

        //[HttpGet("{idReserva:int}")]
        //public async Task<ActionResult<CheckInViewModel>> Obter([FromRoute] int idReserva)
        //{
        //    try
        //    {
        //        var checkIn = await _checkInService.Obter(idReserva);

        //        return Ok(checkIn);
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}

        [HttpPost]
        public async Task<ActionResult<CheckInViewModel>> Inserir([FromBody] CheckInInputModel checkInInputModel)
        {
            //try
            //{
                var checkIn = await _checkInService.Inserir(checkInInputModel);

                return StatusCode(201, checkIn);
            //}
            //catch (NullReferenceException nf)
            //{
            //    return NoContent();
            //}
            //catch (Exception ex)
            //{
            //    return Conflict();
            //}
        }

    }
}
