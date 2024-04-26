blue-apply:
	terraform apply -var 'traffic_distribution=blue' -var 'enable_green_env=true' --auto-approve

blue-90-apply:
	terraform apply -var 'traffic_distribution=blue-90' -var 'enable_green_env=true' --auto-approve

split-apply:
	terraform apply -var 'traffic_distribution=split' -var 'enable_green_env=true' --auto-approve

green-apply:
	terraform apply -var 'traffic_distribution=green' -var 'enable_green_env=true' --auto-approve

green-90-apply:
	terraform apply -var 'traffic_distribution=green-90' -var 'enable_green_env=true' --auto-approve

blue-destroy:
	terraform destroy -var 'traffic_distribution=blue' -var 'enable_green_env=true' --auto-approve

blue-90-destroy:
	terraform destroy -var 'traffic_distribution=blue-90' -var 'enable_green_env=true' --auto-approve

split-destroy:
	terraform destroy -var 'traffic_distribution=split' -var 'enable_green_env=true' --auto-approve

green-destroy:
	terraform destroy -var 'traffic_distribution=green' -var 'enable_green_env=true' --auto-approve

green-90-destroy:
	terraform destroy -var 'traffic_distribution=green-90' -var 'enable_green_env=true' --auto-approve

split-destroy:
	terraform destroy -var 'traffic_distribution=split' -var 'enable_green_env=true' --auto-approve