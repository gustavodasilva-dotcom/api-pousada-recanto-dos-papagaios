using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class ContatosInputModel
    {
        [Required]
        [DataType(DataType.EmailAddress, ErrorMessage = "O dado inserido não corresponde a um e-mail.")]
        public string Email { get; set; }

        [CelularValidacao(ErrorMessage = "O número de celular deve conter entre 11 e 13 dígitos.")]
        public string Celular { get; set; }

        [TelefoneValidacao(ErrorMessage = "O número de telefone deve conter entre 10 e 12 dígitos.")]
        public string Telefone { get; set; }
    }
}