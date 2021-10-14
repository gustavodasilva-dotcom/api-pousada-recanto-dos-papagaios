using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class AlertaInputModel
    {
        [Required]
        [StringLength(50, ErrorMessage = "O título deve conter, no máximo, 50 caracteres.")]
        public string Titulo { get; set; }

        [Required]
        [StringLength(200, ErrorMessage = "A mensagem deve conter, no máximo, 200 caracteres.")]
        public string Mensagem { get; set; }

        [Required]
        public int IdFuncionario { get; set; }
    }
}
