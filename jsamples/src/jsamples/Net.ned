package jsamples;

import JSimpleModule;

network Net1
{
    submodules:
        tic: Txc;
        toc: Txc;
    connections:
        tic.out --> {  delay = 1ms; } --> toc.in;
        tic.in <-- {  delay = 1ms; } <-- toc.out;
}

network Net2
{
    submodules:
        src: Source {
            @display("p=100,100");
        }
        sink: Sink {
            @display("p=300,100");
        }
    connections:
        src.out --> sink.in;
}

network Net3
{
    parameters:
        int queueNumInitialJobs;
        volatile double queueServiceTime @unit(s);
    submodules:
        src: Source {
            @display("p=100,100");
        }
        fifo: Fifo {
            @display("p=300,100");
        }
        sink: Sink {
            @display("p=500,100");
        }
        connections:
        src.out --> fifo.in;
        fifo.out --> sink.in;
}

network Net4
{
    parameters:
        int numQueues;
        int queueNumInitialJobs;
        volatile double queueServiceTime @unit(s);
    submodules:
        src: Source {
            @display("p=100,200");
        }
        fork: Fork {
            @display("p=200,200");
        }
        fifo[numQueues]: Fifo {
            @display("p=300,80,c");
        }
        join: Join {
            @display("p=400,200");
        }
        count: CountHellos {
            @display("p=500,200");
        }
        sink: Sink {
            @display("p=600,200");
        }
    connections:
        src.out --> fork.in;

        for i=0..numQueues-1 {
            fork.out++ --> fifo[i].in;
            fifo[i].out --> join.in++;
        }

        join.out --> count.in;
        count.out --> sink.in;
}

network Net5
{
    submodules:
        node1: Node {
            @display("p=100,100");
        }
        node2: Node {
            @display("p=300,100");
        }
    connections:
        node1.out --> node2.in;
        node1.in <-- node2.out;
}
