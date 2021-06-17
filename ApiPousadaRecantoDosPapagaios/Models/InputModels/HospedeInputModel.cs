﻿using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class HospedeInputModel
    {
        public string NomeCompleto { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string Cpf { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        public DateTime DataDeNascimento { get; set; }
        
        [DataType(DataType.EmailAddress, ErrorMessage = "O dado inserido não corresponde a um e-mail.")]
        public string Email { get; set; }
        
        // TODO: Verificar com o grupo como serão trabalhados os logins.
        public string Login { get; set; }
        
        [DataType(DataType.Password, ErrorMessage = "O dado inserido não corresponde a uma senha.")]
        public string Senha { get; set; }

        [StringLength(maximumLength: 15, MinimumLength = 13)]
        [DataType(DataType.PhoneNumber, ErrorMessage = "O dado inserido não corresponde a um número de celular.")]
        public string Celular { get; set; }
        
        public EnderecoInputModel Endereco { get; set; }
    }
}
