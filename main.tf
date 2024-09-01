/// EC2 Instance
resource "aws_instance" "demo-instance" {
  ami               = "ami-0d07675d294f17973"
  availability_zone = "ap-southeast-1a"
  instance_type     = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
}


///S3 Bucket///
resource "aws_s3_bucket" "terraform-state" {
  bucket = "makisam-backend" /// Name of the bucket. If omitted, Terraform will assign a random, unique name.
  tags = {
    Name = "terraform-state-bucket"
  }
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false /// Whether to prevent accidental destruction of the resource and cause Terraform to reject with an error any plan that would destroy the resource
  }

}

/// config for state file

resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "publick-access" {
  bucket                  = aws_s3_bucket.terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

//// Dynamo DB for locking terraform

resource "aws_dynamodb_table" "terraform-lock" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S" /// string Type
  }
}

