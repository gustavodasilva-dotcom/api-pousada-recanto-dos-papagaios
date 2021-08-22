using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class MaiorDeIdadeAttribute : ValidationAttribute
    {
        public MaiorDeIdadeAttribute() { }

        public override bool IsValid(object value)
        {
            var dt = (DateTime)value;

            if (dt >= DateTime.Now.AddYears(-18))
            {
                return false;
            }

            return true;
        }
    }
}
