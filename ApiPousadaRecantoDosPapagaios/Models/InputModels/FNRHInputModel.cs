using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class FNRHInputModel
    {
        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string CpfHospede { get; set; }

        public string Profissao { get; set; }
        
        public string Nacionalidade { get; set; }
        
        [StringLength(maximumLength: 1, MinimumLength = 1)]
        public string Sexo { get; set; }

        [StringLength(maximumLength: 9, MinimumLength = 9, ErrorMessage = "O RG deve conter 9 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O RG deve conter apenas números.")]
        public string Rg { get; set; }

        public string UltimoDestino { get; set; }
        
        public string ProximoDestino { get; set; }
        
        public string MotivoViagem { get; set; }
        
        public string MeioDeTransporte { get; set; }
        
        [StringLength(maximumLength: 7, ErrorMessage = "A placa do carro deve conter, no máximo, 7 caracteres.")]
        public string PlacaAutomovel { get; set; }

        [Range(0, 3, ErrorMessage = "A quantidade de acompanhantes deve ser de, no máximo, 3 hóspedes.")]
        public int NumAcompanhantes { get; set; }
    }
}
