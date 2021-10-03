USE RECPAPAGAIOS
GO

CREATE FUNCTION [dbo].[CalcularValorDaReserva](@ValorAcomodacao float(2), @DataCheckIn date, @DataCheckOut date, @Acompanhantes int)

RETURNS FLOAT(2)

BEGIN

	RETURN ((@ValorAcomodacao * DATEDIFF(DAY, @DataCheckIn, @DataCheckOut)) + ((@ValorAcomodacao * 10/100) * @Acompanhantes));

END;