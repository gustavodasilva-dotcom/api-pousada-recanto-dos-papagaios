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

        public FuncionariosController(IFuncionarioService funcionarioService)
        {
            _funcionarioService = funcionarioService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<FuncionarioViewModel>>> Obter()
        {
            var funcionarios = await _funcionarioService.Obter();

            if (funcionarios.Count == 0)
                return NoContent();

            return Ok(funcionarios);
        }

        [HttpGet("{cpfFuncionario}")]
        public async Task<ActionResult<FuncionarioViewModel>> Obter([FromRoute] string cpfFuncionario)
        {
            try
            {
                var funcionario = await _funcionarioService.Obter(cpfFuncionario);

                return Ok(funcionario);
            }
            catch (Exception ex)
            {
                return NoContent();
            }
        }

        [HttpPost]
        public async Task<ActionResult<FuncionarioViewModel>> Inserir([FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var funcionario = await _funcionarioService.Inserir(funcionarioInputModel);

                return Ok(funcionario);
            }
            catch (Exception ex)
            {
                return Conflict();
            }
        }
    }
}
