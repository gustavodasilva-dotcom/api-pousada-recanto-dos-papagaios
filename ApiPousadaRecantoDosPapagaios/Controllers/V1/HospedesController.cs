using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class HospedesController : ControllerBase
    {
        private readonly IHospedeService _hospedeService;

        private readonly Json _erro;

        public HospedesController(IHospedeService hospedeService)
        {
            _hospedeService = hospedeService;

            _erro = new Json();
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<HospedeViewModel>>> Obter([FromQuery] int pagina = 1, [FromQuery] int quantidade = 5)
        {
            try
            {
                var hospedes = await _hospedeService.Obter(pagina, quantidade);

                return Ok(hospedes);
            }
            catch (NaoEncontradoException)
            {
                return NotFound();
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpGet("{idHospede:int}")]
        public async Task<ActionResult<HospedeViewModel>> Obter([FromRoute] int idHospede)
        {
            try
            {
                var hospede = await _hospedeService.Obter(idHospede);

                return Ok(hospede);
            }
            catch (NaoEncontradoException)
            {
                return NotFound();
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPost]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            try
            {
                var retorno = await _hospedeService.Inserir(hospedeInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPut("{idHospede:int}")]
        public async Task<ActionResult<HospedeViewModel>> Atualizar([FromRoute] int idHospede, [FromBody] HospedeInputModel hospedeInputModel)
        {
            try
            {
                var hospede = await _hospedeService.Atualizar(idHospede, hospedeInputModel);

                return StatusCode(200, hospede);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não existe nenhum hóspede cadastrado no sistema com o id"))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum hóspede cadastrado no sistema com o id informado.";
                }
                else if (ex.Message.Contains("Já existe um hóspede cadastrado com o nome de usuário"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um hóspede cadastrado com o nome de usuário informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de endereço cadastrado para o hóspede informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de endereço cadastrado para o hóspede informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de dados de usuário cadastrados para o hóspede informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de dados de usuário cadastrados para o hóspede informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de contatos cadastrado para o hóspede informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de contatos cadastrado para o hóspede informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                var retornoErro = _erro.SerializarJsonDeRetorno(statusCode, mensagem);

                return StatusCode(statusCode, retornoErro);
            }
        }

        [HttpDelete("{idHospede:int}")]
        public async Task<ActionResult<RetornoViewModel>> Remover([FromRoute] int idHospede)
        {
            try
            {
                var hospede = await _hospedeService.Remover(idHospede);

                return StatusCode(hospede.StatusCode, hospede);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

    }
}
