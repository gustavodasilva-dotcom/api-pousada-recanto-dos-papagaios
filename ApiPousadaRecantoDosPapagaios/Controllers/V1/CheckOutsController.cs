using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Mvc;
using System;
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

        //[HttpPost]
        //public async Task<ActionResult<CheckOutViewModel>> Inserir([FromBody] CheckOutInputModel checkOutInputModel)
        //{
        //    try
        //    {
        //        var checkOut = await _checkOutRepository.Inserir(checkOutInputModel);

        //        return Ok(checkOut);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Conflict();
        //    }
        //}
    }
}
