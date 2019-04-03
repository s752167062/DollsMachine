package com.yr.ufoc.http.event;

public class Server {
    String mIp;
    int mPort;

    public Server(String ip, int port){
            this.mIp = ip;
            this.mPort = port;
    }

    public String getIp() {
        return mIp;
    }

    public int getPort() {
        return mPort;
    }
}