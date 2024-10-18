package Episode1;
import Episode1.Episode1_1.Animal;

import java.util.Scanner;

// un objeto en java es una clase instanciada
// en C te enseñan que es una función
// y en C++ te enseñan que es una clase
// en Java te enseñan que es una clase instanciada

// una clase puede tener atributos y métodos
public class Main {

    public static void main(String[] args) {
        
        // tipos de datos primitivos y no primitivos
        // primitivos: int, float, double, char, boolean
        // no primitivos: String, Integer, Float, Double, Character, Boolean
        String nombre; // guardame espacio para un string
        nombre = new String("Jonathan"); // llena el espacio con este valor
        System.out.printf("Hola, soy %s y mi nombre tiene %d letras\n", nombre, nombre.length()); // imprime el valor del espacio
        
        // instanciar un objeto
        Persona jonathan = new Persona(); // crea o instancia un objeto de la clase Persona
        jonathan.edad = 17;
        jonathan.nombre = "Jonathan";
        System.out.println(jonathan.edad);
        jonathan.saludar();

        Persona abel = new Persona();
        abel.edad = 28;
        abel.nombre = "Abel";
        System.out.println(abel.edad);
        abel.saludar();


        Television samsung = new Television();
        samsung.encender();
        Television lg = new Television();
        lg.encender();
        lg.cambiarCanal(5);
        lg.subirVolumen();
        lg.bajarVolumen();
        lg.apagar();
        Television sony = new Television();
        sony.encender();
        sony.cambiarCanal(10);

        Animal perro = new Animal();
        Animal gato = new Animal();
        Animal pajaro = new Animal();
        perro.comer();
        gato.dormir();
        pajaro.comer();


        Scanner scanner = new Scanner(System.in);
        // System es una clase
        // out es un objeto de la clase System
        // println es un método del objeto out
        System.out.println("Hola, mundo");
    }

}

