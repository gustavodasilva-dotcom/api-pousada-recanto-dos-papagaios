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

        [Range(1, 6, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int IdPagamento { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        //[DiaAnterior(ErrorMessage = "A data de check-in precisa ser depois ou igual ao dia de hoje.")]
        //[MaisDeTresDias(ErrorMessage = "A data de check-in não pode ser daqui a mais de três dias. Para contatar uma reserva que será daqui a mais de três dias, contate a pousada.")]
        public DateTime DataCheckIn { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        //[DiaAnterior(ErrorMessage = "A data de check-in precisa ser depois ou igual ao dia de hoje.")]
        public DateTime DataCheckOut { get; set; }        

        [Range(0, 3, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int Acompanhantes { get; set; }
    }
}
