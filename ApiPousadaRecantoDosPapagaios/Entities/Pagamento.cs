namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class Pagamento
    {
        public int Id { get; set; }
        public TipoPagamento TipoPagamento { get; set; }
        public StatusPagamento StatusPagamento { get; set; }
    }
}
