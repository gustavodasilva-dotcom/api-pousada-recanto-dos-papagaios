namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class Acomodacao
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public StatusAcomodacao StatusAcomodacao { get; set; }
        public InformacoesAcomodacao InformacoesAcomodacao { get; set; }
        public CategoriaAcomodacao CategoriaAcomodacao { get; set; }
    }
}
