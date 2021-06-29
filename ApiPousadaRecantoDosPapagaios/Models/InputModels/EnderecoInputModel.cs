using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class EnderecoInputModel
    {
        [StringLength(maximumLength: 8, MinimumLength = 8, ErrorMessage = "O CEP deve conter 8 caracteres.")]
        [DataType(DataType.PostalCode)]
        public string Cep { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Logradouro { get; set; }

        [RegularExpression("^[0-9]*$", ErrorMessage = "O número da residência deve conter apenas números.")]
        public string Numero { get; set; }

        public string Complemento { get; set; }
        
        public string Bairro { get; set; }
        
        public string Cidade { get; set; }

        [StringLength(maximumLength: 2, MinimumLength = 2, ErrorMessage = "O estado deve conter, apenas, 2 caracteres.")]
        public string Estado { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Pais { get; set; }
    }
}
