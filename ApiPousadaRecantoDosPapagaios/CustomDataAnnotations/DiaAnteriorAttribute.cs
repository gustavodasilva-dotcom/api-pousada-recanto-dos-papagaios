using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class DiaAnteriorAttribute : ValidationAttribute
    {
        public DiaAnteriorAttribute() { }

        public override bool IsValid(object value)
        {
            var dt = (DateTime)value;

            if (dt > DateTime.Now.AddDays(-1))
            {
                return true;
            }

            return false;
        }
    }
}
