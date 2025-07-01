<table style="border-collapse: collapse; margin-bottom: 8px;">
  <tr>
    <td style="padding: 4px;">
      <img src="./images/grot.png"
           alt="Grot the Grafana Dino"
           style="float: left; max-width: 100px; margin: 0 12px 4px 0;" />
      <span style="display: inline-block; height: 0px;"></span><br />
      <strong>Welcome to your interactive Grafana Java OTEL lab!</strong>
    </td>
  </tr>
</table>

> **Lab Startup**  
> Wait until the dots stop moving before proceeding. When setup is complete, you’ll see a big Grafana logo in your terminal.

The Spring Petclinic JAR file and the Grafana OpenTelemetry Java Agent have been downloaded to your home directory.

Follow the instructions in the Grafana Cloud Connections Integration for Java to configure Alloy to receive telemetry from the Spring Petclinic application.

Then, start Spring Pet Clinic with the following commands. 

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_SERVICE_NAME=petclinic
export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production
java -javaagent:grafana-opentelemetry-java.jar -jar spring-petclinic.jar
```{exec}

Next, use the Killercoda port forwarder to open a new browser tab pointed at 8080, the port that Spring Pet Clinic runs on. Browse around the application to generate telemetry data and errors.

It will take a few minutes for the petclinic service to show up in Grafana Cloud App Observability.