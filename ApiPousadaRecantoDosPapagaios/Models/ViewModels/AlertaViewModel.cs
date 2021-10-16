using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class AlertaViewModel
    {
        public int Id { get; set; }

        public string Titulo { get; set; }

        public string Mensagem { get; set; }

        public FuncionarioCheckOutViewModel Funcionario { get; set; }
    }
}
