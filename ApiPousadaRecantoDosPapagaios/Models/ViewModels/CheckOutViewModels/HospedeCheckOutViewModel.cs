using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels
{
    public class HospedeCheckOutViewModel
    {
        public string NomeCompleto { get; set; }

        public string Cpf { get; set; }

        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }
    }
}
