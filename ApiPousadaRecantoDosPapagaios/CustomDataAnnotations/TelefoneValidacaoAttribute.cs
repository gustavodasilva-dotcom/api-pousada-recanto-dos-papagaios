using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class TelefoneValidacaoAttribute : ValidationAttribute
    {
        public TelefoneValidacaoAttribute() { }

        public override bool IsValid(object value)
        {
            var input = (string)value;

            if (input != "")
            {
                if ((input.Trim().Length < 10) || (input.Trim().Length > 12))
                    return false;

                try
                {
                    var isNumeric = Convert.ToInt64(input.Trim());
                }
                catch (Exception)
                {
                    return false;
                }
            }

            return true;
        }
    }
}
