using System.Collections.Generic;

namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class AcomodacaoUnitaria
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public StatusAcomodacao StatusAcomodacao { get; set; }
        public InformacoesAcomodacao InformacoesAcomodacao { get; set; }
        public CategoriaAcomodacao CategoriaAcomodacao { get; set; }
        public List<ReservaResumida> ProximasReservas { get; set; }
    }
}
