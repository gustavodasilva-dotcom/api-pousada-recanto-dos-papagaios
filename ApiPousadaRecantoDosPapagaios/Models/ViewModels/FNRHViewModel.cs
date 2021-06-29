using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class FNRHViewModel
    {
        public int Id { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11)]
        public string CpfHospede { get; set; }
        
        public string Profissao { get; set; }
        
        public string Nacionalidade { get; set; }
        
        [StringLength(maximumLength: 1, MinimumLength = 1)]
        public string Sexo { get; set; }

        [StringLength(maximumLength: 9, MinimumLength = 9)]
        public string Rg { get; set; }

        public string UltimoDestino { get; set; }
        
        public string ProximoDestino { get; set; }
        
        public string MotivoViagem { get; set; }
        
        public string MeioDeTransporte { get; set; }

        [StringLength(maximumLength: 7, MinimumLength = 7)]
        public string PlacaAutomovel { get; set; }

        [StringLength(maximumLength: 4, MinimumLength = 0)]
        public int NumAcompanhantes { get; set; }
    }
}
