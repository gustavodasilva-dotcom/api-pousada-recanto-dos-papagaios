namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class InformacoesAcomodacao
    {
        public int Id { get; set; }
        public double MetrosQuadrados { get; set; }
        public int Capacidade { get; set; }
        public string TipoDeCama { get; set; }
        public double Preco { get; set; }
        public CategoriaAcomodacao CategoriaAcomodacao { get; set; }
    }
}
