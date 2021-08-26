using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class FNRHInputModel
    {
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Profissao { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Nacionalidade { get; set; }
        
        [StringLength(maximumLength: 1, MinimumLength = 1, ErrorMessage = "O dado inserido deve conter apenas um caractere.")]
        public string Sexo { get; set; }

        [StringLength(maximumLength: 9, MinimumLength = 9, ErrorMessage = "O RG deve conter 9 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O RG deve conter apenas números.")]
        public string Rg { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string UltimoDestino { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string ProximoDestino { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string MotivoViagem { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string MeioDeTransporte { get; set; }
        
        [StringLength(maximumLength: 7, ErrorMessage = "A placa do carro deve conter, no máximo, 7 caracteres.")]
        public string PlacaAutomovel { get; set; }

        [Range(0, 3, ErrorMessage = "A quantidade de acompanhantes deve ser de, no máximo, 3 hóspedes.")]
        public int NumAcompanhantes { get; set; }
    }
}
