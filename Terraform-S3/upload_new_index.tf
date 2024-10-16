# index_modified.html 파일을 S3 버킷에 업로드 (새로운 파일 추가)
resource "aws_s3_object" "index" {
  bucket        = aws_s3_bucket.bucket1.id  # 기존 S3 버킷
  key           = "index.html"
  source        = "index.html"  # 새로 추가할 index.html 경로
  content_type  = "text/html"
}