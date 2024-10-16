# 이미 존재하는 index.html 파일을 새로 수정된 파일로 교체
resource "aws_s3_object" "index_modified" {
  bucket        = aws_s3_bucket.bucket1.id
  key           = "index.html"
  source        = "index.html"
  content_type  = "text/html"

  # index.html 파일의 MD5 해시 값을 계산하여 etag로 설정
  # 파일이 변경되면 etag 값도 달라지기 때문에, Terraform은 이를 감지하고 S3에 파일을 재배포
  etag = filemd5("index.html")

  lifecycle {
    prevent_destroy = false
  }
}