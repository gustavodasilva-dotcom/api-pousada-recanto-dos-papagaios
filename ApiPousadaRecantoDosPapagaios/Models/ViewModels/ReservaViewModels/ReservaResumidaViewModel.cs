using System;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels.ReservaViewModels
{
    public class ReservaResumidaViewModel
    {
        public int idReserva { get; set; }
        public DateTime DataCheckIn { get; set; }
        public DateTime DataCheckOut { get; set; }
        public HospedeReservaViewModel Hospede { get; set; }
    }
}
