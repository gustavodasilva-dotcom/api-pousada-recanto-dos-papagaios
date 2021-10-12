using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class LoginInputModel
    {
        [Required]
        public string NomeUsuario { get; set; }

        [Required]
        public string SenhaUsuario { get; set; }
    }
}
