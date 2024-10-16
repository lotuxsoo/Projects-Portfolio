# provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# S3 버킷 생성
resource "aws_s3_bucket" "bucket1" {
  bucket = "ce32-02"  # 생성하고자 하는 S3 버킷 이름
}

# S3 버킷의 public access block 설정
resource "aws_s3_bucket_public_access_block" "bucket1_public_access_block" {
  bucket = aws_s3_bucket.bucket1.id

  block_public_acls       = false
  block_public_policy     = false  # 퍼블릭 정책 차단 해제
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 버킷의 웹사이트 호스팅 설정
resource "aws_s3_bucket_website_configuration" "xweb_bucket_website" {
  bucket = aws_s3_bucket.bucket1.id

  index_document {
    suffix = "index.html"
  }
}

# S3 버킷의 public read 정책 설정
resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket1.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "arn:aws:s3:::ce32-02",
        "arn:aws:s3:::ce32-02/*"
      ]
    }
  ]
}
EOF
}

output "website_endpoint" {
  value       = aws_s3_bucket.bucket1.website_domain
  description = "The endpoint for the S3 bucket website."
}