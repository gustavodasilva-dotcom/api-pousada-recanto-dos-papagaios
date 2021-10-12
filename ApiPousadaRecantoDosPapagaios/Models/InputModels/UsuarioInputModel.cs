using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class UsuarioInputModel
    {
        public string NomeUsuario { get; set; }

        [SenhaValidacao(ErrorMessage = "A senha deve conter, no mínimo, um caracter maiúsculo, um minusculo e um número.")]
        public string SenhaUsuario { get; set; }
    }
}