module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  name = "magento-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_security_group.security_group_id]

  target_groups = [
    {
      name_prefix      = "magen-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        magento = {
          target_id = aws_instance.magento_instance.id
          port = 80
        }
      }
    },
    {
      name_prefix      = "varni-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        magento = {
          target_id = aws_instance.varnish_instance.id
          port = 6081
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
    },
  ]

  http_tcp_listener_rules = [
    # {
    #   priority = 1
    #   http_tcp_listener_index = 0
    #   actions = [{
    #     type        = "forward"
    #     target_group_index = 0
    #   }]
    #   conditions = [{
    #     path_patterns = ["/media/*", "/static/*"]
    #   }]
    # },
    {
      priority = 2
      http_tcp_listener_index = 0
      actions = [{
        type        = "forward"
        target_group_index = 0
      }]
      conditions = [{
        path_patterns = ["/*"]
      }]
    }
  ]
}