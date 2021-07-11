namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels
{
    public class CheckOutViewModel
    {
        public int Id { get; set; }
        public double ValoresAdicionais { get; set; }
        public double ValorTotal { get; set; }
        public CheckInCheckOutViewModel CheckIn { get; set; }
        public FuncionarioCheckOutViewModel Funcionario { get; set; }
        public PagamentoViewModel Pagamento { get; set; }
        public bool Excluido { get; set; }
    }
}
