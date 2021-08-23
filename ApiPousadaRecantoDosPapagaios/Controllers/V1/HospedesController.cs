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

        public HospedesController(IHospedeService hospedeService)
        {
            _hospedeService = hospedeService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<HospedeViewModel>>> Obter([FromQuery] int pagina, [FromQuery] int quantidade)
        {
            var hospedes = await _hospedeService.Obter(pagina, quantidade);
            
            if (hospedes.Count == 0)
                return StatusCode(404, "Não há hóspedes cadastrados.");
            
            return StatusCode(200, hospedes);
        }

        [HttpGet("{idHospede:int}")]
        public async Task<ActionResult<HospedeViewModel>> Obter([FromRoute] int idHospede)
        {
            try
            {
                var hospede = await _hospedeService.Obter(idHospede);

                return StatusCode(200, hospede);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não há hóspede cadastrado com o id informado."))
                {
                    statusCode = 404;
                    mensagem = "Não há hóspede cadastrado com o id informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpPost]
        public async Task<ActionResult<HospedeViewModel>> Inserir([FromBody] HospedeInputModel hospedeInputModel)
        {
            try
            {
                var hospede = await _hospedeService.Inserir(hospedeInputModel);

                return StatusCode(201, hospede);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Já existe um hóspede cadastrado no sistema"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um hóspede cadastrado no sistema com o CPF informado.";
                }
                else if (ex.Message.Contains("Já existe um hóspede cadastrado com o nome de usuário"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um hóspede cadastrado com o nome de usuário informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
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

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpDelete("{idHospede:int}")]
        public async Task<ActionResult> Remover([FromRoute] int idHospede)
        {
            try
            {
                await _hospedeService.Remover(idHospede);

                return StatusCode(200);
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
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
            }
        }

    }
}
