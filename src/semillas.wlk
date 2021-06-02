class Planta {
	
	const anio
	const property altura
	
	method tolerancia()
	
	method fuerte() {
		return self.tolerancia() > 10
	}
	
	method daSemillas() {
		return self.fuerte() or self.daSemillasAlternativamente()
	}
	
	method espacio()
	
	method daSemillasAlternativamente()
	
	method ideal(parcela)
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
	
	override method ideal(parcela) {
		return parcela.superficie() > 6
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
	
	override method ideal(parcela) {
		return parcela.horasSol() == self.tolerancia()
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
	
	override method ideal(parcela) {
		return parcela.todasMenorA(1.5)
	}
	
}

class SojaTransgenica inherits Soja { 
	override method daSemillas() {
		return false
	}
	
	override method ideal(parcela) {
		return parcela.cantidadMaxima() == 1
	}
	
}

class Hierbabuena inherits Menta {
	override method espacio() {
		return super() * 2
	}
}

class Parcela {
	const ancho
	const largo
	const property horasSol
	const plantas = #{}
	
	method superficie() {
		return ancho * largo
	}
	
	method cantidadMaxima() {
		return (if (ancho > largo)  
					self.superficie() / 5 
				else 
					self.superficie() / 3 + largo).truncate(0)
	}
	
	method complicada() {
		return plantas.any({ planta => planta.tolerancia() < horasSol })
	}
	
	method validarPlantar(planta) {
		if ((horasSol - planta.tolerancia() >= 2 ) or (plantas.size() > self.cantidadMaxima() - 1)) {
			self.error("no se puede plantar " + planta)
		}
	}
	method plantar(planta) {
		self.validarPlantar(planta)
		plantas.add(planta)
	}
	
	method todasMenorA(altura) {
		return plantas.all({planta => planta.altura() <= altura})
	}
	
	method seAsociaBien(planta) {
		return false
	} 
	
	method cantidadPlantas() {
		return plantas.size()
	}
	
	method porcentajeBienAsociadas() {
		return plantas.count({planta => self.seAsociaBien(planta) }) / plantas.size()
	}
}

class ParcelaEcologica inherits Parcela {
	override method seAsociaBien(planta) {
		return not self.complicada() and planta.ideal(self)
	}
}

class ParcelaIndustial inherits Parcela {
	override method seAsociaBien(planta) {
		return self.cantidadMaxima() > 2 and planta.fuerte()
	}
}

object inta {
	const parcelas = #{}
	
	method addParcela(parcela) {
		parcelas.add(parcela)
	}
	
	method promedio() {
		return parcelas.sum({parcela => parcela.cantidadPlantas()}) / parcelas.size()
	}
	
	method masSustentable() {
		return parcelas.filter({parcela => parcela.cantidadPlantas() > 4}).max({parcela => parcela.porcentajeBienAsociadas()})
	}
	
}

