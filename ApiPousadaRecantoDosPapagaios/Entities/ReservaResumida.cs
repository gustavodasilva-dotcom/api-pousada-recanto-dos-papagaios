using System;

namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class ReservaResumida
    {
        public int idReserva { get; set; }
        public DateTime DataCheckIn { get; set; }
        public DateTime DataCheckOut { get; set; }
        public HospedeReserva Hospede { get; set; } 
    }
}
