using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class ReservaInputModel
    {
        [Required]
        public int IdHospede { get; set; }

        [Required]
        [Range(1, 10, ErrorMessage = "O id da acomodação deve estar entre 1 e 10.")]
        public int IdAcomodacao { get; set; }

        [Range(1, 7, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int IdPagamento { get; set; }

        [DataValidacao(ErrorMessage = "O dado informado não corresponde a uma data.")]
        public string DataCheckIn { get; set; }

        [DataValidacao(ErrorMessage = "O dado informado não corresponde a uma data.")]
        public string DataCheckOut { get; set; }        

        //[Range(0, 3, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int Acompanhantes { get; set; }
    }
}
