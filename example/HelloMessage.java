import org.omnetpp.simkernel.*;

class HelloMessage extends JMessage implements Cloneable {

    protected int counter = 0;
    protected String text = "Hello";

    public HelloMessage(String name) {
        super(name);
    }

    public int getTimesRead() {
        return counter++;
    }

    public String getText() {
        return text;
    }

    public void setText(String value) {
        text = value;
    }

    public static HelloMessage cast(cPolymorphic o) {
        return (HelloMessage)JMessage.cast(o);
    }

    public String toString() {
        return "text=\"" + text + "\"  counter=" + counter;
    }
};




