class Planta {
	const property altura
	const anio
	
	method tolerancia()
	
	method fuerte() {
		return self.tolerancia() > 10
	}
	
	method daNuevaSemilla() {
		return self.fuerte() or self.daNuevaSemillaAlternativamente()
	} 
	
	method espacio()
	method daNuevaSemillaAlternativamente()

	method esIdeal(parcela)  {
		return false
	}
	
}

class Menta inherits Planta {
	
	override method tolerancia() {
		return 6
	}
	
	override method espacio() {
		return altura * 3
	}
	
	override method daNuevaSemillaAlternativamente() {
		return altura > 0.4
	}
	
	override method esIdeal(parcela) {
		return parcela.superficie() > 6
	}
	
}

class Soja inherits Planta {
	
	override method tolerancia() {
		return if ( altura < 0.5 ) 6
				else if ( altura.between(0.5, 1)) 7
				else 9
	}
	
	override method espacio() {
		return altura / 2
	}
	
	override method daNuevaSemillaAlternativamente() {
		return anio > 2007 and altura > 1
	}
	
	override method esIdeal(parcela) {
		return self.tolerancia() == parcela.horasSol()
	}
		
}

class SojaTransgenica inherits Soja {
	
	override method daNuevaSemilla() {
		return false
	}
	
	override method esIdeal(parcela) {
		return parcela.cantidadMaxima() == 1
	}
}

class Hierbabuena inherits Menta {
	
	override method espacio() {
		return super() * 2
	}
	
}

class Quinoa inherits Planta {
	
	const property tolerancia
	
	override method espacio() {
		return 0.5
	}
	override method daNuevaSemillaAlternativamente() {
		return anio < 2005
	}
	
	override method esIdeal(parcela) {
		return parcela.ningunaSupera(1.5)
	}
	
}

class Parcela {
	const ancho
	const largo
	const property horasSol
	const property plantas = #{}
	
	method superficie() {
		return ancho * largo
	}
	
	method cantidadMaxima() {
		return (if (ancho > largo) {
					self.superficie() / 5
				}
				else {
					self.superficie() / 3 + largo
				}).truncate(0)
	}
	
	method complicaciones() {
		return plantas.any({planta=> planta.tolerancia() < horasSol })
	}
	
	method hayEspacio() {
		return plantas.size() < self.cantidadMaxima() 
	}
	
	method esMuyFuertePara(planta) {
		return horasSol >= (planta.tolerancia() + 2)
	}
	
	method validarPlantar(planta) {
		if(not self.hayEspacio()) {
			self.error("no se puede plantar porque no hay espacio. Cantidad Maxima: " + self.cantidadMaxima() + " cantidad de plantas " + plantas.size())
		}
		
		if(self.esMuyFuertePara(planta)) {
			self.error("no se puede plantar la planta " + planta + " porqe es muy fuerte, tolerancia " + planta.tolerancia() + " horas de sol : " + horasSol)
		}
	}
	
	method plantar(planta) {
		self.validarPlantar(planta)
		plantas.add(planta)	
	}
	
	method ningunaSupera(altura) {
		return plantas.all({planta => planta.altura() <= altura})
	}
	
	method seAsociaBien(planta) {
		return false
	} 
	
}

class ParcelaEcologica inherits Parcela {
	override method seAsociaBien(planta) {
		return not self.complicaciones() and planta.esIdeal(self)
	}
}

class ParcelaIndustrial inherits Parcela {
	override method seAsociaBien(planta) {
		return self.cantidadMaxima() > 2 and planta.fuerte()
	}	
}





