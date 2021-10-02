using ApiPousadaRecantoDosPapagaios.Exceptions;
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

        public CheckInsController(ICheckInService checkInService)
        {
            _checkInService = checkInService;
        }

        [HttpGet("{idReserva:int}")]
        public async Task<ActionResult<CheckInViewModel>> Obter([FromRoute] int idReserva)
        {
            int statusCode;
            string mensagem;

            try
            {
                var checkIn = await _checkInService.Obter(idReserva);

                statusCode = 200;

                return StatusCode(statusCode, checkIn);
            }
            catch (NaoEncontradoException)
            {
                statusCode = 404;
                mensagem = "A reserva informada não existe ou ainda não possui check-in.";

                return StatusCode(statusCode, mensagem);
            }
            catch (Exception)
            {
                statusCode = 500;
                mensagem = "Um erro inesperado aconteceu. Por favor, tente mais tarde.";

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpPost]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] CheckInInputModel checkInInputModel)
        {
            try
            {
                var retorno = await _checkInService.Inserir(checkInInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
