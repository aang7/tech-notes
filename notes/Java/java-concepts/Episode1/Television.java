package Episode1;

public class Television {
    // atributos de Television
    String marca;
    String modelo;
    int pulgadas;
    boolean encendido = false;

    // métodos de Television
    void encender() {
        encendido = true;
        System.out.println("Encendiendo la televisión");
    }

    void apagar() {
        encendido = false;
        System.out.println("Apagando la televisión");
    }

    void cambiarCanal(int canal) {
        System.out.println("Cambiando al canal " + canal);
    }

    void subirVolumen() {
        System.out.println("Subiendo el volumen");
    }

    void bajarVolumen() {
        System.out.println("Bajando el volumen");
    }
    
}
