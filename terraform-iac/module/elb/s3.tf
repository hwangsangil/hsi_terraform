resource "aws_s3_bucket" "accesslog_s3" {
  bucket = "${local.prefix}-${local.product}-${local.env}-accesslog-s3"

  tags = {
    Name = "${local.prefix}-${local.product}-${local.env}-accesslog-s3"
  }
}

resource "aws_s3_object" "pri_alb_folder" {
  bucket       = aws_s3_bucket.accesslog_s3.id
  key          = "${aws_lb.pri_alb.name}/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "pub_alb_folder" {
  bucket       = aws_s3_bucket.accesslog_s3.id
  key          = "${aws_lb.pub_alb.name}/"
  content_type = "application/x-directory"
}
resource "aws_s3_bucket_policy" "s3_bucket_accesslog_policy" {
  bucket = aws_s3_bucket.accesslog_s3.id
  policy = <<EOT
     {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::600734575887:root"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "${aws_s3_bucket.accesslog_s3.arn}/${aws_lb.pri_alb.name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
                "${aws_s3_bucket.accesslog_s3.arn}/${aws_lb.pub_alb.name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
            ]
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.accesslog_s3.arn}",
                "${aws_s3_bucket.accesslog_s3.arn}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1694761957311",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.accesslog_s3.arn}/*"
        }
      ]
    }
EOT
}


