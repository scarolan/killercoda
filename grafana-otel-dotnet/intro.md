<table style="border-collapse: collapse; margin-bottom: 8px;">
  <tr>
    <td style="padding: 4px;">
      <img src="./images/grot.png"
           alt="Grot the Grafana Dino"
           style="float: left; max-width: 100px; margin: 0 12px 4px 0;" />
      <span style="display: inline-block; height: 0px;"></span><br />
      <strong>Welcome to your interactive Grafana .NET OTEL lab!</strong>
    </td>
  </tr>
</table>

> **Lab Startup**  
> Wait until the dots stop moving before proceeding. When setup is complete, you'll see a big Grafana logo in your terminal.

An ASP.NET Core Web API application has been created in your home directory with Grafana OpenTelemetry .NET instrumentation already installed. The sample application uses the official Grafana.OpenTelemetry package to automatically instrument telemetry collection.

Follow the instructions in the Grafana Cloud Connections Integration for .NET to configure Alloy to receive telemetry from the Todo API application. You'll need to:

1. Log in to your Grafana Cloud account
2. Navigate to the Connections page
3. Find the .NET integration
4. Follow the setup instructions to configure Alloy as a receiver

When you're ready to test the application, start the Todo API with the following command:

```bash
~/start-app.sh
```{{exec}}

The startup script sets the necessary environment variables:
- OTEL_SERVICE_NAME=dotnet-todoapi
- OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production
- OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
- OTEL_EXPORTER_OTLP_PROTOCOL=grpc
- ASPNETCORE_URLS=http://0.0.0.0:8080

Next, use the Killercoda port forwarder to open a new browser tab pointed at 8080, the port that the Todo API runs on. You can interact with the API using the Swagger UI, which is available at the root URL.

To generate sample telemetry data, try the following:
- Browse the Swagger UI to explore available endpoints
- Try out the endpoints in the Todo section of the UI
- Add a todo list item
- GET the list from /api/todo/items

While the app is running, you can observe:
- Auto-instrumentation of ASP.NET Core requests and responses
- Database operations tracking with Entity Framework Core
- Custom manual instrumentation in the code
- Automatic log correlation with traces
- Metrics collection

It will take a few minutes for the dotnet-todoapi service to show up in Grafana Cloud App Observability. Your instrumented application will start sending traces, metrics, and logs to Grafana Cloud via Alloy for a complete observability solution.
