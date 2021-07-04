using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
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

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ReservaViewModel>>> Obter([FromQuery, Range(1, int.MaxValue)] int pagina = 1, [FromQuery, Range(1, 50)] int quantidade = 5)
        {
            // TODO: aplicar, no JSON de saída, os dados do titular da reserva, seguindo as regras estabelecidas
            // da pousada, e remover tabela e classe HOSPEDE_RESERVA.
            var reservas = await _reservaService.Obter(pagina, quantidade);

            if (reservas.Count == 0)
                return NoContent();

            return Ok(reservas);
        }
    }
}
