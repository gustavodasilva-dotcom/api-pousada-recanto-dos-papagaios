using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
        public async Task<ActionResult<IEnumerable<FuncionarioViewModel>>> Obter([FromQuery] int pagina, [FromQuery] int quantidade)
        {
            var funcionarios = await _funcionarioService.Obter(pagina, quantidade);

            if (funcionarios.Count == 0)
                return StatusCode(404, "Não há funcionários cadastrados.");

            return StatusCode(200, funcionarios);
        }

        [HttpGet("{idFuncionario:int}")]
        public async Task<ActionResult<FuncionarioViewModel>> Obter([FromRoute] int idFuncionario)
        {
            try
            {
                var funcionario = await _funcionarioService.Obter(idFuncionario);

                return StatusCode(200, funcionario);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não há funcionário cadastrado com o id informado."))
                {
                    statusCode = 404;
                    mensagem = "Não há funcionário cadastrado com o id informado.";
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
        public async Task<ActionResult<FuncionarioViewModel>> Inserir([FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var funcionario = await _funcionarioService.Inserir(funcionarioInputModel);

                return StatusCode(201, funcionario);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Já existe um funcionário cadastrado no sistema com o CPF "))
                {
                    statusCode = 409;
                    mensagem = "Já existe um funcionário cadastrado no sistema com o CPF informado.";
                }
                else if (ex.Message.Contains("Já existe um usuário cadastrado com o nome de usuário"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um usuário cadastrado com o nome de usuário informado.";
                }
                else
                {
                    statusCode = 500;
                    mensagem = "Ops! Ocorreu um erro do nosso lado. Por gentileza, tente novamente.";
                }

                return StatusCode(statusCode, mensagem);
            }
        }

        [HttpPut("{idFuncionario:int}")]
        public async Task<ActionResult<FuncionarioViewModel>> Atualizar([FromRoute] int idFuncionario, [FromBody] FuncionarioInputModel funcionarioInputModel)
        {
            try
            {
                var funcionario = await _funcionarioService.Atualizar(idFuncionario, funcionarioInputModel);

                return StatusCode(200, funcionario);
            }
            catch (SqlException ex)
            {
                int statusCode;
                string mensagem;

                if (ex.Message.Contains("Não existe nenhum funcionário cadastrado no sistema com o id"))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum funcionário cadastrado no sistema com o id informado.";
                }
                else if (ex.Message.Contains("Já existe um usuário cadastrado com o nome de usuário"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um usuário cadastrado com o nome de usuário informado.";
                }
                else if (ex.Message.Contains("Já existe um funcionário cadastrado com o CPF"))
                {
                    statusCode = 409;
                    mensagem = "Já existe um funcionário cadastrado com o CPF informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de endereço cadastrado para o funcionário informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de endereço cadastrado para o funcionário informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de dados de usuário cadastrados para o funcionário informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de dados de usuário cadastrados para o funcionário informado.";
                }
                else if (ex.Message.Contains("Não existe nenhum registro de contatos cadastrado para o funcionário informado."))
                {
                    statusCode = 404;
                    mensagem = "Não existe nenhum registro de contatos cadastrado para o funcionário informado.";
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
