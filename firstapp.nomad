job "FirstApp" {
  datacenters = ["westeurope"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "dotnet" {
    count = 2
    task "firstapp" {
      driver = "exec"

      config {
        command = "dotnet"
        args = ["/local/appv1/FirstApp.dll"]
      }

      artifact {
        source = "git::https://github.com/bondido/firstapp/appv1.tar.gz"
      }
      resources {
        cpu    = 100 # 100 MHz
        memory = 100 # 100MB
        network {
          mbits = 10
          port "netcore" {
            static = "5000"
          }
        }
      }
      service {
        name = "firstapp"
        tags = []
        port = "netcore"
        check {
          name     = "http alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
