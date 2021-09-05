namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class CheckInViewModel
    {
        public int Id { get; set; }
        public ReservaViewModel Reserva { get; set; }
        public string UsuarioFuncionario { get; set; }
    }
}
