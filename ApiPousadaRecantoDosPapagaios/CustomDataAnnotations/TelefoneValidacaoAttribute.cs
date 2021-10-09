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
                if ((input.Length < 10) || (input.Length > 12))
                    return false;
            }

            return true;
        }
    }
}
