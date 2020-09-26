import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';

class MmmpServer {
  final String host;
  final String ip;
  final int port;

  MmmpServer({this.host, this.ip, this.port});
}

Future<void> discoverServers(Function callback) async {
  const String name = '_mmmp._tcp';

  // https://github.com/flutter/flutter/issues/27346
  var factory =
      (dynamic host, int port, {bool reuseAddress, bool reusePort, int ttl}) {
    return RawDatagramSocket.bind(host, port,
        reuseAddress: true, reusePort: false, ttl: ttl);
  };

  var client = MDnsClient(rawDatagramSocketFactory: factory);
  await client.start();

  int found = 0;

  await for (PtrResourceRecord ptr in client
      .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    await for (SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(ptr.domainName))) {
      await for (IPAddressResourceRecord ip
          in client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target))) {
        debugPrint('Service instance found at '
            '${srv.target}:${srv.port} with ${ip.address}.');

        callback(MmmpServer(
            host: srv.target, ip: ip.address.address, port: srv.port));
        found++;
      }
    }
  }
  client.stop();

  // if timeout with no servers found, callback with null
  if (found == 0) callback(null);
}
