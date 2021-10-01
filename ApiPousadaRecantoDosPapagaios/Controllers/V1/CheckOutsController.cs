using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class CheckOutsController : ControllerBase
    {
        private readonly ICheckOutService _checkOutRepository;

        private readonly Json _erro;

        public CheckOutsController(ICheckOutService checkOutService)
        {
            _checkOutRepository = checkOutService;

            _erro = new Json();
        }

        [HttpGet("{idReserva:int}")]
        public async Task<ActionResult<CheckOutViewModel>> Obter([FromRoute] int idReserva)
        {
            int statusCode;
            string mensagem;

            try
            {
                var checkOut = await _checkOutRepository.Obter(idReserva);

                statusCode = 200;

                return StatusCode(statusCode, checkOut);
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains(""))
                {
                    statusCode = 404;
                    mensagem = "";
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
        public async Task<ActionResult<CheckOutViewModel>> Inserir([FromBody] CheckOutInputModel checkOutInputModel)
        {
            int statusCode;
            string mensagem;

            try
            {
                var checkOut = await _checkOutRepository.Inserir(checkOutInputModel);

                statusCode = 201;

                return StatusCode(statusCode, checkOut);
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("O tipo de pagamento não pode estar nulo"))
                {
                    statusCode = 422;
                    mensagem = "O tipo de pagamento não pode estar nulo quando houver pagamento adicional.";
                }
                else if (ex.Message.Contains("Os valores adicionais não podem estar "))
                {
                    statusCode = 422;
                    mensagem = "Os valores adicionais não podem estar nulos quando houver pagamento adicional.";
                }
                else if (ex.Message.Contains(" não corresponde a uma reserva."))
                {
                    statusCode = 404;
                    mensagem = "O id informado não corresponde a uma reserva.";
                }
                else if (ex.Message.Contains(" não corresponde a um funcionário."))
                {
                    statusCode = 404;
                    mensagem = "O id informado não corresponde a um funcionário.";
                }
                else if (ex.Message.Contains(" não possui check-in."))
                {
                    statusCode = 409;
                    mensagem = "A reserva informada não possui check-in.";
                }
                else if (ex.Message.Contains(" já possui check-out: "))
                {
                    statusCode = 409;
                    mensagem = "A reserva informada já possui check-out.";
                }
                else if (ex.Message.Contains("Portanto, não é possível prosseguir com o check-out."))
                {
                    statusCode = 409;
                    mensagem =  "A reserva informada não está com o status de pagamento aprovado." +
                                " Portanto, não é possível prosseguir com o check-out.";
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
    }
}
