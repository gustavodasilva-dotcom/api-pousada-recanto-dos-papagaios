﻿using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class EnderecoViewModel
    {
        [DataType(DataType.PostalCode)]
        public string Cep { get; set; }

        public string Logradouro { get; set; }
        
        public string Numero { get; set; }
        
        public string Complemento { get; set; }
        
        public string Bairro { get; set; }
        
        public string Cidade { get; set; }
        
        public string Estado { get; set; }
        
        public string Pais { get; set; }
    }
}
