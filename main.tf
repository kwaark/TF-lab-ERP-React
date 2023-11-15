provider "google" {
  project = "240826606375"
  credentials = file("~/.config/gcloud/application_default_credentials.json")
}

data "google_compute_network" "default" {
  project = "240826606375"
  name = "default"
}

resource "google_compute_instance" "vm_instance" {
  name         = "neo"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    
    access_config {
      nat_ip = google_compute_address.address.address
    }
  }


  metadata_startup_script = <<-EOF
    #!/bin/bash

    # Instalações
sudo apt update
sudo apt install -y git
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y nginx

    # Baixar repositório e entrar na pasta do projeto
git clone https://github.com/kwaark/lab-ERP-React.git
cd /
cd lab-ERP-React/
sudo npm install
    
    # Start Nginx/React
systemctl start nginx
sudo npm start

    # Teste
echo '[Unit]
Description=react app

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/lab-ERP-React
Restart=always
User=root

[Install]
WantedBy=multi-user.targetH' | sudo tee /etc/systemd/system/react-app.service

sudo systemctl daemon-reload
sudo systemctl start react-app

  EOF
  
  service_account {
    scopes = ["cloud-platform"]
    email = "default"
  }
}

resource "google_compute_address" "address" {
  name         = "external-ip"
  project      = "240826606375"
  region       = "us-central1"
  address_type = "EXTERNAL"
}

resource "google_compute_firewall" "firewall-internet" {
  name    = "allow-internet"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  source_ranges = ["0.0.0.0/0"]
}
