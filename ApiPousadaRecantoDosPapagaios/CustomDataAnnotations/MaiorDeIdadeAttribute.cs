using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class MaiorDeIdadeAttribute : ValidationAttribute
    {
        public MaiorDeIdadeAttribute() { }

        public override bool IsValid(object value)
        {
            var dtEntrada = (string)value;

            if (DateTime.TryParse(dtEntrada, out _))
            {
                var dtAniversario = Convert.ToDateTime(dtEntrada);

                if (dtAniversario >= DateTime.Now.AddYears(-18))
                {
                    return false;
                }
            }
            else
            {
                return false;
            }

            return true;
        }
    }
}
