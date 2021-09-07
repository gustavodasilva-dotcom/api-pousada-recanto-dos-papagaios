namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class CheckOutInputModel
    {
        public int IdReserva { get; set; }
        public int IdFuncionario { get; set; }
        public int ValoresAdicionais { get; set; }
        public int TipoPagamento { get; set; }
        public double ValorAdicional { get; set; }
    }
}
