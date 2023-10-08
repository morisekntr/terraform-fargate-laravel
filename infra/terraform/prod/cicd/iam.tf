// CircleCI用のユーザ
resource "aws_iam_user" "circleci" {
  name = "${var.project}-ci-user"
}
resource "aws_iam_policy" "circleci_deploy" {
  name   = "${var.project}-ci-deploy-policy"
  policy = data.aws_iam_policy_document.circleci_deploy.json
}

resource "aws_iam_user_policy_attachment" "circleci_deploy" {
  user       = aws_iam_user.circleci.name
  policy_arn = aws_iam_policy.circleci_deploy.arn
}

// まだ動作確認していない
data "aws_iam_policy_document" "circleci_deploy" {
  statement {
    sid    = "VisualEditor0"
    effect = "Allow"
    resources = [
      data.aws_ecr_repository.web.arn,
      data.aws_ecr_repository.app.arn,
    ]
    actions = [
      "ecr:PutImageTagMutability",
      "ecr:DescribeImageScanFindings",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:PutImageScanningConfiguration",
      "ecr:ListTagsForResource",
      "ecr:UploadLayerPart",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy",
    ]
  }
  statement {
    sid    = "VisualEditor1"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "iam:PassRole",
      "ecr:GetAuthorizationToken",
      "ecs:ListServices",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:DescribeTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:RegisterTaskDefinition",
      "ecs:ListTasks", # container-instanceを指定すれば動きそうだが何故かだめ
    ]
  }
  statement {
    sid    = "VisualEditor2"
    effect = "Allow"
    resources = [
      var.circleci_deploy_ecs_clurster_arn,
      var.circleci_deploy_ecs_service_arn,
    ]
    actions = [
      "ecs:ListAttributes",
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:DescribeContainerInstances",
      "ecs:TagResource",
      "ecs:DescribeTasks",
      "ecs:UntagResource",
      "ecs:DescribeClusters",
      "ecs:ListTagsForResource",
      "ecs:ListContainerInstances",
    ]
  }
}