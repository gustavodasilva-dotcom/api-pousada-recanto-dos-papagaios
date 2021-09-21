using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class ReservaUpdateInputModel
    {
        [Required]
        [Range(1, 10, ErrorMessage = "O id da acomodação deve estar entre 1 e 10.")]
        public int IdAcomodacao { get; set; }

        [Range(1, 6, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int IdPagamento { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        public DateTime DataCheckIn { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        public DateTime DataCheckOut { get; set; }

        [Range(0, 3, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int Acompanhantes { get; set; }
    }
}
