using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
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

        public CheckOutsController(ICheckOutService checkOutService)
        {
            _checkOutRepository = checkOutService;
        }

        [HttpGet("{idReserva:int}")]
        public async Task<ActionResult<CheckOutViewModel>> Obter([FromRoute] int idReserva)
        {
            try
            {
                var checkOut = await _checkOutRepository.Obter(idReserva);

                return Ok(checkOut);
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
        public async Task<ActionResult<RetornoViewModel>> Inserir([FromBody] CheckOutInputModel checkOutInputModel)
        {
            try
            {
                var retorno = await _checkOutRepository.Inserir(checkOutInputModel);

                return StatusCode(retorno.StatusCode, retorno);
            }
            catch (Exception)
            {
                return StatusCode(500, "Um erro inesperado aconteceu. Por favor, tente mais tarde.");
            }
        }
    }
}
