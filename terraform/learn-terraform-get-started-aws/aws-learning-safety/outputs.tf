output "budget_name" {
  value = aws_budgets_budget.learning.name
}

output "aws_region" {
  value = var.aws_region
}