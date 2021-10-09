using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class HospedeInputModel
    {
        [Required]
        public string NomeCompleto { get; set; }

        [Required]
        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string Cpf { get; set; }

        [Required]
        [DataValidacao(ErrorMessage = "O dado informado não procede como uma data.")]
        [MaiorDeIdade(ErrorMessage = "O hóspede deve ser maior de idade.")]
        public string DataDeNascimento { get; set; }

        public UsuarioInputModel Usuario { get; set; }

        public ContatosInputModel Contatos { get; set; }

        public EnderecoInputModel Endereco { get; set; }
    }
}
