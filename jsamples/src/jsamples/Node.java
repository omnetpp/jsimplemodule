package jsamples;

import org.omnetpp.simkernel.JSimpleModule;
import org.omnetpp.simkernel.SimTime;
import org.omnetpp.simkernel.cObjectFactory;
import org.omnetpp.simkernel.cMessage;

public class Node extends JSimpleModule {

    protected void initialize() {
        scheduleAt(new SimTime(1), new cMessage("timer"));
    }

    protected void handleMessage(cMessage msg) {
        if (msg.getClassName().equals("example::NetworkPacket")) {
            ev.println("source=" + msg.getField("source"));
            ev.println("destination=" + msg.getField("destination"));
            ev.println("payload=" + msg.getField("payload"));
        }
        msg.delete();

        cMessage pk = cMessage.cast(cObjectFactory.createOne("example::NetworkPacket"));
        pk.setField("source", "1");
        pk.setField("destination", "2");
        pk.setField("payload", "0100100011110101010101101110101001011111010101101010101100...");
        send(pk, "out");
    }
}
