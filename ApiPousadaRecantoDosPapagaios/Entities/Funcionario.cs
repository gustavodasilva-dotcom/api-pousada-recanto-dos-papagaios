namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class Funcionario : Pessoa
    {
        public string Nacionalidade { get; set; }
        public string Sexo { get; set; }
        public string Rg { get; set; }
        public string Cargo { get; set; }
        public string Setor { get; set; }
        public double Salario { get; set; }
        public DadosBancarios DadosBancarios { get; set; }
        public CategoriaAcesso CategoriaAcesso { get; set; }
    }
}
