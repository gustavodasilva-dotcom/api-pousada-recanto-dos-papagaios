using System;

namespace ApiPousadaRecantoDosPapagaios.Exceptions
{
    public class NaoEncontradoException : Exception
    {
        public NaoEncontradoException() { }

        public NaoEncontradoException(string message) : base(message) { }

        public NaoEncontradoException(string message, Exception inner) : base(message, inner) { }
    }
}
