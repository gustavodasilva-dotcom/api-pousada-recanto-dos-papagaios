using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.CustomDataAnnotations
{
    public class MaisDeTresDiasAttribute : ValidationAttribute
    {
        public MaisDeTresDiasAttribute() { }

        public override bool IsValid(object value)
        {
            var dt = (DateTime)value;

            if (dt > DateTime.Now.AddDays(3))
            {
                return false;
            }

            return true;
        }
    }
}
