package Episode1;

public class Persona {
    // atributos de Persona
    String nombre;
    int edad;
    String genero;

    // métodos de Persona
    void correr() {
        System.out.println("Estoy corriendo");
    }

    void saludar() {
        System.out.println("Hola, soy " + nombre);
    }

    static void despedir() {
        System.out.println("Adiós");
    }
}