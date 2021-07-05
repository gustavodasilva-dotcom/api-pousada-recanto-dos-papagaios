using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class ReservaInputModel
    {
        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        [DiaAnterior(ErrorMessage = "A data de check-in precisa ser depois ou igual ao dia de hoje.")]
        public DateTime DataCheckIn { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        [DiaAnterior(ErrorMessage = "A data de check-in precisa ser depois ou igual ao dia de hoje.")]
        public DateTime DataCheckOut { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string CpfHospede { get; set; }

        [Range(1, 10, ErrorMessage = "O id da acomodação deve estar entre 1 e 10.")]
        public int AcomodacaoId { get; set; }

        [Range(1, 6, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int PagamentoId { get; set; }

        [Range(0, 3, ErrorMessage = "O id do pagamento deve estar entre 1 e 6.")]
        public int Acompanhantes { get; set; }
    }
}
