using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class ContatosInputModel
    {
        [Required]
        [DataType(DataType.EmailAddress, ErrorMessage = "O dado inserido não corresponde a um e-mail.")]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.PhoneNumber)]
        [StringLength(maximumLength: 13, MinimumLength = 11, ErrorMessage = "O número de celular deve conter entre 11 e 13 dígitos.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O celular deve conter apenas números.")]
        public string Celular { get; set; }

        [DataType(DataType.PhoneNumber)]
        [RequiredIf(ErrorMessage = "O número de telefone deve conter entre 10 e 12 dígitos.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O telefone deve conter apenas números.")]
        public string Telefone { get; set; }
    }
}