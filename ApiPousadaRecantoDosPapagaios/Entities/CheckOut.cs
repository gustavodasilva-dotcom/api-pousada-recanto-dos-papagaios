namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class CheckOut
    {
        public int Id { get; set; }
        public double ValoresAdicionais { get; set; }
        public double ValorTotal { get; set; }
        public CheckIn CheckIn { get; set; }
        public Funcionario Funcionario { get; set; }
        public Pagamento Pagamento { get; set; }
        public bool Excluido { get; set; }
    }
}
