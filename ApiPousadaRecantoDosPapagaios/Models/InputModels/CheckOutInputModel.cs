namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class CheckOutInputModel
    {
        public int ReservaId { get; set; }
        public double ValoresAdicionais { get; set; }
        public int PagamentoId { get; set; }
        public string LoginFuncionario { get; set; }        
    }
}
