<img src="./images/grot.png"
     alt="Grot - the Grafana Dino Robot Mascot"
     style="float: left; margin: 0 10px 10px 0; max-width: 200px;" />

Welcome to your interactive Grafana & Prometheus lab!

This environment lets you gets hands-on with Prometheus and Grafana. When setup is complete, you’ll see the Grafana logo in your terminal.

Open the hamburger menu (☰) in the upper‑right to access Grafana (port 3000) and Prometheus (port 9090).

You can generate some system load by running this command in the terminal. It will drive CPU usage up to 80% for 60 seconds.

`stress-ng --cpu 1 --cpu-load 80 --timeout 60s`{{exec}}

You can also use the `btop` command to monitor system resources in real-time. You can leave `btop` running and open a new terminal tab to run commands. This is a great way to see how your system is performing while you explore Grafana and Prometheus.

Happy exploring and happy observing! 🎉
