using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class EnderecoInputModel
    {
        [StringLength(8, MinimumLength = 8)]
        public string Cep { get; set; }

        public string Logradouro { get; set; }

        [StringLength(maximumLength: 8)]
        public string Numero { get; set; }

        public string Complemento { get; set; }
        
        public string Bairro { get; set; }
        
        public string Cidade { get; set; }

        [StringLength(maximumLength: 2, MinimumLength = 2)]
        public string Estado { get; set; }
        
        public string Pais { get; set; }
    }
}
