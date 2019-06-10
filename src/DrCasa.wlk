class Enfermedades{
	var celulasAmenazadas
	var diasPersona
	
	constructor(celulas){
		celulasAmenazadas = celulas
	}
	
	method pasarDia(persona){
		diasPersona++
		self.provocarEfectos(persona)
	}
	
	method provocarEfectos(persona)
	method esAgresiva(persona)
	
	method celulaAmenazadas() = celulasAmenazadas
	method diasInfectados() = diasPersona
}

class EnfermedadInfecciosa inherits Enfermedades{
	override method provocarEfectos(persona){
		persona.aumentarTemperatura(celulasAmenazadas * 0.01)
	}
	
	method reproducir(){
		celulasAmenazadas *= 2
	}
	
	override method esAgresiva(persona){
		return celulasAmenazadas > persona.celulas() * 0.10
	}
}


class EnfermedadAutoinmune inherits Enfermedades{
	override method esAgresiva(enfermedad){
		return diasPersona > 30
	}
	
	override method provocarEfectos(persona){
		persona.perderCelulas(celulasAmenazadas)
	}
	
}


class Persona{
	var enfermedades
	var celulas
	var temperatura
	
	constructor(_temperatura, _celulas, _enfermedades){
		temperatura = _temperatura
		celulas = _celulas
		enfermedades = _enfermedades
	}
	
	method contraerEnfermedad(enfermedad){
		enfermedades.add(enfermedad)	
	}
	
	method aumentarTemperatura(grados){
		temperatura = grados 
	}
	method congelar(){ temperatura = 0}
	method enComa(){ return temperatura > 45 }
	
	method pasarDia(){
		enfermedades.forEach({enfermedad => enfermedad.pasarDia(self)})
	}
	
	method enfermedadesAgresivas(){
		return enfermedades.filter({enfermedad => enfermedad.esAgresiva(self)})
	}
	
	method celulasAfectadas(){
		return self.enfermedadesAgresivas().sum({enfermedad => enfermedad.celulaAmenazadas()})	
	}
	
	method perderCelulas(cantidad){
		celulas -= cantidad
	}
	
	method enfermedadDura(){
		return enfermedades.max({enfermedad => enfermedad.celulaAmenazadas()})
	}
	
	method atenuarse(){
		enfermedades.forEach({enfermedad => enfermedad.atenuarse(dosis*15)})
	}
	
	method celulas(){ return celulas } //method celulas() = celulas
	
	method enfermedades(){ return enfermedades }
}

class Medico inherits Persona{
	var dosis
	constructor(_temperatura,_celulas,_enfermedadesIniciales,_dosis) =
		super(_temperatura, _celulas,_enfermedadesIniciales){
		dosis = _dosis
	}
	
	override method contraerEnfermedad(enfermedad){
		super(enfermedad)
		self.atenuar(self)
	}
	
	method atenuar(persona){
		persona.Medicarse(dosis)
	}
	
}

class JefeDeDepartamento inherits Medico{
	var empleados
	
	override method atenuar(paciente){
		if(empleados.isEmpty()){
			throw new NoHayEmpleadosException("El jefe no tiene empleados para atender a las personas")
		}
		empleados.anyOne().atenuar(paciente)
	}
	method contratar(empleado){
		empleados.add(empleado)
	}
	
}

object muerte{
	method esAgresiva(persona){
		return true
	}
	
	method pasarDia(persona){
		self.provocarEfectos(persona)
	}
	method provocarEfectos(persona){
		persona.congelar()
	}
}












