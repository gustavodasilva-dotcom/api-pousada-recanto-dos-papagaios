using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Controllers.V1
{
    [Route("api/V1/[controller]")]
    [ApiController]
    public class FuncionariosController : ControllerBase
    {
        private readonly IFuncionarioService _funcionarioService;

        public FuncionariosController(IFuncionarioService funcionarioService)
        {
            _funcionarioService = funcionarioService;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
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
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
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
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpGet("{cpf}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<FuncionarioViewModel>> Obter([FromRoute] string cpf)
        {
            if (cpf.Length != 11)
                return BadRequest();

            if (!Regex.IsMatch(cpf, @"^\d+$"))
                return BadRequest();

            try
            {
                var funcionario = await _funcionarioService.Obter(cpf);

                return Ok(funcionario);
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

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status422UnprocessableEntity)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var funcionario = await _funcionarioService.Inserir(funcionarioInputModel);

                return StatusCode(funcionario.StatusCode, funcionario);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }

        [HttpPut("{idFuncionario:int}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<RetornoViewModel>> Atualizar([FromRoute] int idFuncionario, [FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            if (idFuncionario == 0)
                return BadRequest();

            try
            {
                var retorno = await _funcionarioService.Atualizar(idFuncionario, funcionarioInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
