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

        private readonly Erro _erro;

        public CheckOutsController(ICheckOutService checkOutService)
        {
            _checkOutRepository = checkOutService;

            _erro = new Erro();
        }

        [HttpPost]
        public async Task<ActionResult<CheckOutViewModel>> Inserir([FromBody] CheckOutInputModel checkOutInputModel)
        {
            //try
            //{
                var checkOut = await _checkOutRepository.Inserir(checkOutInputModel);

                return Ok(checkOut);
            //}
            //catch (SqlException ex)
            //{
            //    return Conflict();
            //}
        }
    }
}
