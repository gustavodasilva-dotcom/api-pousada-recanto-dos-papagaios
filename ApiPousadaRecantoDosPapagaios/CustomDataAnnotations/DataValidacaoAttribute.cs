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

            try
            {
                var dataValida = DateTime.ParseExact(dtEntrada, "yyyy-MM-dd HH:mm:ssZ", null);
            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }
    }
}
