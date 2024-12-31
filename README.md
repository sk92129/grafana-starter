# A Starter for Grafana

# to launch and run


docker-compose up -d

Grafana at http://localhost:3000 (username: admin, password: admin123)
Prometheus at http://localhost:9090
Loki at http://localhost:3100
Tempo at http://localhost:3200



## How to send data to the services:


To send data to these services:
For logs (Loki):
Use Promtail, Fluentd, or other log shippers
Configure them to send logs to http://localhost:3100/loki/api/v1/push
For traces (Tempo):
Configure your application's tracer to send traces to localhost:14250 using Jaeger gRPC protocol
Supports OpenTelemetry, Jaeger, and Zipkin formats
For metrics (Prometheus):
Add scrape configurations to prometheus.yaml
Use exporters or instrument your application with Prometheus client libraries
This setup provides a basic but functional monitoring stack. You can enhance it by:
Adding more data sources
Configuring retention policies
Setting up alerting
Adding dashboards
Implementing security measures
Adding service discovery



## to check the status of the services:

docker compose logs grafana

### to check if grafana is listening on port 3000:

docker compose exec grafana netstat -tulpn | grep 3000

### to check if grafana can be reached from inside the container:

docker compose exec grafana wget -q --spider http://localhost:3000

### to log into grafana:

http://localhost:3000/

userid: admin
password: admin123




![image](https://github.com/user-attachments/assets/532950de-bb66-4559-b569-e6b77c631ae3)






![image](https://github.com/user-attachments/assets/45deb8e5-fc3a-4df3-a3ca-f33fd7aaeb4e)

![image](https://github.com/user-attachments/assets/077a2146-cd52-412b-8e77-6648cee3d6f4)





