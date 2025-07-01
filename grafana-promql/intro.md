<table style="border-collapse: collapse; border: none;">
  <tr>
    <td style="border: none;">
      <div style="background-color: #ffffff; padding: 0;">
        <img src="./images/grot.png"
             alt="Grot the Grafana Dino"
             style="max-width: 100px; float: left; margin: 0 12px 8px 0;" />
        <div style="overflow: hidden;">
          <p style="margin: 0;">
            <strong>Welcome to your interactive Grafana & Prometheus Lab!</strong>
          </p>
        </div>
      </div>
    </td>
  </tr>
</table>

> **Lab Startup**  
> Wait until the dots stop moving before proceeding. When setup is complete, you’ll see a big Grafana logo in your terminal.


Access Grafana and Prometheus with these links:

- [Grafana Server]({{TRAFFIC_HOST1_3000}})
- [Prometheus UI]({{TRAFFIC_HOST1_9090}})

You can generate some system load by running this command in the terminal. It will drive CPU usage up to 80% for 60 seconds.

`stress-ng --cpu 1 --cpu-load 80 --timeout 60s`{{exec}}

You can also use the `btop` command to monitor system resources in real-time. You can leave `btop` running and open a new terminal tab to run commands. This is a great way to see how your system is performing while you explore Grafana and Prometheus.

Happy exploring and happy observing! 🎉
