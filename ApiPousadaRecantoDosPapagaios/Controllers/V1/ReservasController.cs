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
    public class ReservasController : ControllerBase
    {
        private readonly IReservaService _reservaService;

        private readonly Json _erro;

        public ReservasController(IReservaService reservaService)
        {
            _reservaService = reservaService;

            _erro = new Json();
        }

        [HttpGet("{idReserva:int}")]
        public async Task<ActionResult<ReservaViewModel>> Obter([FromRoute] int idReserva)
        {
            try
            {
                var reserva = await _reservaService.Obter(idReserva);

                return StatusCode(200, reserva);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("não consta como nenhuma reserva."))
                {
                    statusCode = 404;
                    mensagem = "Não foi possível encontrar uma reserva, pois o id informado não consta como nenhuma reserva.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                var retornoErro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }
        }

        [HttpPost]
        public async Task<ActionResult<ReservaViewModel>> Inserir([FromBody] ReservaInputModel reservaInputModel)
        {
            try
            {
                var reserva = await _reservaService.Inserir(reservaInputModel);

                return StatusCode(201, reserva);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não há hóspede cadastrado com o id"))
                {
                    statusCode = 404;
                    mensagem = "Não há hóspede cadastrado com o id informado.";
                }
                else if (ex.Message.Contains("As data de check-in e check-out não podem ser menores do que o dia atual."))
                {
                    statusCode = 422;
                    mensagem = "As data de check-in e check-out não podem ser menores do que o dia atual.";
                }
                else if (ex.Message.Contains("A data de check-in selecionada está a mais do que 3 dias de hoje."))
                {
                    statusCode = 422;
                    mensagem = "A data de check-in selecionada está a mais do que 3 dias de hoje. " +
                               "Em casos assim, deve-se contatar a Pousada para realizar a reserva.";
                }
                else if (ex.Message.Contains("A data de check-in é maior do que a data de check-out."))
                {
                    statusCode = 422;
                    mensagem = "A data de check-in é maior do que a data de check-out.";
                }
                else if (ex.Message.Contains("Esse chalé está ocupado no período selecionado."))
                {
                    statusCode = 409;
                    mensagem = "Esse chalé está ocupado no período selecionado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                var retornoErro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }
        }

        [HttpPut("{idReserva:int}")]
        public async Task<ActionResult<ReservaViewModel>> Atualizar([FromRoute] int idReserva, [FromBody] ReservaUpdateInputModel reservaInputModel)
        {
            string mensagem;
            int statusCode;

            try
            {
                var reserva = await _reservaService.Atualizar(idReserva, reservaInputModel);

                statusCode = 200;

                return StatusCode(statusCode, reserva);
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("Não há reserva com o id "))
                {
                    mensagem = "Não há reserva com o id informado.";
                    statusCode = 404;
                }
                else if (ex.Message.Contains("Não é possível atualizar uma reserva que já passou da data de check-in."))
                {
                    mensagem = "Não é possível atualizar uma reserva que já passou da data de check-in.";
                    statusCode = 409;
                }
                else if (ex.Message.Contains("Não é possível alterar reservas com check-in."))
                {
                    mensagem = "A reserva informada possui check-in. Não é possível alterar reservas com check-in.";
                    statusCode = 409;
                }
                else if (ex.Message.Contains("O tipo de pagamento é igual a dinheiro e cartão de débito."))
                {
                    mensagem = "O tipo de pagamento é igual a dinheiro e cartão de débito." +
                               "Portanto, não é possível alterar as informações dessa reserva.";
                    statusCode = 409;
                }
                else if (ex.Message.Contains("O pagamento da reserva está aprovado ou em processamento."))
                {
                    mensagem = "O pagamento da reserva está aprovado ou em processamento. Portanto, não é possível atualizar a reserva.";
                    statusCode = 409;
                }
                else if (ex.Message.Contains("A acomodação selecionada está indisponível no período selecionado."))
                {
                    mensagem = "A acomodação selecionada está indisponível no período selecionado.";
                    statusCode = 409;
                }
                else if (ex.Message.Contains("A data de check-in selecionada está a mais do que 3 dias de hoje."))
                {
                    mensagem = "A data de check-in selecionada está a mais do que 3 dias de hoje." +
                               "Em casos assim, deve-se contatar a Pousada para realizar a reserva.";
                    statusCode = 422;
                }
                else if (ex.Message.Contains("A data de check-in não pode ser maior que a data de check-out primeiramente cadastrada."))
                {
                    mensagem = "A data de check-in não pode ser maior que a data de check-out primeiramente cadastrada.";
                    statusCode = 422;
                }
                else if (ex.Message.Contains("A data de check-in não pode ser maior que a data de check-out."))
                {
                    mensagem = "A data de check-in não pode ser maior que a data de check-out.";
                    statusCode = 422;
                }
                else if (ex.Message.Contains("O número de acompanhantes não pode ser maior do que 3."))
                {
                    mensagem = "O número de acompanhantes não pode ser maior do que 3.";
                    statusCode = 422;
                }
                else
                {
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                    statusCode = 500;
                }

                var retornoErro = _erro.SerializarJsonDeErro(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }
        }

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
