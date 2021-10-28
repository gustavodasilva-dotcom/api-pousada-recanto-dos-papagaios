using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class AcomodacaoInputModel
    {
        [Required]
        public int IdAcomodacao { get; set; }

        [Required]
        public string Nome { get; set; }

        public CategoriaAcomodacaoInputModel Categoria { get; set; }

        public InformacoesAcomodacaoInputModel InformacoesAcomodacao { get; set; }
    }
}
