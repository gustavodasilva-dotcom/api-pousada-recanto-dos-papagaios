using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class InformacoesAcomodacaoInputModel
    {
        [Required]
        public int Capacidade { get; set; }

        [Required]
        public double Tamanho { get; set; }

        [Required]
        public string TipoDeCama { get; set; }

        [Required]
        public double Preco { get; set; }
    }
}
