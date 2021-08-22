using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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

        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<ReservaViewModel>>> Obter([FromQuery, Range(1, int.MaxValue)] int pagina = 1, [FromQuery, Range(1, 50)] int quantidade = 5)
        //{
        //    var reservas = await _reservaService.Obter(pagina, quantidade);

        //    if (reservas.Count == 0)
        //        return NoContent();

        //    return Ok(reservas);
        //}

        //[HttpGet("{idReserva:int}")]
        //public async Task<ActionResult<ReservaViewModel>> Obter([FromRoute] int idReserva)
        //{
        //    try
        //    {
        //        var reserva = await _reservaService.Obter(idReserva);

        //        return Ok(reserva);
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}

        //[HttpPost]
        //public async Task<ActionResult<ReservaViewModel>> Inserir([FromBody] ReservaInputModel reservaInputModel)
        //{
        //    try
        //    {
        //        var reserva = await _reservaService.Inserir(reservaInputModel);

        //        return Ok(reserva);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Conflict();
        //    }
        //}

        //[HttpPut("{idReserva:int}")]
        //public async Task<ActionResult<ReservaViewModel>> Atualizar([FromRoute] int idReserva, [FromBody] ReservaInputModel reservaInputModel)
        //{
        //    try
        //    {
        //        var reserva = await _reservaService.Atualizar(idReserva, reservaInputModel);

        //        return Ok(reserva);
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}

        //[HttpDelete("{idReserva:int}")]
        //public async Task<ActionResult> Deletar([FromRoute] int idReserva)
        //{
        //    try
        //    {
        //        await _reservaService.Deletar(idReserva);

        //        return Ok();
        //    }
        //    catch (Exception ex)
        //    {
        //        return NoContent();
        //    }
        //}
    }
}
