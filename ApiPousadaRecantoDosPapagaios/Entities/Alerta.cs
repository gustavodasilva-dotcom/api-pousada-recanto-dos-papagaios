namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class Alerta
    {
        public int Id { get; set; }

        public string Titulo { get; set; }

        public string Mensagem { get; set; }

        public Funcionario Funcionario { get; set; }
    }
}
