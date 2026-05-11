# Mini E-Wallet Deployment Notes

## Jenkins modes

- `DEPLOY_MODE=backend-only`: build and deploy only the FastAPI backend to the App EC2 instance.
- `DEPLOY_MODE=full`: deploy the backend first, then build and deploy the Nginx/React web container after `ILB_DNS` is available.

## Existing ECR repositories

- App image: `314146333464.dkr.ecr.ap-southeast-1.amazonaws.com/ewallet-backend`
- Web image: `314146333464.dkr.ecr.ap-southeast-1.amazonaws.com/ewallet-frontend`

Do not rename or recreate these repositories.

## Jenkins credentials

- `ssh-ec2-key`: SSH private key for App EC2 and Web EC2.
- `db-credential`: RDS username and password.

Do not configure AWS access keys in Jenkins. Jenkins EC2 should use an IAM Role for ECR push access.

## App and Web EC2 prerequisites

The App EC2 and Web EC2 instances pull private images from ECR during deployment. Each instance needs:

- AWS CLI
- Docker
- Docker Compose plugin
- IAM Role with `AmazonEC2ContainerRegistryReadOnly`

## Runtime configuration

Jenkins creates runtime `.env` files on the target EC2 instances:

- `/opt/ewallet/backend/.env`
- `/opt/ewallet/frontend/.env`

Do not commit real `.env` files to Git.
