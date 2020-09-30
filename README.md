# Splunk TA journald

This TA is a very simple method to collect the Linux journald logs into Splunk. It was created to quickly onboard Linux events without reverting back to installing rsyslogd to read from the journal. If you need the journald logs from endpoints not running Splunk Universal Forwarder, this solution is not for you!

## Implementation details
- It's implemented using a simple bash script called from a scripted input.
- Events are pulled from journald every 30 seconds using journalctl.
- The events are retreived in JSON format and the provided input configuration handles this accordingly.
- The script maintains state so that you don't end up with duplicate events.
- On the first run it will only pull todays events from the journal.

## Deployment
The TA can be pushed to all Splunk components in your architecture:
- Universal Forwarders
- Indexers
- Search Heads
- Management instances (license master, deployer, cluster master, etc)
