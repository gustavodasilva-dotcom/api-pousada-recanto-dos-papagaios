using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class ReservasController : ControllerBase
    {
        private readonly IReservaService _reservaService;

        private readonly Erro _erro;

        public ReservasController(IReservaService reservaService)
        {
            _reservaService = reservaService;

            _erro = new Erro();
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
