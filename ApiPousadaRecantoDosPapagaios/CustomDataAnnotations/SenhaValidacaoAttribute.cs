using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class SenhaValidacaoAttribute : ValidationAttribute
    {
        public SenhaValidacaoAttribute () { }

        public override bool IsValid(object value)
        {
            var input = (string)value;

            if (input != "" || input == null)
            {
                /* 
                 * TODO: Corrigir este Regex:
                if (!Regex.IsMatch(input, "'%[a-z][A-Z][0-9]%'"))
                {
                    return false;
                }
                */
            }

            return true;
        }
    }
}
