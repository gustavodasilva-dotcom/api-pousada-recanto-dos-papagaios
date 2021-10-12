using ApiPousadaRecantoDosPapagaios.Models.ViewModels.ReservaViewModels;
using System.Collections.Generic;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class AcomodacaoUnitariaViewModel
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public StatusAcomodacaoViewModel StatusAcomodacao { get; set; }
        public InformacoesAcomodacaoViewModel InformacoesAcomodacao { get; set; }
        public CategoriaAcomodacaoViewModel CategoriaAcomodacao { get; set; }
        public List<ReservaResumidaViewModel> ProximasReservas { get; set; }
    }
}
