using System;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels
{
    public class ReservaCheckOutViewModel
    {
        public int Id { get; set; }
        public DateTime DataReserva { get; set; }
        public DateTime DataCheckIn { get; set; }
        public DateTime DataCheckOut { get; set; }
        public double PrecoUnitario { get; set; }
        public double PrecoTotal { get; set; }
        public HospedeCheckOutViewModel Hospede { get; set; }
        public AcomodacaoCheckOutViewModel Acomodacao { get; set; }
        public int Acompanhantes { get; set; }
    }
}
