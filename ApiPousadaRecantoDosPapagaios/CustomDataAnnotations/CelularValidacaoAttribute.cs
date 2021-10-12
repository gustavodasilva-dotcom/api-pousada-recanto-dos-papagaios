using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class CelularValidacaoAttribute : ValidationAttribute
    {
        public CelularValidacaoAttribute() { }

        public override bool IsValid(object value)
        {
            var input = (string)value;

            if (input != "")
            {
                if ((input.Trim().Length < 11) || (input.Trim().Length > 13))
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
