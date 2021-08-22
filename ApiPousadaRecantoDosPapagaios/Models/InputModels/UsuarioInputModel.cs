using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class UsuarioInputModel
    {
        public string NomeUsuario { get; set; }

        [DataType(DataType.Password)]
        public string SenhaUsuario { get; set; }
    }
}