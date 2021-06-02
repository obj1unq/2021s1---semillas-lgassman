class Planta {
	
	const anio
	const altura
	
	method tolerancia()
	
	method fuerte() {
		return self.tolerancia() > 10
	}
	
	method daSemillas() {
		return self.fuerte() or self.daSemillasAlternativamente()
	}
	
	method espacio()
	
	method daSemillasAlternativamente()
}

class Menta inherits Planta {
	override method tolerancia() {
		return 5
	}
	
	override method espacio() {
		return altura * 3
	}
	
	override method daSemillasAlternativamente() {
		return altura > 0.4
	}
	
}

class Soja inherits Planta {
	override method tolerancia() {
		return if (altura < 0.5) 6 
				else if (altura.between(0.5,1)) 7 
				else 9 
	}
	
	override method espacio() {
		return altura / 2
	}
	
	override method daSemillasAlternativamente() {
		return anio > 2007 and altura > 1
	}
}


class Quinoa inherits Planta {
	
	const property tolerancia
	
	override method espacio() {
		return 0.5
	}
	
	override method daSemillasAlternativamente() {
		return anio < 2005
	}
}


