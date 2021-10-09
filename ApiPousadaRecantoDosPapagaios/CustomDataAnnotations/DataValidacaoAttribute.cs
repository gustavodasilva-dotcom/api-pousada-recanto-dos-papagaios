using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class DataValidacaoAttribute : ValidationAttribute
    {
        public DataValidacaoAttribute() { }

        public override bool IsValid(object value)
        {
            var dtEntrada = (string)value;

            if (!DateTime.TryParse(dtEntrada, out _))
            {
                return false;
            }

            return true;
        }
    }
}
