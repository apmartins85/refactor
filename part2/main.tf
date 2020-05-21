provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}


resource "aws_launch_configuration" "helloworld" {
    image_id=  "${var.ami}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.websg.id}"]
    key_name = "${var.pub_key}"
    user_data = "${file("user-data/dockerImage.sh")}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "scalegroup" {
    launch_configuration = "${aws_launch_configuration.webcluster.name}"
    availability_zones = ["us-east-1a"]
    min_size = 1
    max_size = 4
    enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
    metrics_granularity="1Minute"
    load_balancers= ["${aws_elb.elb1.id}"]
    health_check_type="ELB"
    tag {
        key = "Name"
        value = "helloworld8080"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "helloword-8080" {
    name = "security_group_for_web_server"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "elbsg" {
    name = "security_group_for_elb"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "elb1" {
    name = "terraform-elb"
    availability_zones = ["us-east-1a"]
    security_groups = ["${aws_security_group.elbsg.id}"]

    listener {
        instance_port = 8080
        instance_protocol = "http"
        lb_port = 8080
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:8080"
        interval = 30
    }

    tags {
        Name = "terraform-elb"
    }
}