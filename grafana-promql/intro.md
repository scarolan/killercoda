<img src="./images/grot.png"
     alt="Grot - the Grafana Dino Robot Mascot"
     style="float: left; margin: 0 10px 10px 0; max-width: 200px;" />

Welcome to your interactive Grafana & Prometheus lab!

This environment lets you gets hands-on with Prometheus and Grafana. When setup is complete, you’ll see the Grafana logo in your terminal.

The lab starts on the console tab (Tab 1). You can run Linux commands in this terminal window.

Click on the **Editor** tab to access the Theia browser-based IDE. The Editor tab also includes a terminal where you can run commands.

Open the hamburger menu (☰) in the upper‑right to access Grafana and Prometheus on their respective ports. Prometheus is running on port 9090 and Grafana is running on port 3000.

You can generate some system load by running this command in the terminal. It will drive CPU usage up to 80% for 60 seconds.
```bash
stress-ng --cpu 1 --cpu-load 80 --timeout 60s
```

You can use the `btop` command to monitor system resources in real-time. This is a great way to see how your system is performing while you explore Grafana and Prometheus. Simply leave btop running and open a new terminal tab to run commands.

Happy exploring and happy observing! 🎉
