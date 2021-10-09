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
                if ((input.Length < 11) || (input.Length > 13))
                    return false;
            }

            return true;
        }
    }
}
