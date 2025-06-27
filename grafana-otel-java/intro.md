<img src="./images/grot.png"
     alt="Grot - the Grafana Dino Robot Mascot"
     style="float: left; margin: 0 10px 10px 0; max-width: 200px;" />

Welcome to the Grafana OpenTelemetry Java Lab!

The Spring Petclinic JAR file and the Grafana OpenTelemetry Java Agent have been downloaded to your home directory.

Follow the instructions in the Grafana Cloud Connections Integration for Java to configure Alloy to receive telemetry from the Spring Petclinic application.

Then, start Spring Petclinic with the following commands. 

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_SERVICE_NAME=petclinic
export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production
java -javaagent:grafana-opentelemetry-java.jar -jar spring-petclinic.jar
```

Next, use the Killercoda port forwarder to open a new browser tab pointed at 8080, the port that Spring Petclinic runs on. Browse around the application to generate telemetry data and errors.

It will take a few minutes for the petclinic service to show up in Grafana Cloud App Observability.