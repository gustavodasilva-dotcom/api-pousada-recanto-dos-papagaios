using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class FuncionariosController : ControllerBase
    {
        private readonly IFuncionarioService _funcionarioService;

        private readonly Json _erro;

        public FuncionariosController(IFuncionarioService funcionarioService)
        {
            _funcionarioService = funcionarioService;

            _erro = new Json();
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<FuncionarioViewModel>>> Obter([FromQuery] int pagina, [FromQuery] int quantidade)
        {
            if (pagina == 0 || quantidade == 0)
                return BadRequest();

            try
            {
                var funcionarios = await _funcionarioService.Obter(pagina, quantidade);

                return Ok(funcionarios);
            }
            catch (NaoEncontradoException)
            {
                return NotFound();
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpGet("{idFuncionario:int}")]
        public async Task<ActionResult<FuncionarioViewModel>> Obter([FromRoute] int idFuncionario)
        {
            if (idFuncionario == 0)
                return BadRequest();

            try
            {
                var funcionario = await _funcionarioService.Obter(idFuncionario);

                return Ok(funcionario);
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
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var funcionario = await _funcionarioService.Inserir(funcionarioInputModel);

                return StatusCode(funcionario.StatusCode, funcionario);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

        [HttpPut("{idFuncionario:int}")]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromRoute] int idFuncionario, [FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var retorno = await _funcionarioService.Atualizar(idFuncionario, funcionarioInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.");
            }
        }

    }
}
