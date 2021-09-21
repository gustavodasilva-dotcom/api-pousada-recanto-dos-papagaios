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

                var erro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, erro);
            }
        }

        [HttpPost]
        public async Task<ActionResult<CheckInViewModel>> Inserir([FromBody] CheckInInputModel checkInInputModel)
        {
            int statusCode;
            string mensagem;

            try
            {
                var checkIn = await _checkInService.Inserir(checkInInputModel);

                statusCode = 201;

                return StatusCode(statusCode, checkIn);
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("Não existe, no sistema, reserva com o id"))
                {
                    statusCode = 404;
                    mensagem = "Não existe, no sistema, reserva com o id informado.";
                }
                else if (ex.Message.Contains(" já possui check-in."))
                {
                    statusCode = 409;
                    mensagem = "A reserva informada já possui check-in.";
                }
                else if (ex.Message.Contains(" já possui check-out."))
                {
                    statusCode = 409;
                    mensagem = "A reserva informada já possui check-out.";
                }
                else if (ex.Message.Contains(" passou da data de check-in."))
                {
                    statusCode = 409;
                    mensagem = "A reserva informada passou da data de check-in.";
                }
                else if (ex.Message.Contains(" não corresponde a um funcionário."))
                {
                    statusCode = 404;
                    mensagem = "O id do funcionário informado não corresponde a um funcionário.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                var erro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, erro);
            }
        }

    }
}
