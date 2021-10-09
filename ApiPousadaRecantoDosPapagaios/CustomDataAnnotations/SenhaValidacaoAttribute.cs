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

            if (input != "")
            {
                if (!Regex.IsMatch(input, "'%[a-z][A-Z][0-9]%'"))
                {
                    return false;
                }
            }

            return true;
        }
    }
}
