namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class PagamentoViewModel
    {
        public int Id { get; set; }
        public TipoPagamentoViewModel TipoPagamento { get; set; }
        public StatusPagamentoViewModel StatusPagamento { get; set; }
    }
}
