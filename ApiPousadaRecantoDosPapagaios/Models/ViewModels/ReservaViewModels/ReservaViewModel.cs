using ApiPousadaRecantoDosPapagaios.Models.ViewModels.ReservaViewModels;
using System;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class ReservaViewModel
    {
        public int Id { get; set; }
        public DateTime DataReserva { get; set; }
        public DateTime DataCheckIn { get; set; }
        public DateTime DataCheckOut { get; set; }
        public int Acompanhantes { get; set; }
        public double PrecoUnitario { get; set; }
        public double PrecoTotal { get; set; }
        public StatusReservaViewModel StatusReserva { get; set; }
        public HospedeReservaViewModel Hospede { get; set; }
        public AcomodacaoViewModel Acomodacao { get; set; }
        public PagamentoViewModel Pagamento { get; set; }
    }
}
