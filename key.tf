## keypair create
resource "aws_key_pair" "terraform-key" {
  key_name = "mysoldesktestkey"
  public_key = file("./mysoldesktestkey.pub")
}
