namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class CheckIn
    {
        public int Id { get; set; }
        public Reserva Reserva { get; set; }
        public Funcionario Funcionario { get; set; }
        public bool Excluido { get; set; }
    }
}
