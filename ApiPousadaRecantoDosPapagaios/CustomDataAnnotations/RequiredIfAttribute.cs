using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class RequiredIfAttribute : ValidationAttribute
    {
        public RequiredIfAttribute() { }

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
