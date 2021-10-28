using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class CategoriaAcomodacaoInputModel
    {
        [Required]
        public int Id { get; set; }
        
        public string Descricao { get; set; }
    }
}
