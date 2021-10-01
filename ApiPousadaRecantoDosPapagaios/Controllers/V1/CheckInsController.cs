using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class CheckInsController : ControllerBase
    {
        private readonly ICheckInService _checkInService;

        private readonly Json _erro;

        public CheckInsController(ICheckInService checkInService)
        {
            _checkInService = checkInService;

            _erro = new Json();
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
            catch (SqlException ex)
            {
                if (ex.Message.Contains("A reserva informada não existe ou não possui check-in."))
                {
                    statusCode = 404;
                    mensagem = "A reserva informada não existe ou não possui check-in.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                var erro = _erro.SerializarJsonDeRetorno(statusCode, mensagem);

                return StatusCode(statusCode, erro);
            }
        }

        [HttpPost]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] CheckInInputModel checkInInputModel)
        {
            var retorno = await _checkInService.Inserir(checkInInputModel);
            
            return StatusCode(retorno.StatusCode, retorno);
        }

    }
}
