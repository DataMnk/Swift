import Foundation

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

var barreras: [Shape] = []
var objetivos: [Shape] = []
let bola = OvalShape(width: 50, height: 40)

/*let anchoBarrera = 200.0
let altoBarrera = 25.0

let puntosBarrera = [//el orden de los puntos importa, son las esquinas de la barrera.
    Point(x:0, y:0),
    Point(x:0, y:altoBarrera),

    Point(x:anchoBarrera, y:altoBarrera),
    Point(x:anchoBarrera, y:0)
]
let barrera = PolygonShape(points: puntosBarrera)
*/
let puntosEmbudo = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let embudo = PolygonShape(points: puntosEmbudo)
/*
let puntosObjetivo = [
    Point(x: 10, y: 0),
    Point(x: 0, y: 10),
    Point(x: 10, y: 20),
    Point(x: 20, y: 10)
]
let objetivo = PolygonShape(points: puntosObjetivo)
*/



fileprivate func generarBola() {
    //bola: Creamos instance de Point y lo agregamos a la escena
    bola.position = Point(x: 250, y: 400)
    scene.add(bola)
    bola.hasPhysics = true
    bola.fillColor = .orange
    bola.isDraggable = false
    
    scene.trackShape(bola)
    bola.onExitedScene = bolaSalioDeEscena // !!Sin los parentesis
       
    
    bola.onCollision = bolaColisiona(with: )
    
    bola.bounciness = 0.6
    
}

fileprivate func agregarBarrera(at position: Point, width: Double, height: Double, angle: Double) {
    // Paso 2 agregado despues de modificar la funcion original
    let barreraPuntos = [
        Point(x: 0, y: 0),
        Point(x:0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrera = PolygonShape(points: barreraPuntos)
    
    barreras.append(barrera)
    //agregamos barrera a la escena (instance de Point) Paso 1
    barrera.position = position
    //barrera.position = Point(x: 200, y: 150)
    barrera.hasPhysics = true
    scene.add(barrera)
    barrera.isImmobile = true
    barrera.fillColor = .darkGray
    //barrera.angle = 0.1
    barrera.angle = angle
}

fileprivate func generarEmbudo() {
    //agregamos embudo a la escene (instance de Point)
    embudo.position = Point(x: 200, y: scene.height - 25)
    scene.add(embudo)
    embudo.onTapped = soltarBola //callback: no uso soltarBola() porque poner parentesis llamaria la funcion.
    embudo.fillColor = .lightGray
    embudo.isDraggable = false
}

func agregarObjetivo(at position: Point){
    //Paso 2: para usar multiples objetivos en un arreglo
    let objetivoPuntos = [
        Point(x: 10, y: 0),
        Point(x:0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let objetivo = PolygonShape(points: objetivoPuntos)
    
    objetivos.append(objetivo)
    
    
    //Paso 1
    objetivo.position = position
    objetivo.hasPhysics = true
    objetivo.isImmobile = true
    objetivo.isImpermeable = false
    objetivo.fillColor = .white
    
    scene.add(objetivo)
    
    objetivo.name = "target"
   // objetivo.isDraggable = false
}

func bolaColisiona(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

func bolaSalioDeEscena(){
    var conteoObjetivos = 0
    for objetivo in objetivos {
        if objetivo.fillColor == .green {
            conteoObjetivos += 1
        }
    }
    
   
    for barrera in barreras{
        barrera.isDraggable = true
    }
    
    if conteoObjetivos == objetivos.count {
        print("Ganaste el juego!")
    }
    print(conteoObjetivos)
}


func setup() {
    generarBola()
    generarEmbudo()
    
    agregarBarrera(at: Point(x: 175, y: 100), width: 80,
       height: 25, angle: 0.1)
    agregarBarrera(at: Point(x: 100, y: 150), width: 30,
       height: 15, angle: -0.2)
    agregarBarrera(at: Point(x: 325, y: 150), width: 100,
       height: 25, angle: 0.03)
    
    agregarObjetivo(at: Point(x: 184, y: 563))
    agregarObjetivo(at: Point(x: 238, y: 624))
    agregarObjetivo(at: Point(x: 269, y: 453))
    agregarObjetivo(at: Point(x: 213, y: 348))
    agregarObjetivo(at: Point(x: 113, y: 267))
   
    bola.onTapped = resetGame
    resetGame()
    scene.onShapeMoved = printPosition(of:)
       
}

//suelta la bola al moverla en la posicion del embudo
func soltarBola(){
  bola.position = embudo.position
  bola.stopAllMotion()
  for barrera in barreras{
    barrera.isDraggable = false
  }
    
    for objetivo in objetivos {
        objetivo.fillColor = .lightGray
    }
}

func resetGame() {
    bola.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}


