<table style="border-collapse: collapse; margin-bottom: 8px;">
  <tr>
    <td style="padding: 4px;">
      <img src="./images/grot.png"
           alt="Grot the Grafana Dino"
           style="float: left; max-width: 100px; margin: 0 12px 4px 0;" />
      <span style="display: inline-block; height: 0px;"></span><br />
      <strong>Welcome to your interactive Grafana & Prometheus lab!</strong>
    </td>
  </tr>
</table>

> **Lab Startup**  
> Wait until the dots stop moving before proceeding. When setup is complete, you’ll see a big Grafana logo in your terminal.

Access Grafana and Prometheus with these links:

- [Grafana Server]({{TRAFFIC_HOST1_3000}})
- [Prometheus UI]({{TRAFFIC_HOST1_9090}})

Grafana login credentials:
- **Username:** admin
- **Password:** grafana

You can generate some system load by running this command in the terminal. It will drive CPU usage up to 80% for 60 seconds.

`stress-ng --cpu 1 --cpu-load 80 --timeout 60s`{{exec}}

The following command will use a gigabyte of memory for 60 seconds. This causes a simultaneous spike in CPU usage.

`stress-ng --vm 1 --vm-bytes 1G --timeout 60s`{{exec}}

You can also use the `btop` command to monitor system resources in real-time. Leave `btop` running and open a new terminal tab to run commands. This is a great way to see how your system is performing while you explore Grafana and Prometheus.

Happy exploring and happy observing! 🎉
