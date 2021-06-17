﻿namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class FNRH
    {
        public string CpfHospede { get; set; }
        public string Profissao { get; set; }
        public string Nacionalidade { get; set; }
        public string Sexo { get; set; }
        public string Rg { get; set; }
        public string UltimoDestino { get; set; }
        public string ProximoDestino { get; set; }
        public string MotivoViagem { get; set; }
        public string MeioDeTransporte { get; set; }
        public string PlacaAutomovel { get; set; }
        public int NumAcompanhantes { get; set; }
        public int HospedeId { get; set; }
        public int Excluido { get; set; }
        public virtual Hospede Hospede { get; set; }
    }
}
